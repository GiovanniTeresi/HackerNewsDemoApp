//
//  Story.swift
//  HackerNews
//
//  Created by Giovanni Teresi on 14/03/24.
//

import Foundation

//Creo le struct che serviranno a contenere gli item story e comment


struct Story: Decodable, Identifiable {
    let id: Int
    let by: String?
    let title: String?
    let time: TimeInterval?
    let text: String?
    let parent: Int?
    let kids: [Int]?
    let url: String?
    let descendants: Int?
    let deleted: Bool?
}




struct Comment: Decodable, Identifiable {
    let id: Int
    let by: String?
    let kids: [Int]?
    let parent: Int?
    let text: String?
    let time: TimeInterval?
    let deleted: Bool?
}
