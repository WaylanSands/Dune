//
//  SuggestionVC.swift
//  Dune
//
//  Created by Waylan Sands on 15/9/20.
//  Copyright © 2020 Waylan Sands. All rights reserved.
//

import UIKit
import FirebaseFirestore

class SuggestionVC: UIViewController {
    
    lazy var contentViewSize = CGSize(width: view.frame.width, height: 1240.0)
    
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
        nav.titleLabel.text = "Suggestions"
        return nav
    }()
    
    lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView(frame: .zero)
        scrollView.contentSize = contentViewSize
        scrollView.frame = self.view.bounds
        scrollView.showsVerticalScrollIndicator = true
        return scrollView
    }()
    
    lazy var containerView: UIView = {
        let containerView = UIView()
        containerView.frame.size = contentViewSize
        return containerView
    }()
    
    let mainHeadingLabel: UILabel = {
        let label = UILabel()
        label.text = "Suggest a new feature, an improvement or a podcast."
        label.font = UIFont.systemFont(ofSize: 23, weight: .bold)
        label.textColor = CustomStyle.primaryBlack
        label.numberOfLines = 0
        return label
    }()
    
    var questionOne = SurveyQuestionView(question: "What do you have for us?",
                                         info: nil, type: .multipleChoice,
                                         answers: [
                                            "A new feature",
                                            "An improvement",
                                            "A podcast"
    ])
    
    var questionTwo = SurveyQuestionView(question: "Which part of the app are you thinking?",
                                         info: nil, type: .multipleChoice,
                                         answers: [
                                            "The app in general",
                                            "Daily Feed",
                                            "Trending",
                                            "Search",
                                            "Profiles",
                                            "Studio",
                                            "Play-bar"
    ])
    
    var questionThree = SurveyQuestionView(question: "How essential do you deem this suggestion?",
                                         info: nil, type: .multipleChoice,
                                         answers: [
                                            "It would be great",
                                            "Just an idea",
                                            "It's crucial",
    ])
    
    let descriptionLabel: UILabel = {
        let label = UILabel()
        label.text = "Include a description"
        label.font = UIFont.systemFont(ofSize: 14, weight: .bold)
        label.textColor = CustomStyle.primaryBlack
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        return label
    }()
    
    let suggestionView: UITextView = {
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
            contentViewSize = CGSize(width: view.frame.width, height: 1160.0)
        case .iPhone8:
            contentViewSize = CGSize(width: view.frame.width, height: 1160.0)
        case .iPhone8Plus:
            contentViewSize = CGSize(width: view.frame.width, height: 1160.0)
        case .iPhone11:
            contentViewSize = CGSize(width: view.frame.width, height: 1220.0)
        case .iPhone11Pro:
            contentViewSize = CGSize(width: view.frame.width, height: 1220.0)
        case .iPhone11ProMax:
            contentViewSize = CGSize(width: view.frame.width, height: 1220.0)
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
        
        containerView.addSubview(questionOne)
        questionOne.translatesAutoresizingMaskIntoConstraints = false
        questionOne.topAnchor.constraint(equalTo: mainHeadingLabel.bottomAnchor, constant: 45).isActive = true
        questionOne.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16).isActive = true
        questionOne.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16).isActive = true
        questionOne.answerSelected = checkAllQuestions
        surveyQuestions.append(questionOne)
        
        containerView.addSubview(questionTwo)
        questionTwo.translatesAutoresizingMaskIntoConstraints = false
        questionTwo.topAnchor.constraint(equalTo: questionOne.bottomAnchor, constant: 45).isActive = true
        questionTwo.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16).isActive = true
        questionTwo.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16).isActive = true
        questionTwo.answerSelected = checkAllQuestions
        surveyQuestions.append(questionTwo)
        
        containerView.addSubview(questionThree)
        questionThree.translatesAutoresizingMaskIntoConstraints = false
        questionThree.topAnchor.constraint(equalTo: questionTwo.bottomAnchor, constant: 45).isActive = true
        questionThree.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16).isActive = true
        questionThree.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16).isActive = true
        questionThree.answerSelected = checkAllQuestions
        surveyQuestions.append(questionThree)
        
        containerView.addSubview(descriptionLabel)
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        descriptionLabel.topAnchor.constraint(equalTo: questionThree.bottomAnchor, constant: 40).isActive = true
        descriptionLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16).isActive = true
        descriptionLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16).isActive = true
        
        containerView.addSubview(suggestionView)
        suggestionView.translatesAutoresizingMaskIntoConstraints = false
        suggestionView.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 10).isActive = true
        suggestionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16).isActive = true
        suggestionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16).isActive = true
        suggestionView.heightAnchor.constraint(equalToConstant: 100).isActive = true
        suggestionView.delegate = self
        
        containerView.addSubview(submitButton)
        submitButton.translatesAutoresizingMaskIntoConstraints = false
        submitButton.topAnchor.constraint(equalTo: suggestionView.bottomAnchor, constant: 30).isActive = true
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
        
        if suggestionView.text != nil && suggestionView.text != ""  {
            answers.append(suggestionView.text)
        }
        
        print(answers.count)
        if answers.count == 4 {
            submitButton.backgroundColor = CustomStyle.primaryYellow
            submitButton.setTitleColor( .black, for: .normal)
        } else {
            submitButton.backgroundColor = CustomStyle.secondShade
            submitButton.setTitleColor( CustomStyle.thirdShade, for: .normal)
        }
    }
    
    @objc func submitButtonPress() {
        if answers.count == 4 {
            clearAnswers()
            let db = Firestore.firestore()
            
            DispatchQueue.global(qos: .userInitiated).async {
                let dateTime = Date.formattedToString(style: .medium)
                let suggestionRef = db.collection("suggestions").document(dateTime)

                let locale = Locale.current
                
                suggestionRef.setData([
                    "UserID" : User.ID!,
                    "Version" : VersionControl.version,
                    "Build" : VersionControl.build,
                    "isPublisher" : CurrentProgram.isPublisher!,
                    "regionCode" : locale.regionCode ?? "Unknown",
                    "Question 1" : self.answers[0],
                    "Question 2" : self.answers[1],
                    "Question 3" : self.answers[2],
                    "Question 4" : self.answers[3],
                ]) { (error) in
                    if let error = error {
                        print("Error adding suggestion entry \(error.localizedDescription)")
                    } else {
                        print("Success adding suggestion entry")
                    }
                }

            }
        }
    }
    
    func clearAnswers() {
        submitButton.setTitle("Suggestion sent", for: .normal)
        suggestionView.text = ""
        DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
            for each in self.surveyQuestions {
                each.clearAnswer()
            }
            self.scrollView.setScrollViewToTop()
            self.suggestionView.resignFirstResponder()
            self.submitButton.setTitle("Submit", for: .normal)
        })
    }
    
}

extension SuggestionVC: UITextViewDelegate {
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        self.scrollView.setScrollBarToBottom()
    }
    
    func textViewDidChange(_ textView: UITextView) {
        checkAllQuestions()
    }
    
}

