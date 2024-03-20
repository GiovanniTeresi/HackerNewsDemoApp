//
//  FavouritesView.swift
//  HackerNews
//
//  Created by Giovanni Teresi on 17/03/24.
//

import SwiftUI

struct FavouritesView: View {
    
    @ObservedObject var favourites = Favourite()
    @ObservedObject var apiNetwork: ApiNetwork
    
// Questa view, alla quale ci si può accedere da ognuna delle view delle tre categorie, mostra la list che contiene le story aggiunte ai preferiti
    
    var body: some View {
        VStack {
            List(favourites.favouritesStories){ story in
                NavigationLink(destination: StoryView(story: story, apiNetwork: apiNetwork)) {
                    Text(story.title ?? "")
                }
            }
        }.onAppear {
            favourites.retrieveFavs()
            favourites.fetchStories()
        }
    }
}

