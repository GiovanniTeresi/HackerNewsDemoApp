//
//  CommentView.swift
//  HackerNews
//
//  Created by Giovanni Teresi on 18/03/24.
//

import SwiftUI

//Questa view contiene il contenuto del commento selezionato; al suo interno vi è una vista che si occupa di mostrare il contenuto del campo text di una story

struct CommentView: View {
    
    @State var comment: Comment
    @State var commentDate = ""
    @State var text = ""
    @State var replies: [Comment] = []
    @ObservedObject var apiNetwork: ApiNetwork
    
    var body: some View {
        VStack {
            Text("Added: \(commentDate)")
            HTMLView(text: $text)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            if comment.kids != nil {
                List(replies){ reply in
                    NavigationLink(destination: CommentView(comment: reply, apiNetwork: apiNetwork)) {
                        HStack {
                            Text("By: \((reply.by ?? "Anonymous")!)")
                            Spacer()
                            if (reply.kids) != nil {
                                HStack{
                                    Text("\((reply.kids?.count)!)")
                                    Image(systemName: "arrowshape.turn.up.left")
                                }
                            }
                        }
                    }
                }
            }
        }
        .navigationTitle("By: \((comment.by ?? "Anonymous")!)")
            .onAppear() {
                dateToString()
                if (comment.text) != nil {
                    text = (comment.text)!
                }
                if comment.kids != nil{
                    apiNetwork.fetchComments(commentsIds: (comment.kids)!) { result in self.replies = result!}
                }
            }
    }
    
    func dateToString() {
        let date = Date(timeIntervalSince1970: (comment.time)!)
        let dateFormatter = DateFormatter()
        
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .medium
        
        commentDate = dateFormatter.string(from: date)
    }
    
}

