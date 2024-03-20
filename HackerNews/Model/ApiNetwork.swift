
//  ApiNetwork.swift
//  HackerNews

//  Created by Giovanni Teresi on 14/03/24.


import Foundation

//Questa classe serve ad effettuare le chiamate all'API Hacker News per prendeere i dati che verrano utilizzati successivamente

class ApiNetwork: ObservableObject {
    
//    Ognuno di questi array Published conterrà le story che appartengono ad ognuna delle tre categorie: top, new e best
    
    @Published var topStories: [Story] = []
    @Published var newStories: [Story] = []
    @Published var bestStories: [Story] = []
    var updateTemp: [Story] = [] //Questo array invece serve come appoggio per quando si richiederà il refresh della categoria
    
    
//    Ognuna di queste tre funzioni serve a chiamare la funzione di fetch, ciascuna con un url differente a seconda della categoria
    
    func showTopStories() {
        let url = "https://hacker-news.firebaseio.com/v0/topstories.json"
        fetchStories(urlin: url, type: "top", update: false)
    }
    
    func showNewStories() {
        let url = "https://hacker-news.firebaseio.com/v0/newstories.json"
        fetchStories(urlin: url, type: "new", update: false)
    }
    
    func showBestStories() {
        let url = "https://hacker-news.firebaseio.com/v0/beststories.json"
        fetchStories(urlin: url, type: "best", update: false)
    }
   
//Questa funzione gestisce l'update delle categorie ed a seconda della view che effettua la chiamata aggiornerà uno o l'altro array

    func updateStories(type: String) {
        switch type {
        case "top":
            fetchStories(urlin: "https://hacker-news.firebaseio.com/v0/topstories.json", type: "top", update: true)
        case "new":
            fetchStories(urlin: "https://hacker-news.firebaseio.com/v0/newstories.json", type: "new", update: true)
        case "best":
            fetchStories(urlin: "https://hacker-news.firebaseio.com/v0/beststories.json", type: "new", update: true)
        default:
            print("No update")
        }
    }
    
//Questa funzione si occupa di effettuare la fetch all'API ed opera a seconda del type(categoria) e dell'update(true/false)
//nello specifico si occupa di costruire un array di Int che contiene gli id delle story di quella categoria
    
    func fetchStories(urlin: String, type: String, update: Bool) {
        let url = URL(string: urlin)!
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let error = error {
                print("Error fetching top stories: \(error)")
                return
            }
            guard let data = data else {
                print("No data received")
                return
            }
            do {
                let StoriesIds = try JSONDecoder().decode([Int].self, from: data)
                var stories: [Story] = []
                let group = DispatchGroup()
                for id in StoriesIds {
                    group.enter()
                    self.fetchStory(id: id) { story in
                        if let story = story {
                            stories.append(story)
                        }
                        group.leave()
                    }
                }
                group.notify(queue: .main) {
                    switch type {
                    case "top":
                        self.topStories = stories.sorted(by: {$0.title! < $1.title!})
                    case "new":
                        self.newStories = stories.sorted(by: {$0.title! < $1.title!})
                    case "best":
                        self.bestStories = stories.sorted(by: {$0.title! < $1.title!})
                    default:
                        print("nulla")
                    }
                }
            } catch {
                print("Error decoding JSON: \(error)")
            }
        }
        task.resume()
    }
   
//Questa funzione si occupa di istanziare la story che successivamente sarà inserita nell'array della categoria a cui appartiene
    
    func fetchStory(id: Int, completion: @escaping (Story?) -> Void) {
        let url = URL(string: "https://hacker-news.firebaseio.com/v0/item/\(id).json")!
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let error = error {
                completion(nil)
                return
            }
            guard let data = data else {
                completion(nil)
                return
            }
            do {
                let story = try JSONDecoder().decode(Story.self, from: data)
                    completion(story)
            } catch {
                completion(nil)
            }
        }
        task.resume()
    }
    
//Questa funzione si occupa di costruire l'array con gli id, che vengono passati nella chiamata, dei commenti relativi ad una story
    func fetchComments(commentsIds: [Int], completion: @escaping ([Comment]?) -> Void) {
        let group = DispatchGroup()
        var comments: [Comment] = []
        for id in commentsIds {
            group.enter()
            let url = URL(string: "https://hacker-news.firebaseio.com/v0/item/\(id).json")!
            let task = URLSession.shared.dataTask(with: url) {
                (data, response, error) in
                if let error = error {
                    completion(nil)
                    return
                }
                guard let data = data else {
                    completion(nil)
                    return
                }
                do {
                    let comment = try JSONDecoder().decode(Comment.self, from: data)
                        comments.append(comment)
                } catch {
                    print("Error decoding JSON: \(error)")
                }
                group.leave()
            }
            task.resume()
        }
        group.notify(queue: .main) {
            comments.sorted(by: {$0.id < $1.id})
            completion(comments)
        }
        
    }
    
}
