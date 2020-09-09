//
//  DuneTabView.swift
//  Dune
//
//  Created by Waylan Sands on 4/9/20.
//  Copyright © 2020 Waylan Sands. All rights reserved.
//

import UIKit

class DuneTabBar: UIView {
    
    enum TabButtons {
        case dailyFeed
        case trending
        case search
        case account
        case studio
    }
    
    lazy private var tabButtons = [dailyFeedButton, searchButton, studioButton, trendingButton, accountButton]
    
    private var activeButton: UIButton! {
        didSet {
            for each in tabButtons {
                if each != activeButton {
                    unHighlight(button: each)
                } else {
                    highlight(button: each)
                }
            }
        }
    }
    
    var tabButtonSelection: ((Int) -> Void)!
    
    private let stackedView: UIStackView = {
        let view = UIStackView()
        view.distribution = .equalCentering
        return view
    }()
    
    private let topLineView: UIView = {
       let view = UIView()
        view.backgroundColor = CustomStyle.thirdShade
        return view
    }()
    
    private let dailyFeedButton: ExtendedButton = {
        let button = ExtendedButton()
        button.setImage(UIImage(named: "feed-icon-selected"), for: .normal)
        button.addTarget(self, action: #selector(buttonPress), for: .touchDown)
        button.adjustsImageWhenHighlighted = false
        button.padding = 10
        return button
    }()
    
    private let searchButton: ExtendedButton = {
        let button = ExtendedButton()
        button.setImage(UIImage(named: "search-icon"), for: .normal)
        button.addTarget(self, action: #selector(buttonPress), for: .touchDown)
        button.adjustsImageWhenHighlighted = false
        button.padding = 10
        return button
    }()
    
    private let studioButton: ExtendedButton = {
        let button = ExtendedButton()
        button.setBackgroundImage(UIImage(named: "studio-icon"), for: .normal)
        button.addTarget(self, action: #selector(buttonPress), for: .touchDown)
        button.adjustsImageWhenHighlighted = false
        button.padding = 10
        return button
    }()
    
    private let trendingButton: ExtendedButton = {
        let button = ExtendedButton()
        button.setBackgroundImage(UIImage(named: "trending-icon"), for: .normal)
        button.addTarget(self, action: #selector(buttonPress), for: .touchDown)
        button.adjustsImageWhenHighlighted = false
        button.padding = 10
        return button
    }()
    
    private let accountButton: ExtendedButton = {
        let button = ExtendedButton()
        button.setBackgroundImage(UIImage(named: "account-icon"), for: .normal)
        button.addTarget(self, action: #selector(buttonPress), for: .touchDown)
        button.adjustsImageWhenHighlighted = false
        button.padding = 10
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.activeButton = dailyFeedButton
        self.backgroundColor = hexStringToUIColor(hex: "F4F7FB")
        
        self.addSubview(topLineView)
        topLineView.translatesAutoresizingMaskIntoConstraints = false
        topLineView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        topLineView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        topLineView.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        topLineView.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        self.addSubview(stackedView)
        stackedView.translatesAutoresizingMaskIntoConstraints = false
        stackedView.topAnchor.constraint(equalTo: self.topAnchor, constant: 10).isActive = true
        stackedView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20).isActive = true
        stackedView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -20).isActive = true
        
        stackedView.addArrangedSubview(dailyFeedButton)
        stackedView.addArrangedSubview(trendingButton)
        stackedView.addArrangedSubview(studioButton)
        stackedView.addArrangedSubview(searchButton)
        stackedView.addArrangedSubview(accountButton)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
     private func unHighlight(button: UIButton) {
        switch button {
        case dailyFeedButton:
            button.setImage(UIImage(named: "feed-icon"), for: .normal)
        case trendingButton:
            button.setImage(UIImage(named: "trending-icon"), for: .normal)
        case searchButton:
            button.setImage(UIImage(named: "search-icon"), for: .normal)
        case studioButton:
            button.setImage(UIImage(named: "studio-icon"), for: .normal)
        case accountButton:
            button.setImage(UIImage(named: "account-icon"), for: .normal)
        default:
            break
        }
    }
    
    private func highlight(button: UIButton) {
        switch button {
        case dailyFeedButton:
            button.setImage(UIImage(named: "feed-icon-selected"), for: .normal)
            tabButtonSelection(0)
        case trendingButton:
            button.setImage(UIImage(named: "trending-icon-selected"), for: .normal)
            tabButtonSelection(1)
        case studioButton:
            button.setImage(UIImage(named: "studio-icon-selected"), for: .normal)
            tabButtonSelection(2)
        case searchButton:
            button.setImage(UIImage(named: "search-icon-selected"), for: .normal)
            tabButtonSelection(3)
        case accountButton:
            button.setImage(UIImage(named: "account-icon-selected"), for: .normal)
            tabButtonSelection(4)
        default:
            break
        }
    }
    
    func visit(screen: TabButtons) {
        switch screen {
        case .dailyFeed:
            tabButtonSelection(0)
            activeButton = dailyFeedButton
        case.trending:
            tabButtonSelection(1)
              activeButton = trendingButton
        case .studio:
            tabButtonSelection(2)
            activeButton = studioButton
        case .search:
            tabButtonSelection(3)
            activeButton = searchButton
        case .account:
            tabButtonSelection(4)
            activeButton = accountButton
        }
    }
    
    @objc private func buttonPress(sender: UIButton) {
        activeButton = sender
    }

}
