//
//  HomeViewController.swift
//  News_MVVM (UIKit)
//
//  Created by Youssef Eldeeb on 08/11/2023.
//

import UIKit
import SDWebImage

class HomeViewController: UIViewController {

    @IBOutlet weak var articleTableView: UITableView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
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
        viewModel.showAlertClosure = {[weak self] () in
            DispatchQueue.main.async {
                if let message = self?.viewModel.alertMessage{
                    self?.showAlertMsg(message)
                }
            }
        }
        
        viewModel.updateLoadingStatus = {[weak self] () in
            guard let self = self else {return}
            DispatchQueue.main.async { [weak self]  in
                guard let self = self else {return}
                switch self.viewModel.state {
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
        }
        
        viewModel.reloadTableViewClosure = {[weak self] () in
            DispatchQueue.main.async {
                self?.articleTableView.reloadData()
            }
        }
        
        viewModel.initFetch()
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
