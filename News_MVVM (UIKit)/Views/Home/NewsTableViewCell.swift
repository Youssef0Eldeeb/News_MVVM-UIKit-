//
//  NewsTableViewCell.swift
//  News_MVVM (UIKit)
//
//  Created by Youssef Eldeeb on 08/11/2023.
//

import UIKit
import SDWebImage

class NewsTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var mainImage: UIImageView!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var author: UILabel!
    @IBOutlet weak var date: UILabel!
    
    var articleCellViewModel: ArticleCellViewModel?{
        didSet{
            mainImage?.sd_setImage(with: URL(string: articleCellViewModel?.imageUrl ?? ""))
            title.text = articleCellViewModel?.title
            author.text = articleCellViewModel?.author
            date.text = articleCellViewModel?.date
        }
    }
    
}
