////
////  LinkPreview.swift
////  Dune
////
////  Created by Waylan Sands on 19/5/20.
////  Copyright © 2020 Waylan Sands. All rights reserved.
////
//
//import UIKit
//
//struct LinkPreview {
//
//    var url: URL
//    var urlString: String
//    var canonicalUrl: String
//    var mainTitle: String
//    var isRegularSize: Bool
//    var largeImagePath: String?
//    var smallImagePath: String?
//    var largeImage: UIImage?
//    var smallImage: UIImage?
//
//    init(data: [String: Any]) {
//        self.urlString = data["urlString"] as! String
//        self.canonicalUrl = data["canonicalUrl"] as! String
//        self.mainTitle = data["mainTitle"] as! String
//        self.isRegularSize = data["isRegularSize"] as! Bool
//        self.canonicalUrl = data["canonicalUrl"] as! String
//        self.largeImagePath = data["largeImagePath"] as? String
//        self.smallImagePath = data["smallImagePath"] as? String
//        self.url = URL(string: urlString)!
//    }
//
//}
