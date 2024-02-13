//
//  APICaller.swift
//  NewsAgregator
//
//  Created by Игорь Иванюков on 12.02.2024.
//

import Foundation

class NetworkManager {
    static let shared = NetworkManager()

    private init() {}

    func request(url: URL, method: String, parameters: [String: String]?, completion: @escaping (Result<[News], Error>, String) -> Void) {
        var news: [News] = []
        var nextPage = ""
        
        let task = URLSession.shared.dataTask(with: URLRequest(url: url)) { data, response, error in
            if let error = error {
                print("Error: \(error)")
                return
            }
            guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
                print("Invalid response")
                return
            }
            guard let data = data, error == nil else { return }
            do {
                let results = try JSONSerialization.jsonObject(with: data, options: [])
                if let jsonDictionary = results as? [String: Any] {
                    if let status = jsonDictionary["status"] as? String,
                       let totalResults = jsonDictionary["totalResults"] as? Int,
                       let results = jsonDictionary["results"] as? [[String: Any]],
                       let nPage = jsonDictionary["nextPage"] as? String {
                        print("Status: \(status)")
                        print("Total Results: \(totalResults)")
                        nextPage = nPage
                        for result in results {
                            if let articleId = result["article_id"] as? String,
                               let title = result["title"] as? String,
                               let link = result["link"] as? String,
                               let description = result["description"] as? String,
                               let pubDate = result["pubDate"] as? String {
                                news.append(News(article_id: articleId,
                                                 title: title,
                                                 link: link,
                                                 description: description,
                                                 pubDate: pubDate,
                                                 image_url: result["image_url"] as? String ?? "",
                                                 creator: result["creator"] as? [String] ?? [], favorite: false))
                            }
                        }
                    }
                    
                    
                    
                }
                completion(.success(news), nextPage)
            } catch {
                completion(.failure(NSError(domain: "NetworkError", code: 0, userInfo: nil)), "")
            }
        }
        
        task.resume()
    }
}
