//
//  AddBirthDate.swift
//  Snippets
//
//  Created by Waylan Sands on 12/1/20.
//  Copyright © 2020 Waylan Sands. All rights reserved.
//

import UIKit

class AllowNotifications: UIView {
      
    var buttonFontSize: CGFloat = 14
    var categories = Category.allCases
    var categoryButtons = [UIButton]()
    var selectedCategories = [String]()
    var headingYConstant: CGFloat = 200.0
    let defaultSubHeadingText = "Discover relevant content"
    
    lazy var headingLabel = CustomStyle.styleSignupHeading(view: self, title: "Select categories that interest you")
    lazy var dateTextField = CustomStyle.styleSignUpTextField(color: CustomStyle.secondShade, view: self, placeholder: "")
    
    weak var nextButtonDelegate: NextButtonDelegate?
    
    lazy var subHeadingLabel: UILabel =  {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        label.textColor = CustomStyle.subTextColor
        label.text = defaultSubHeadingText
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    let interestButtonsStackView: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.distribution = .equalSpacing
        view.alignment = .center
        view.spacing = 10
        return view
    }()
    
    let firstStackView: UIStackView = {
        let view = UIStackView()
        view.spacing = 7
        return view
    }()
    
    let secondStackView: UIStackView = {
        let view = UIStackView()
          view.spacing = 7
        return view
    }()
    
    let thirdStackView: UIStackView = {
        let view = UIStackView()
          view.spacing = 7
        return view
    }()
    
    let fourthStackView: UIStackView = {
        let view = UIStackView()
          view.spacing = 7
        return view
    }()
    
    let fifthStackView: UIStackView = {
        let view = UIStackView()
          view.spacing = 7
        return view
    }()
    
    let sixthStackView: UIStackView  = {
        let view = UIStackView()
          view.spacing = 7
        return view
    }()
        
    //initWithFrame to init view from code
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .clear
        styleForScreens()
        setupView()
    }
    
    func styleForScreens() {
        switch UIDevice.current.deviceType {
        case .iPhone4S, .iPhoneSE:
            buttonFontSize = 12
            headingYConstant = 70.0
        case .iPhone8:
            buttonFontSize = 13
            headingYConstant = 145.0
        case .iPhone8Plus:
            headingYConstant = 180.0
        case .iPhone11:
            headingYConstant = 240.0
        case .iPhone11Pro, .iPhone12:
            headingYConstant = 200.0
        case .iPhone11ProMax, .iPhone12ProMax:
            headingYConstant = 240.0
        case .unknown:
            break
        }
    }
    
    //initWithCode to init view from xib or storyboard
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func setupView() {
        
        addSubview(headingLabel)
        headingLabel.translatesAutoresizingMaskIntoConstraints = false
        headingLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20).isActive = true
        headingLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -20).isActive = true
        headingLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: headingYConstant).isActive = true
//        headingLabel.textColor = .white
        
        addSubview(subHeadingLabel)
        subHeadingLabel.translatesAutoresizingMaskIntoConstraints = false
        subHeadingLabel.topAnchor.constraint(equalTo: headingLabel.bottomAnchor, constant: 10.0).isActive = true
        subHeadingLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -20).isActive = true
        subHeadingLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20).isActive = true
        
        addSubview(interestButtonsStackView)
        interestButtonsStackView.translatesAutoresizingMaskIntoConstraints = false
        interestButtonsStackView.topAnchor.constraint(equalTo: subHeadingLabel.bottomAnchor, constant: 40.0).isActive = true
        interestButtonsStackView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10).isActive = true
        interestButtonsStackView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10).isActive = true
        
        interestButtonsStackView.addArrangedSubview(firstStackView)
        firstStackView.addArrangedSubview(categoryButton(title: categories[0].rawValue))
        firstStackView.addArrangedSubview(categoryButton(title: categories[1].rawValue))
        firstStackView.addArrangedSubview(categoryButton(title: categories[2].rawValue))

        interestButtonsStackView.addArrangedSubview(secondStackView)
        secondStackView.addArrangedSubview(categoryButton(title: categories[3].rawValue))
        secondStackView.addArrangedSubview(categoryButton(title: categories[4].rawValue))
        secondStackView.addArrangedSubview(categoryButton(title: categories[5].rawValue))

        interestButtonsStackView.addArrangedSubview(thirdStackView)
        thirdStackView.addArrangedSubview(categoryButton(title: categories[6].rawValue))
        thirdStackView.addArrangedSubview(categoryButton(title: categories[7].rawValue))
        thirdStackView.addArrangedSubview(categoryButton(title: categories[8].rawValue))

        interestButtonsStackView.addArrangedSubview(fourthStackView)
        fourthStackView.addArrangedSubview(categoryButton(title: categories[9].rawValue))
        fourthStackView.addArrangedSubview(categoryButton(title: categories[10].rawValue))
        fourthStackView.addArrangedSubview(categoryButton(title: categories[11].rawValue))

        interestButtonsStackView.addArrangedSubview(fifthStackView)
        fifthStackView.addArrangedSubview(categoryButton(title: categories[12].rawValue))
        fifthStackView.addArrangedSubview(categoryButton(title: categories[13].rawValue))
        fifthStackView.addArrangedSubview(categoryButton(title: categories[14].rawValue))

        interestButtonsStackView.addArrangedSubview(sixthStackView)
        sixthStackView.addArrangedSubview(categoryButton(title: categories[15].rawValue))
        sixthStackView.addArrangedSubview(categoryButton(title: categories[16].rawValue))
        sixthStackView.addArrangedSubview(categoryButton(title: categories[17].rawValue))
    }
    
    @objc func categorySelected(_ sender: UIButton) {
        if selectedCategories.contains(sender.titleLabel!.text!) {
            selectedCategories.removeAll(where: {$0 == sender.titleLabel!.text!})
            removeSelectedStyle(button: sender)
        } else {
            selectedCategories.append(sender.titleLabel!.text!)
            selectedStyle(button: sender)
        }

        if selectedCategories.count > 0 {
            nextButtonDelegate?.makeNextButton(active: true)
        } else {
            nextButtonDelegate?.makeNextButton(active: false)
        }
    }
    
    func selectedStyle(button: UIButton) {
        button.backgroundColor =  CustomStyle.seventhShade
        button.setTitleColor(CustomStyle.white, for: .normal)
    }
    
    func removeSelectedStyle(button: UIButton) {
        button.backgroundColor = CustomStyle.secondShade
        button.setTitleColor(CustomStyle.fourthShade, for: .normal)
    }
    
    func categoryButton(title: String) -> UIButton {
        let button = UIButton()
        button.backgroundColor = CustomStyle.secondShade
        button.setTitleColor(CustomStyle.fourthShade, for: .normal)
        button.setTitle(title, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: buttonFontSize, weight: .medium)
        button.layer.cornerRadius = 18
        button.contentEdgeInsets = UIEdgeInsets(top: 10, left: 15, bottom: 10, right: 15)
        button.addTarget(self, action: #selector(categorySelected), for: .touchUpInside)
        return button
    }
    
}

