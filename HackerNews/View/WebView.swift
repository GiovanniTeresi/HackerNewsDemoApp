//
//  WebView.swift
//  HackerNews
//
//  Created by Giovanni Teresi on 14/03/24.
//

import SwiftUI
import WebKit

//Questa view serve a creare la pagina web in app una volta ricevuto in ingreso la stringa che ne contiene l'url. L'url in questione e contenuto nel campo url della story

struct WebView: UIViewRepresentable {
 
    let webView: WKWebView = WKWebView(frame: .zero)
    let url: String?
    
    func makeUIView(context: Context) -> WKWebView {
        return webView
    }
    func updateUIView(_ uiView: WKWebView, context: Context) {
        webView.load(URLRequest(url: URL(string: url!)!))
    }
}
