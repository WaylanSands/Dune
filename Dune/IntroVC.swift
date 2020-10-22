//
//  IntroVC.swift
//  Dune
//
//  Created by Waylan Sands on 2/7/20.
//  Copyright © 2020 Waylan Sands. All rights reserved.
//

import UIKit

class IntroVC: UIViewController {
    
    private var introScreens = [IntroScreenView]()
    
    // For various screen sizes
    private var topHeight: CGFloat = 70
    private var bottomHeight: CGFloat = -50
    
    private let scrollView: UIScrollView = {
        let view = UIScrollView()
        view.isPagingEnabled = true
        view.showsHorizontalScrollIndicator = false
        return view
    }()
    
    private lazy var pageControl: UIPageControl = {
        let control = UIPageControl()
        control.numberOfPages = introScreens.count
        control.currentPage = 0
        return control
    }()
    
    private let logoImageView: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "introLogo")
        return view
    }()
    
    private let logoLabel: UILabel = {
        let label = UILabel()
        label.text = "Dune"
        label.font = UIFont.systemFont(ofSize: 26, weight: .bold)
        label.textColor = .white
        return label
    }()
    
    private let skipButton: UIButton = {
        let button = UIButton()
        button.titleLabel?.font = UIFont.systemFont(ofSize: 15, weight: .semibold)
        button.setTitle("Skip", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.addTarget(self, action: #selector(continueButtonPress), for: .touchUpInside)
        return button
    }()
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
      return .lightContent
    } 
    
    override func viewDidLoad() {
        super.viewDidLoad()
        scrollView.delegate = self
        introScreens = screens()
        styleForScreens()
        configureViews()
    }
    
    private func styleForScreens() {
        switch UIDevice.current.deviceType {
        case .iPhone4S, .iPhoneSE:
           bottomHeight = -15
           topHeight = 40
        case .iPhone8:
            bottomHeight = -15
            topHeight = 40
        case .iPhone8Plus:
            bottomHeight = -15
            topHeight = 40
        case .iPhone11:
            break
        case .iPhone11Pro:
            break
        case .iPhone11ProMax:
            break
        case .unknown:
            break
        }
    }
    
    private func configureViews() {
        view.backgroundColor = hexStringToUIColor(hex: "A5AECA")
        view.addSubview(scrollView)
        setupSlideScrollView(screens : introScreens)
        
        view.addSubview(logoImageView)
        logoImageView.translatesAutoresizingMaskIntoConstraints = false
        logoImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16).isActive = true
        logoImageView.topAnchor.constraint(equalTo: view.topAnchor, constant: topHeight).isActive = true
        logoImageView.heightAnchor.constraint(equalToConstant: 28).isActive = true
        logoImageView.widthAnchor.constraint(equalToConstant: 28).isActive = true
        
        view.addSubview(logoLabel)
        logoLabel.translatesAutoresizingMaskIntoConstraints = false
        logoLabel.leadingAnchor.constraint(equalTo: logoImageView.trailingAnchor, constant: 7).isActive = true
        logoLabel.centerYAnchor.constraint(equalTo: logoImageView.centerYAnchor, constant: 0).isActive = true
        
        view.addSubview(pageControl)
        pageControl.translatesAutoresizingMaskIntoConstraints = false
        pageControl.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16).isActive = true
        pageControl.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: bottomHeight).isActive = true
        
        view.addSubview(skipButton)
        skipButton.translatesAutoresizingMaskIntoConstraints = false
        skipButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16).isActive = true
        skipButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: bottomHeight - 5).isActive = true
    }
    
    private func setupSlideScrollView(screens : [IntroScreenView]) {
        scrollView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height)
        scrollView.contentSize = CGSize(width: view.frame.width * CGFloat(screens.count), height: view.frame.height)
        
        for i in 0 ..< screens.count {
            screens[i].frame = CGRect(x: view.frame.width * CGFloat(i), y: 0, width: view.frame.width, height: view.frame.height)
            scrollView.addSubview(screens[i])
        }
    }
    
    private func screens() -> [IntroScreenView] {
        let screenOne = IntroScreenView(image: UIImage(named: "introImage-1")!, heading: "Stay in the loop", subHeading: "Subscribe to your interests to listen, learn & stay up-to-date through bite-sized audio clips. ")
        let screenTwo = IntroScreenView(image: UIImage(named: "introImage-2")!, heading: "Connect with others", subHeading: "Connect with like-minded people, post comments & join in on the discussions.")
        let screenThree = IntroScreenView(image: UIImage(named: "introImage-3")!, heading: "Have a voice", subHeading: "Create your own channel and share your thoughts, ideas and interests with the world.")
        return [screenOne, screenTwo, screenThree]
    }
    
}

extension IntroVC: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let pageIndex = round(scrollView.contentOffset.x/view.frame.width)
        pageControl.currentPage = Int(pageIndex)
        
        let maximumHorizontalOffset: CGFloat = scrollView.contentSize.width - scrollView.frame.width
        let currentHorizontalOffset: CGFloat = scrollView.contentOffset.x
        
        // vertical
        let maximumVerticalOffset: CGFloat = scrollView.contentSize.height - scrollView.frame.height
        let currentVerticalOffset: CGFloat = scrollView.contentOffset.y
        
        let percentageHorizontalOffset: CGFloat = currentHorizontalOffset / maximumHorizontalOffset
        let percentageVerticalOffset: CGFloat = currentVerticalOffset / maximumVerticalOffset
        
        
        let percentOffset: CGPoint = CGPoint(x: percentageHorizontalOffset, y: percentageVerticalOffset)
       
        view.backgroundColor = scrollColor(percent: Double(percentOffset.x))

        
        if(percentOffset.x > 0 && percentOffset.x <= 0.33) {
            //            introScreens[0].headingLabel.alpha = 1 - percentOffset.x
            //            introScreens[0].imageView.transform = CGAffineTransform(scaleX: (0.33-percentOffset.x)/0.33, y: (0.33-percentOffset.x)/0.33)
            //            introScreens[1].imageView.transform = CGAffineTransform(scaleX: percentOffset.x/0.33, y: percentOffset.x/0.33)
            
        } else if(percentOffset.x > 0.33 && percentOffset.x <= 0.50) {
            //            introScreens[1].imageView.transform = CGAffineTransform(scaleX: (0.66-percentOffset.x)/0.33, y: (0.50-percentOffset.x)/0.33)
            //            introScreens[2].imageView.transform = CGAffineTransform(scaleX: percentOffset.x/0.66, y: percentOffset.x/0.66)
            
        } else if(percentOffset.x > 0.50 && percentOffset.x <= 1) {
//            view.backgroundColor = hexStringToUIColor(hex: "254DFF")
            skipButton.setTitle("Continue", for: .normal)
            //            introScreens[2].imageView.transform = CGAffineTransform(scaleX: (0.99-percentOffset.x)/0.99, y: (0.75-percentOffset.x)/0.33)
        }
    }
        
    @objc func continueButtonPress() {
        let rootVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "mainNavController") as! UINavigationController
        UserDefaults.standard.set(true, forKey: "completedIntro")
        UserDefaults.standard.set([], forKey: "playedEpisodes")
        DuneDelegate.newRootView(rootVC)
    }
    
    private func blend(from: UIColor, to: UIColor, percent: Double) -> UIColor {
        var fR : CGFloat = 0.0
        var fG : CGFloat = 0.0
        var fB : CGFloat = 0.0
        var tR : CGFloat = 0.0
        var tG : CGFloat = 0.0
        var tB : CGFloat = 0.0

        from.getRed(&fR, green: &fG, blue: &fB, alpha: nil)
        to.getRed(&tR, green: &tG, blue: &tB, alpha: nil)

        let dR = tR - fR
        let dG = tG - fG
        let dB = tB - fB

        let rR = fR + dR * CGFloat(percent)
        let rG = fG + dG * CGFloat(percent)
        let rB = fB + dB * CGFloat(percent)

        return UIColor(red: rR, green: rG, blue: rB, alpha: 1.0)
    }

    // Pass in the scroll percentage to get the appropriate color
    private func scrollColor(percent: Double) -> UIColor {
        var start : UIColor
        var end : UIColor
        var perc = percent
        if percent < 0.5 {
            // If the scroll percentage is 0.0..<0.5 blend between yellow and green
            start = hexStringToUIColor(hex: "A5AECA")
            end = hexStringToUIColor(hex: "272B33")
        } else {
            // If the scroll percentage is 0.5..1.0 blend between green and blue
            start = hexStringToUIColor(hex: "272B33")
            end = hexStringToUIColor(hex: "254DFF")
            perc -= 0.5
        }

        return blend(from: start, to: end, percent: perc * 2.0)
    }
    
}
