//
//  UIImageView+Ext.swift
//  Dune
//
//  Created by Waylan Sands on 14/3/20.
//  Copyright © 2020 Waylan Sands. All rights reserved.
//

import Foundation
import UIKit

extension UIImageView {
    
    func setImage(from urlString: String) {
        
        guard let imageURL = URL(string: urlString) else { return }
        
        if  let dict = UserDefaults.standard.object(forKey: "ImageCache") as? [String:String] {
            if let path = dict[urlString] {
                if let data = try? Data(contentsOf: URL(fileURLWithPath: path)) {
                    let image = UIImage(data: data)
                    
                    DispatchQueue.main.async {
                        self.image = image
                    }
                }
            }
        } else {
            DispatchQueue.global().async { [weak self] in
                guard let imageData = try? Data(contentsOf: imageURL) else { return }
                
                let image = UIImage(data: imageData)
                ImageCache.storeImage(urlString: urlString, Image: image!)
                
                DispatchQueue.main.async {
                    self!.image = image
                }
            }
        }
    }
}
