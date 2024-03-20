//
//  ContentView.swift
//  HackerNews
//
//  Created by Giovanni Teresi on 14/03/24.
//

import SwiftUI
import WebKit

//Questa è la view principale, all'avvio viene creata l'istanza della classe che gestisce le chiamate al servizio esterno e vengono chiamate le funzioni che adranno a recuperare i dati che verranno mostrati nelle view successive

struct ContentView: View {

    @ObservedObject var apiNetwork: ApiNetwork
    
    init() {
        apiNetwork = ApiNetwork()
        apiNetwork.showNewStories()
        apiNetwork.showTopStories()
        apiNetwork.showBestStories()
    }
    
//La navigazione tra le categorie è organizzata con una tabview a cui viene passata l'istanza della classe per poter chiamare le funzioni di questa nel caso sia necessario
    
    var body: some View {
        VStack {
            TabView {
                NewsView(apiNetwork: apiNetwork)
                    .tabItem {
                        Text("New")
                    }
                TopsView(apiNetwork: apiNetwork)
                    .tabItem {
                        Text("Top")
                    }
                BestsView(apiNetwork: apiNetwork)
                    .tabItem { 
                        Text("Best")
                    }
            }
        }
    }
}

