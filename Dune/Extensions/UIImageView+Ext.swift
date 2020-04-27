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
    
    func setImageAndCache(from urlString: String) {
        
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
                CacheControl.storeImage(urlString: urlString, image: image!)
                
                DispatchQueue.main.async {
                    self!.image = image
                }
            }
        }
    }
}

extension UIImage {
    
    public static func loadFrom(url: URL, completion: @escaping (_ image: UIImage?) -> ()) {
        DispatchQueue.global().async {
            if let data = try? Data(contentsOf: url) {
                DispatchQueue.main.async {
                    completion(UIImage(data: data))
                }
            } else {
                DispatchQueue.main.async {
                    completion(nil)
                }
            }
        }
    }
    
   func setImageAndCache(from urlString: String, completion: @escaping (UIImage) -> ()) {
        
        if let imageURL = URL(string: urlString) {
            if let dict = UserDefaults.standard.object(forKey: "ImageCache") as? [String:String] {
                if let path = dict[urlString] {
                    if let data = try? Data(contentsOf: URL(fileURLWithPath: path)) {
                        if let image = UIImage(data: data) {
                            DispatchQueue.main.async {
                                completion(image)
                            }
                        }
                    }
                }
            } else {
                DispatchQueue.global().async {
                    guard let imageData = try? Data(contentsOf: imageURL) else { return }
                    if let image = UIImage(data: imageData) {
                        CacheControl.storeImage(urlString: urlString, image: image)

                        DispatchQueue.main.async {
                            completion(image)
                        }
                    }
                }
            }
        }
    }
}
