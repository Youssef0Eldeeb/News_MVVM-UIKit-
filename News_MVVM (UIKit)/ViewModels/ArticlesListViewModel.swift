//
//  HomeViewModel.swift
//  News_MVVM (UIKit)
//
//  Created by Youssef Eldeeb on 08/11/2023.
//

import Foundation
import Combine

public enum State {
    case loading
    case error
    case empty
    case populated
}

class ArticlesListViewModel{
    
    private let apiService: WebService
    
    @Published var state: State = .empty
    @Published var alertMessage: String?
    @Published var cellViewModels: [ArticleCellViewModel] = []
    
    var numberOfCells: Int{
        return cellViewModels.count
    }
    
    init(apiService: WebService = ApiService()) {
        self.apiService = apiService
    }
    
    func getCellInIndexPath(at indexPath: IndexPath) -> ArticleCellViewModel{
        return cellViewModels[indexPath.row]
    }
    
    func initFetch(){
        state = .loading
        apiService.fetchData { [weak self] (articles, error) in
            guard let self = self else {
                return
            }
            guard error == nil else{
                self.state = .error
                self.alertMessage = error
                return
            }
            
            if let articles = articles{
                self.processFetchedArticles(articles: articles)
            }
            self.state = .populated
            
        }
    }
    private func processFetchedArticles(articles: [Article]) {
        //this process like cashing to show all articles at once not one by one
//        self.articles = articles
        var cellsVM: [ArticleCellViewModel] = []
        for article in articles {
            cellsVM.append(ArticleCellViewModel(article: article))
        }
        self.cellViewModels = cellsVM
    }
    
}






struct ArticleCellViewModel{
    private let article: Article
    
    init(article: Article) {
        self.article = article
    }
    
    var imageUrl: String{
        return self.article.urlToImage ?? "https://www.google.com/url?sa=i&url=https%3A%2F%2Fstock.adobe.com%2Fsearch%2Fimages%3Fk%3Dno%2Bimage%2Bavailable&psig=AOvVaw387Wj0qXibHy8XIRZF32EA&ust=1699530575135000&source=images&cd=vfe&ved=0CBIQjRxqFwoTCKiqnvSqtIIDFQAAAAAdAAAAABAE"
    }
    var title: String{
        return self.article.title
    }
    var author: String{
        return self.article.author ?? "no author"
    }
    var date: String{
        return self.article.publishedAt
    }
    
}
