//
//  SurveyVC.swift
//  Dune
//
//  Created by Waylan Sands on 2/9/20.
//  Copyright © 2020 Waylan Sands. All rights reserved.
//

import UIKit

class SurveyVC: UIViewController {
    
    let scrollView: UIScrollView = {
        let view = UIScrollView()
        return view
    }()
    
    let scrollContentView: UIScrollView = {
        let view = UIScrollView()
        return view
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        configureViews()
    }
    
    func configureViews() {
        view.addSubview(scrollView)
        scrollView.pinEdges(to: view)
        
    }

}
