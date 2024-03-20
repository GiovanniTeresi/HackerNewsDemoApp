//
//  TopsView.swift
//  HackerNews
//
//  Created by Giovanni Teresi on 14/03/24.
//

import SwiftUI
import WebKit

//Questa view mostra le storie che appartengono alla categoria Top Stories, le story vengono presentate tramite una list di navigation link che ne mostra il titolo

struct TopsView: View {
    
    @ObservedObject var apiNetwork: ApiNetwork

    var body: some View {
        NavigationView{
            List(apiNetwork.topStories){ story in
                NavigationLink(destination: StoryView(story: story, apiNetwork: apiNetwork)) {
                        Text(story.title ?? "")
                    }
                }.navigationTitle("Top Stories")
                .toolbar {
                    ToolbarItem(placement: .topBarTrailing) {
                        NavigationLink(destination: FavouritesView(apiNetwork: apiNetwork)) {
                            Text("Favourites")
                        }
                    }}
                .refreshable {
                    apiNetwork.showTopStories()
                }
        }

    }
}
