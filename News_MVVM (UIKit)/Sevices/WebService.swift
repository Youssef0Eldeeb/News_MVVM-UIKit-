//
//  WebService.swift
//  News_MVVM (UIKit)
//
//  Created by Youssef Eldeeb on 08/11/2023.
//

import Foundation

protocol WebService{
    func fetchData(completion: @escaping ([Article]?, String?) -> (Void))
}


class ApiService: WebService{
    
//    static let shared = ApiService()
//    private init() {}
    
    var articlesArray: [Article]? = []
    
    func fetchData(completion: @escaping ([Article]?, String?) -> (Void)){
        // Create the URL object
        if let url = URL(string: "https://newsapi.org/v2/top-headlines?country=us&category=business&apiKey=0d9eff2ac1a94cfb94163017ea7a5d87") {
            // Create the URLSession
            let session = URLSession.shared
            
            // Create the data task
            let task = session.dataTask(with: url) { (data, response, error) in
                if let error = error {
                    completion(nil, error.localizedDescription)
                    return
                }
                
                if let data = data {
                    let jsonDecoder = JSONDecoder()
                    let decodedObj = try? jsonDecoder.decode(NewsResponse.self, from: data)
                    self.articlesArray = decodedObj?.articles ?? nil
                    completion(self.articlesArray, nil)
                }
            }
            // Start the task
            task.resume()
        } else {
            print("Invalid URL")
        }
    }
}

