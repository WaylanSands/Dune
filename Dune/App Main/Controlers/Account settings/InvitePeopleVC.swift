//
//  InvitePeopleVC.swift
//  Dune
//
//  Created by Waylan Sands on 27/2/20.
//  Copyright © 2020 Waylan Sands. All rights reserved.
//

import UIKit

class InvitePeopleVC: UIViewController {
    
    let mainstackedView: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.spacing = 15
        return view
    }()
    
    let smsButton: UIButton = {
       let button = UIButton()
        button.setTitle("Invite friends via SMS", for: .normal)
        button.setTitleColor(CustomStyle.primaryblack, for: .normal)
        button.setImage(UIImage(named: "message-friend-icon"), for: .normal)
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(mainstackedView)
        mainstackedView.translatesAutoresizingMaskIntoConstraints = false
        mainstackedView.topAnchor.constraint(equalTo: view.topAnchor, constant: 80).isActive = true
        mainstackedView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16).isActive = true
        mainstackedView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16).isActive = true
        
        mainstackedView.addArrangedSubview(smsButton)

    }

}
