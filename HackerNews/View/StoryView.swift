//
//  StoryView.swift
//  HackerNews
//
//  Created by Giovanni Teresi on 16/03/24.
//

import SwiftUI

//Questa view serve a visualizzare le informaioni della story selezionata e fornisce anche la possibilità di aggiungere o rimuovere la story dai preferiti

struct StoryView: View {
    let story: Story
    @State var starIcon = ""
    @State var storyDate = ""
    @State var text = ""
    @State var comments: [Comment] = []
    @ObservedObject var favourites = Favourite()
    @ObservedObject var apiNetwork: ApiNetwork
    
    
    
    var body: some View {
//All'interno di questa list vi sono le informazioni della story quali: titolo, autore, data di creazione, descrizione, link esterno, numero di commenti e commenti. I campi descrizione  e link esterno sono presenti e visualizzati solo se esistono
        List{
            Section (header: Text("Info")){
                Text(story.title ?? "")
                Text("By: " + (story.by)!)
                Text("Added: " + storyDate)
                if (text) != "" {
                    NavigationLink(destination: HTMLView(text: $text)) {
                        Text("Description:")
                    }
                }
                if story.url != nil {
                    NavigationLink(destination: WebView(url: story.url)) {
                        Text("Story:")
                    }
                }
                if (story.descendants) != nil {
                    Text("Comments: \((story.descendants)!)")
                } else {
                    Text("Comments: 0")
                }
            }
            Section {
                ForEach(comments) { comment in
                    if (comment.by) != nil {
                        NavigationLink(destination: CommentView(comment: comment, apiNetwork: apiNetwork)) {
                            Text("By: \((comment.by ?? "Anonymous")!)")
                            if (comment.kids) != nil {
                                HStack {
                                    Text("\((comment.kids?.count)!)")
                                    Image(systemName: "arrowshape.turn.up.left")
                                }
                            }
                        }
                        if (comment.kids) != nil {
                            
                        }
                    }
                }
            }
        }
        .onAppear() {
            dateToString()
            if (story.text) != nil {
                text = (story.text)!
            }
            if ((story.kids) != nil) {
                apiNetwork.fetchComments(commentsIds: (story.kids)!) { result in self.comments = result!.sorted(by: {$0.id < $1.id})}
            }
            favourites.retrieveFavs()
            if favourites.favouritesIDs.contains(where: {$0 == (story.id)}) {
                starIcon = "star.fill"
            } else {
                starIcon = "star"
            }
        }
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    if starIcon == "star" {
                        favourites.saveFavs(id: (story.id))
                        starIcon = "star.fill"
                    } else if starIcon == "star.fill" {
                        favourites.removeFromFavs(id: (story.id))
                        starIcon = "star"
                    }
                } label: {
                    Image(systemName: starIcon)
                }
            }
        }
    }
    
//Questa funzione ha lo scopo di convertire il dato della story che ne contiene la data di creazione in un formato che permette la visualizzazione nella view
    func dateToString() {
        let date = Date(timeIntervalSince1970: (story.time)!)
        let dateFormatter = DateFormatter()
        
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .medium
        
        storyDate = dateFormatter.string(from: date)
    }
    
}








