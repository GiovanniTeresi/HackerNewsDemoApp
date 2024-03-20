//
//  Favourites.swift
//  HackerNews
//
//  Created by Giovanni Teresi on 17/03/24.
//

import Foundation

//Questa classe serve per la gestione delle story preferite

class Favourite: ObservableObject {
    
//I due array servono a contenere gli id ddelle story segnate come preferite e le effettive story
//Il salvataggio in locale avviene solo per gli id, sia per una semplicità nell'archiviazione, in quanto un array di Int è ben più leggero e facilmente gestibile rispetto ad un array di struct, sia perchè qualora le story subissero delle variazioni, queste sarebbero visibili poichè l'array viene costruito all'avvioa partire dagli id
    @Published var favouritesIDs: [Int] = []
    @Published var favouritesStories: [Story] = []
    let apiNetwork = ApiNetwork()
    
//Questa funzione serve a salvare in locale l'array di id
    func saveFavs (id: Int) {
        favouritesIDs.append(id)
        UserDefaults.standard.set(favouritesIDs, forKey: "favourites")
    }
// Questa funzione serve a recuperare l'array
    func retrieveFavs() {
        favouritesIDs = UserDefaults.standard.array(forKey: "favourites") as? [Int] ?? []
    }
//Questa funzione serve a rimuovere un elemento dall'array
    func removeFromFavs(id: Int) {
        if let index = favouritesIDs.firstIndex(where: {$0 == id}) {
            favouritesIDs.remove(at: index)
            UserDefaults.standard.setValue(favouritesIDs, forKey: "favourites")
        }
    }
//Questa funzione serve a recuperare le story a partire dall'array salvato e ad inserirle nell'array che poi verrà utilizzato
    func fetchStories() {
        var stories: [Story] = []
        let group = DispatchGroup()
        for id in favouritesIDs {
            group.enter()
            apiNetwork.fetchStory(id: id) {
                story in 
                if let story = story {
                    stories.append(story)
                }
                group.leave()
            }
        }
        group.notify(queue: .main) {
            self.favouritesStories = stories.sorted(by: {$0.title! < $1.title!})
        }
    }
    
}
