//
//  HTMLView.swift
//  HackerNews
//
//  Created by Giovanni Teresi on 19/03/24.
//

import SwiftUI
import WebKit

//Questa view si occupa di tradure una stringa che le viene passata in ingresso in HTML e di farne visualizzare il contenuto. Serve per visualizzare il contenuto del campo text delle story che p una stringa contenente, per l'appunto del codice HTML


struct HTMLView: UIViewRepresentable {
  @Binding var text: String
   
  func makeUIView(context: Context) -> WKWebView {
    return WKWebView()
  }
   
  func updateUIView(_ uiView: WKWebView, context: Context) {
      let headerString = "<header><meta name='viewport' content='width=device-width, height=device-height, shrink-to-fit=NO, initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0, user-scalable=no'></header>"
      
//      let superstring = "<html><head><style>body{width: device-width;height: device-height;overflow-y: scroll;initial-scale: 1.0; minimum-scale: 1.0; user-scalable: no}</style></head><body>\(text)</body></html>"
      
      uiView.loadHTMLString(headerString + text, baseURL: nil)
//      uiView.loadHTMLString(superstring, baseURL: nil)
  }
    
    
}
struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView()
  }
}
