//
//  UiViewController+Extension.swift
//  News_MVVM (UIKit)
//
//  Created by Youssef Eldeeb on 08/11/2023.
//

import Foundation
import UIKit

extension UIViewController{
    
    static var identifire: String{
        return String(describing: self)
    }
    
    static func instantiateVC(name: StoryboardPage) -> Self{
        let storyboard = UIStoryboard(name: name.rawValue, bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: identifire) as! Self
        return controller
    }
    
    enum StoryboardPage: String{
        case Home
    }
    
}
