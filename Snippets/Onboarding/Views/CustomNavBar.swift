////
////  CustomNavBar.swift
////  Snippets
////
////  Created by Waylan Sands on 6/2/20.
////  Copyright © 2020 Waylan Sands. All rights reserved.
////
//
//import UIKit
//
//class CustomNavBar: UIView {
//
//    var bgColor: UIColor = .black
//    var navAlpha: CGFloat = 0.9
//
//    var backButton: UIButton = {
//        let button = UIButton()
//        button.frame = CGRect(x: 16.0, y: 45.0, width: 30.0, height: 30.0)
//        button.setImage(#imageLiteral(resourceName: "back-button-white"), for: .normal)
//        button.contentEdgeInsets = UIEdgeInsets(top: 0, left: -15.0, bottom: 0, right: 0)
//        return button
//    }()
//
//    let navBarTitleLabel: UILabel? = {
//        let label = UILabel()
//        label.text = "Summary"
//        label.font = UIFont.systemFont(ofSize: 16.0, weight: .semibold)
//        label.textColor = .white
//        return label
//    }()
//
//    var skipButton: UIButton = {
//        let button = UIButton()
//        button.titleLabel!.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
//        button.setTitle("Skip", for: .normal)
//        button.titleLabel?.textAlignment = .right
//        button.tintColor = .white
//        button.titleEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: -20.0)
//        return button
//    }()
//
//   override init(frame: CGRect) {
//        super.init(frame: frame)
//    }
//
//    init(backgroundColor: UIColor, alpha: CGFloat) {
//        super.init()
//        self.bgColor = backgroundColor
//        self.navAlpha = alpha
//    }
//
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//
//
//}
