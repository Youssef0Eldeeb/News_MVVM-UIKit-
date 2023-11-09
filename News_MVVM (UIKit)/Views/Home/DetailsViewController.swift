//
//  DetailsViewController.swift
//  News_MVVM (UIKit)
//
//  Created by Youssef Eldeeb on 09/11/2023.
//

import UIKit
import SDWebImage

class DetailsViewController: UIViewController {
    
    @IBOutlet weak var imageViewArticle: UIImageView!
    @IBOutlet weak var autherArticle: UILabel!
    @IBOutlet weak var dateArticle: UILabel!
    @IBOutlet weak var titleArticle: UILabel!
    
    var setupObj: ArticleCellViewModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup(setupObj: setupObj!)
    }
    
    func setup(setupObj: ArticleCellViewModel){
        imageViewArticle.sd_setImage(with: URL(string: setupObj.imageUrl ?? ""))
        autherArticle.text = setupObj.author
        titleArticle.text = setupObj.title
        dateArticle.text = setupObj.date
    }
    
    

}
