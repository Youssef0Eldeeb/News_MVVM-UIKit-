//
//  Article.swift
//  News_MVVM (UIKit)
//
//  Created by Youssef Eldeeb on 08/11/2023.
//

import Foundation

struct NewsResponse: Codable {
    let status: String
    let totalResults: Int
    let articles: [Article]
}

struct Article: Codable {
    let author: String?
    let title: String
    let description: String?
    let url: String
    let urlToImage: String?
    let publishedAt: String
    let content: String?
}
