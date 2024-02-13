//
//  News.swift
//  NewsAgregator
//
//  Created by Игорь Иванюков on 12.02.2024.
//

import Foundation

struct News: Codable {
    
    let article_id: String
    let title: String
    let link: String
    let description: String
    let pubDate: String
    let image_url: String
    let creator: [String]
    var favorite: Bool = false
    
}
