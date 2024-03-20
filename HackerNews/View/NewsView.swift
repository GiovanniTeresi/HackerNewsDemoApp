//
//  NewsView.swift
//  HackerNews
//
//  Created by Giovanni Teresi on 14/03/24.
//

import SwiftUI
import WebKit

//Questa view mostra le storie che appartengono alla categoria New Stories, le story vengono presentate tramite una list di navigation link che ne mostra il titolo

struct NewsView: View {
    
    @ObservedObject var apiNetwork: ApiNetwork
    
    var body: some View {
        NavigationView {
            List(apiNetwork.newStories) { story in
                NavigationLink(destination: StoryView(story: story, apiNetwork: apiNetwork)) {
                    Text(story.title ?? "")
                }
            }
            .navigationTitle("New Stories")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    NavigationLink(destination: FavouritesView(apiNetwork: apiNetwork)) {
                        Text("Favourites")
                    }
                }}
//Refreshable serve ad implementare il pull to refresh, poichè all'interno della classe ApiNetwork le varibili che sono utilizzate nelle list sono Published, allora basta richiamare la funzione che richiede i dati dall'api per ricostiure l'array per aggiornare in automatico le viste corrispondenti
            .refreshable {
                apiNetwork.showNewStories()
            }
        }
    }
}
