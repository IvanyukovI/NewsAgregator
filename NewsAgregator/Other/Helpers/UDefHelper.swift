//
//  UDefHelper.swift
//  NewsAgregator
//
//  Created by Игорь Иванюков on 12.02.2024.
//

import Foundation

class UDefHelper {
    
    let defaults = UserDefaults.standard
    static let shared = UDefHelper()
    private init() {}
    
    func save(news: [News]) {
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(news) {
            defaults.set(encoded, forKey: "news")
        }
    }
    
    func add(new: News) {
        var secrets = loadNews().filter({$0.article_id != new.article_id})
        secrets.insert(new, at: 0)
        save(news: secrets)
    }
    
    func delete(new: News) {
        let secrets = loadNews().filter({$0.article_id != new.article_id})
        save(news: secrets)
    }
    
    func loadNews() -> [News] {
        if let savedPerson = defaults.object(forKey: "news") as? Data {
            let decoder = JSONDecoder()
            if let loadedPerson = try? decoder.decode([News].self, from: savedPerson) {
                return loadedPerson
            }
        }
        return []
    }
}
