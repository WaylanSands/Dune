//
//  ReportBugVC.swift
//  Dune
//
//  Created by Waylan Sands on 15/9/20.
//  Copyright © 2020 Waylan Sands. All rights reserved.
//

import UIKit
import FirebaseFirestore

class ReportBugVC: UIViewController {
    
    lazy var contentViewSize = CGSize(width: view.frame.width, height: 1050.0)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        styleForScreens()
        configureViews()
    }
        
    var surveyQuestions = [SurveyQuestionView]()
    var answers = [String]()
    
    let customNavBar: CustomNavBar = {
        let nav = CustomNavBar()
        nav.leftButton.isHidden = true
        nav.backgroundColor = CustomStyle.blackNavBar
        nav.titleLabel.text = "Report bug"
        return nav
    }()
    
    lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView(frame: .zero)
        scrollView.contentSize = contentViewSize
        scrollView.frame = self.view.bounds
        scrollView.showsVerticalScrollIndicator = false
        scrollView.keyboardDismissMode = .interactive
        return scrollView
    }()
    
    lazy var containerView: UIView = {
        let containerView = UIView()
        containerView.frame.size = contentViewSize
        return containerView
    }()
    
    let mainHeadingLabel: UILabel = {
        let label = UILabel()
        label.text = "Thank you bug hunter!"
        label.font = UIFont.systemFont(ofSize: 23, weight: .bold)
        label.textColor = CustomStyle.primaryBlack
        label.numberOfLines = 0
        return label
    }()
    
    let mainSubHeadingLabel: UILabel = {
        let label = UILabel()
        label.text = "Where is it, let me at him."
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        label.textColor = CustomStyle.primaryBlack
        label.addLineSpacing()
        label.numberOfLines = 0
        return label
    }()
    
    var questionOne = SurveyQuestionView(question: "Where did you encounter this bug?",
                                         info: nil, type: .multipleChoice,
                                         answers: [
                                            "Daily feed",
                                            "Trending",
                                            "Search",
                                            "Studio",
                                            "Profiles",
                                            "Comments",
                                            "Anywhere"
    ])
    
    let subHeadingLabel: UILabel = {
        let label = UILabel()
        label.text = "To fix the bug we sometimes need to first attempt the steps you took to reveal the bug from it’s hiding place.  "
        label.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        label.textColor = CustomStyle.primaryBlack
        label.addLineSpacing()
        label.numberOfLines = 0
        return label
    }()
    
    
    let descriptionLabel: UILabel = {
        let label = UILabel()
        label.text = "How can we reproduce the bug?"
        label.font = UIFont.systemFont(ofSize: 14, weight: .bold)
        label.textColor = CustomStyle.primaryBlack
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        return label
    }()
    
    let reproductionView: UITextView = {
        let textField = UITextView()
        textField.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        textField.textColor = CustomStyle.primaryBlack
        textField.backgroundColor = CustomStyle.secondShade
        textField.textContainer.maximumNumberOfLines = 7
        textField.textContainerInset = UIEdgeInsets(top: 10, left: 5, bottom: 10, right: 5)
        return textField
    }()
    
    var submitButton: UIButton = {
        let button = UIButton()
        button.setTitle("Submit", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        button.backgroundColor = CustomStyle.secondShade
        button.setTitleColor( CustomStyle.thirdShade, for: .normal)
        button.addTarget(self, action: #selector(submitButtonPress), for: .touchUpInside)
        button.layer.cornerRadius = 16
        return button
    }()
    
    private func styleForScreens() {
        switch UIDevice.current.deviceType {
        case .iPhone4S, .iPhoneSE:
            contentViewSize = CGSize(width: view.frame.width, height: 950.0)
        case .iPhone8:
            contentViewSize = CGSize(width: view.frame.width, height: 950.0)
        case .iPhone8Plus:
            contentViewSize = CGSize(width: view.frame.width, height: 950.0)
        case .iPhone11:
            contentViewSize = CGSize(width: view.frame.width, height: 1020.0)
        case .iPhone11Pro:
            contentViewSize = CGSize(width: view.frame.width, height: 1020.0)
        case .iPhone11ProMax:
            contentViewSize = CGSize(width: view.frame.width, height: 1020.0)
        case .unknown:
            break
        }
    }
    
    func configureViews() {
        view.backgroundColor = .white
        view.addSubview(scrollView)
        scrollView.pinEdges(to: view)
        scrollView.addSubview(containerView)
        
        view.addSubview(customNavBar)
        customNavBar.pinNavBarTo(view)
        
        containerView.addSubview(mainHeadingLabel)
        mainHeadingLabel.translatesAutoresizingMaskIntoConstraints = false
        mainHeadingLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 20).isActive = true
        mainHeadingLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16).isActive = true
        mainHeadingLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16).isActive = true
        
        containerView.addSubview(mainSubHeadingLabel)
        mainSubHeadingLabel.translatesAutoresizingMaskIntoConstraints = false
        mainSubHeadingLabel.topAnchor.constraint(equalTo: mainHeadingLabel.bottomAnchor, constant: 10).isActive = true
        mainSubHeadingLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16).isActive = true
        mainSubHeadingLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16).isActive = true
        
        containerView.addSubview(questionOne)
        questionOne.translatesAutoresizingMaskIntoConstraints = false
        questionOne.topAnchor.constraint(equalTo: mainSubHeadingLabel.bottomAnchor, constant: 30).isActive = true
        questionOne.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16).isActive = true
        questionOne.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16).isActive = true
        questionOne.answerSelected = checkAllQuestions
        surveyQuestions.append(questionOne)
        
        containerView.addSubview(subHeadingLabel)
        subHeadingLabel.translatesAutoresizingMaskIntoConstraints = false
        subHeadingLabel.topAnchor.constraint(equalTo: questionOne.bottomAnchor, constant: 40).isActive = true
        subHeadingLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16).isActive = true
        subHeadingLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16).isActive = true
        
        containerView.addSubview(descriptionLabel)
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        descriptionLabel.topAnchor.constraint(equalTo: subHeadingLabel.bottomAnchor, constant: 40).isActive = true
        descriptionLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16).isActive = true
        descriptionLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16).isActive = true
        
        containerView.addSubview(reproductionView)
        reproductionView.translatesAutoresizingMaskIntoConstraints = false
        reproductionView.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 10).isActive = true
        reproductionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16).isActive = true
        reproductionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16).isActive = true
        reproductionView.heightAnchor.constraint(equalToConstant: 100).isActive = true
        reproductionView.delegate = self
        
        containerView.addSubview(submitButton)
        submitButton.translatesAutoresizingMaskIntoConstraints = false
        submitButton.topAnchor.constraint(equalTo: reproductionView.bottomAnchor, constant: 30).isActive = true
        submitButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16).isActive = true
        submitButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16).isActive = true
        submitButton.heightAnchor.constraint(equalToConstant: 32).isActive = true
    }
    
    func checkAllQuestions() {
        answers.removeAll()
        for each in surveyQuestions {
            if each.selection != nil {
                answers.append(each.selection!)
            }
        }
        
        if reproductionView.text != nil && reproductionView.text != ""  {
            answers.append(reproductionView.text)
        }
        
        print(answers.count)
        if answers.count == 2 {
            submitButton.backgroundColor = CustomStyle.primaryYellow
            submitButton.setTitleColor( .black, for: .normal)
        } else {
            submitButton.backgroundColor = CustomStyle.secondShade
            submitButton.setTitleColor( CustomStyle.thirdShade, for: .normal)
        }
    }
    
    @objc func submitButtonPress() {
        if answers.count == 2 {
            clearAnswers()
            let db = Firestore.firestore()
            
            DispatchQueue.global(qos: .userInitiated).async {
                let dateTime = Date.formattedToString(style: .medium)
                let suggestionRef = db.collection("bugs").document(dateTime)

                let locale = Locale.current
                
                suggestionRef.setData([
                    "UserID" : User.ID!,
                    "isSetUp" : User.isSetUp!,
                    "isPrivate" : CurrentProgram.isPrivate!,
                    "Version" : VersionControl.version,
                    "Build" : VersionControl.build,
                    "Device" : UIDevice.current.deviceType.rawValue,
                    "regionCode" : locale.regionCode ?? "Unknown",
                    "Question 1" : self.answers[0],
                    "Question 2" : self.answers[1],
                ]) { (error) in
                    if let error = error {
                        print("Error adding bug entry \(error.localizedDescription)")
                    } else {
                        print("Success adding bug entry")
                    }
                }

            }
        }
    }
    
    func clearAnswers() {
        submitButton.setTitle("Bug reported", for: .normal)
        reproductionView.text = ""
        DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
            for each in self.surveyQuestions {
                each.clearAnswer()
            }
            
            self.scrollView.setScrollViewToTop()
            self.reproductionView.resignFirstResponder()
            self.submitButton.setTitle("Submit", for: .normal)
        })
    }
    
}

extension ReportBugVC: UITextViewDelegate {
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        self.scrollView.setScrollBarToBottom()
    }
    
    func textViewDidChange(_ textView: UITextView) {
        checkAllQuestions()
    }

}

