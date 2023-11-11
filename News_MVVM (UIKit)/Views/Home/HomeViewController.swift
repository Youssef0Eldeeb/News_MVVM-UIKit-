//
//  HomeViewController.swift
//  News_MVVM (UIKit)
//
//  Created by Youssef Eldeeb on 08/11/2023.
//

import UIKit
import SDWebImage
import Combine

class HomeViewController: UIViewController {

    @IBOutlet weak var articleTableView: UITableView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    private var cancellables: Set<AnyCancellable> = []
    lazy var viewModel: ArticlesListViewModel = {
        return ArticlesListViewModel()
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initView()
        initViewModel()
    }
    
    private func initView(){
        self.navigationItem.title = "Latest News"
        self.navigationItem.largeTitleDisplayMode = .always
        
        articleTableView.delegate = self
        articleTableView.dataSource = self
        articleTableView.estimatedRowHeight = 150
        articleTableView.rowHeight = UITableView.automaticDimension
    }
    private func initViewModel(){

        viewModel.initFetch()

        viewModel.$alertMessage.sink { [weak self] message in
            DispatchQueue.main.async {
                if let message = message{
                    self?.showAlertMsg(message)
                }
            }
        }.store(in: &cancellables)
        
        viewModel.$state.sink { [weak self] state in
            DispatchQueue.main.async { [weak self]  in
                guard let self = self else {return}
                switch state {
                case .empty, .error:
                    self.activityIndicator.stopAnimating()
                    UIView.animate(withDuration: 0.3) {
                        self.articleTableView.alpha = 0.0
                    }
                case .loading:
                    self.activityIndicator.startAnimating()
                    UIView.animate(withDuration: 0.3) {
                        self.articleTableView.alpha = 0.0
                    }
                case .populated:
                    self.activityIndicator.stopAnimating()
                    UIView.animate(withDuration: 0.3) {
                        self.articleTableView.alpha = 1.0
                    }
                }
            }
        }.store(in: &cancellables)
        
        viewModel.$cellViewModels.sink { [weak self] _ in
            DispatchQueue.main.async {
                self?.articleTableView.reloadData()
            }
        }.store(in: &cancellables)
        
    }
    
    private func showAlertMsg(_ message: String){
        let alert = UIAlertController(title: "Alert", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .cancel))
        self.present(alert, animated: true)
    }
    

}

extension HomeViewController: UITableViewDelegate, UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel.numberOfCells
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150.0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = articleTableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? NewsTableViewCell else{
            fatalError("Cell not exists in storyboard")
        }
        
        cell.articleCellViewModel = viewModel.getCellInIndexPath(at: indexPath)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = DetailsViewController.instantiateVC(name: .Home)
        let obj = viewModel.getCellInIndexPath(at: indexPath)
        vc.setupObj = obj
        present(vc, animated: true)
    }
    
    
}
