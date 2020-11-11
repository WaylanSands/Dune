//
//  InvitePeopleVC.swift
//  Dune
//
//  Created by Waylan Sands on 27/2/20.
//  Copyright © 2020 Waylan Sands. All rights reserved.
//

import UIKit
import MessageUI
import FirebaseFirestore

class ListenerSurveyVC: UIViewController {
    
    let betaVersion = "Version: \(VersionControl.version) - Build: \(VersionControl.build)"
    let leavingSurveyAlert = CustomAlertView(alertType: .leavingFeedbackForm)
    lazy var contentViewSize = CGSize(width: view.frame.width, height: 2760.0)
    
    let thankYouView = SurveyThanksView()
    
    var surveyQuestions = [SurveyQuestionView]()
    var answers = [String]()
    
    let customNavBar: CustomNavBar = {
        let nav = CustomNavBar()
        nav.leftButton.isHidden = true
        nav.backgroundColor = CustomStyle.blackNavBar
        nav.titleLabel.text = "Version 1.0"
        return nav
    }()
    
    lazy var scrollView: UIView = {
        let scrollView = UIScrollView(frame: .zero)
        scrollView.contentSize = contentViewSize
        scrollView.frame = self.view.bounds
        scrollView.showsVerticalScrollIndicator = false
        return scrollView
    }()
    
    lazy var containerView: UIView = {
        let containerView = UIView()
        containerView.frame.size = contentViewSize
        return containerView
    }()
    
    let mainHeadingLabel: UILabel = {
        let label = UILabel()
        label.text = "Let’s make Dune awesome, together."
        label.font = UIFont.systemFont(ofSize: 23, weight: .bold)
        label.textColor = CustomStyle.primaryBlack
        label.numberOfLines = 0
        return label
    }()
    
    let mainSubHeadingLabel: UILabel = {
        let label = UILabel()
        label.text = """
        Thanks for taking a moment to provide some quick feedback. Your thoughts and suggestions are essential for us to build a better product tailored to you.
        
        During each new release this survey will be updated so we can check that we have fulfilled your wishes.
        """
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        label.textColor = CustomStyle.primaryBlack
        label.addLineSpacing()
        label.numberOfLines = 0
        return label
    }()
    
    var questionOne = SurveyQuestionView(question: "1) What sort of content would you like most out of a daily listening app?",
                                         info: nil, type: .multipleChoice,
                                         answers: [
                                            "News Briefings",
                                            "Entertaining",
                                            "Educational",
                                            "Motivational",
                                            "Wellness",
    ])
    
    var questionTwo = SurveyQuestionView(question: "2) What would be your ideal duration for an episode?",
                                         info: nil, type: .multipleChoice,
                                         answers: [
                                            "1 - 5 minutes",
                                            "5 - 10 minutes",
                                            "10 - 15 minutes",
                                            "15 - 20 minutes",
    ])
    
    var questionThree = SurveyQuestionView(question: "3) How satisfied are you with the current selection of channels?",
                                         info: nil, type: .multipleChoice,
                                         answers: [
                                            "There’s a good selection",
                                            "Need higher quality options",
                                            "Could be more to choose from",
                                            "Barley a selection",
    ])
    
    var questionFour = SurveyQuestionView(question: "4) How do you currently rate Dune?",
                                         info: nil, type: .multipleChoice,
                                         answers: [
                                            "It's awesome",
                                            "It’s great",
                                            "Has potential",
                                            "Zero stars",
    ])
    
    var questionFive = SurveyQuestionView(question: "5) What do you like most about Dune?",
                                         info: nil, type: .multipleChoice,
                                         answers: [
                                            "The accessibility of short episodes",
                                            "The ability to connect with channels",
                                            "Being apart of the community",
                                            "Listening while on the go",
    ])
    
    var questionSix = SurveyQuestionView(question: "6) What do you consider the weakest part of the app?",
                                         info: nil, type: .multipleChoice,
                                         answers: [
                                            "The lack of channels",
                                            "The quality of the content",
                                            "Channels are not relevant to my location",
                                            "Listening functionality",
                                            "Search functionality",
    ])
    
    var questionSeven = SurveyQuestionView(question: "7) Would you ever consider publishing content?",
                                         info: nil, type: .multipleChoice,
                                         answers: [
                                            "Don't know what I'd talk about",
                                            "I'm not interested",
                                            "I need the equipment",
                                            "I have plans to",
    ])
    
    var questionEight = SurveyQuestionView(question: "8) How likely will you continue to use Dune?",
                                         info: nil, type: .multipleChoice,
                                         answers: [
                                            "Very unlikely",
                                            "Unsure at this stage",
                                            "I’ll continue the journey",
                                            "I’m all in",
    ])
    
    var questionNine = SurveyQuestionView(question: "9) What would you like to see next?",
                                          info: """
You can add your own ideas to our "Make a suggestion form".
"""
        , type: .multipleChoice,
          answers: [
            "The ability to save episodes",
            "The ability to share episodes as a video",
            "The ability to filter Trending content",
            "For us to create curated collections of channels for easier discovery",
    ])
    
    var questionTen = SurveyQuestionView(question: "10) Where do you like to go to discover new apps and tools?",
                                         info: "This is to help us know where to find other people like you",
                                         type: .multipleChoice,
                                         answers: [
                                            "App Store",
                                            "News Articles / Blogs",
                                            "Reddit / Forums",
                                            "Social Media",
    ])
    
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavigation()
        styleForScreens()
        configureViews()
        leavingSurveyAlert.alertDelegate = self
        thankYouView.sendSMS = shareViaSMS
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if let surveyCompleted = User.surveysCompleted {
            if surveyCompleted.contains(betaVersion) {
                view.addSubview(thankYouView)
                thankYouView.pinEdges(to: view)
                duneTabBar.isHidden = true
            }
        }
    }
    
    func configureNavigation() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "back-button-white"), style: .plain, target: self, action: #selector(backButtonPress))
    }
    
    @objc func backButtonPress() {
        if User.surveysCompleted == nil || !User.surveysCompleted!.contains(betaVersion) {
            UIApplication.shared.windows.last?.addSubview(leavingSurveyAlert)
        } else {
            navigationController?.popViewController(animated: true)
        }
    }
    
    private func styleForScreens() {
        switch UIDevice.current.deviceType {
        case .iPhone4S, .iPhoneSE:
            contentViewSize = CGSize(width: view.frame.width, height: 2800.0)
        case .iPhone8:
            contentViewSize = CGSize(width: view.frame.width, height: 2700.0)
        case .iPhone8Plus:
            contentViewSize = CGSize(width: view.frame.width, height: 2640.0)
        case .iPhone11:
            contentViewSize = CGSize(width: view.frame.width, height: 2630.0)
        case .iPhone11Pro:
            contentViewSize = CGSize(width: view.frame.width, height: 2700.0)
        case .iPhone12:
            contentViewSize = CGSize(width: view.frame.width, height: 2700.0)
        case .iPhone11ProMax:
            contentViewSize = CGSize(width: view.frame.width, height: 2630.0)
        case .iPhone12ProMax:
            contentViewSize = CGSize(width: view.frame.width, height: 2630.0)
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
        mainHeadingLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 30).isActive = true
        mainHeadingLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16).isActive = true
        mainHeadingLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16).isActive = true
        
        containerView.addSubview(mainSubHeadingLabel)
        mainSubHeadingLabel.translatesAutoresizingMaskIntoConstraints = false
        mainSubHeadingLabel.topAnchor.constraint(equalTo: mainHeadingLabel.bottomAnchor, constant: 20).isActive = true
        mainSubHeadingLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16).isActive = true
        mainSubHeadingLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16).isActive = true
        
        containerView.addSubview(questionOne)
        questionOne.translatesAutoresizingMaskIntoConstraints = false
        questionOne.topAnchor.constraint(equalTo: mainSubHeadingLabel.bottomAnchor, constant: 45).isActive = true
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
        
        containerView.addSubview(questionFour)
        questionFour.translatesAutoresizingMaskIntoConstraints = false
        questionFour.topAnchor.constraint(equalTo: questionThree.bottomAnchor, constant: 45).isActive = true
        questionFour.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16).isActive = true
        questionFour.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16).isActive = true
        questionFour.answerSelected = checkAllQuestions
        surveyQuestions.append(questionFour)
        
        containerView.addSubview(questionFive)
        questionFive.translatesAutoresizingMaskIntoConstraints = false
        questionFive.topAnchor.constraint(equalTo: questionFour.bottomAnchor, constant: 45).isActive = true
        questionFive.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16).isActive = true
        questionFive.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16).isActive = true
        questionFive.answerSelected = checkAllQuestions
        surveyQuestions.append(questionFive)
        
        containerView.addSubview(questionSix)
        questionSix.translatesAutoresizingMaskIntoConstraints = false
        questionSix.topAnchor.constraint(equalTo: questionFive.bottomAnchor, constant: 45).isActive = true
        questionSix.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16).isActive = true
        questionSix.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16).isActive = true
        questionSix.answerSelected = checkAllQuestions
        surveyQuestions.append(questionSix)
        
        containerView.addSubview(questionSeven)
        questionSeven.translatesAutoresizingMaskIntoConstraints = false
        questionSeven.topAnchor.constraint(equalTo: questionSix.bottomAnchor, constant: 45).isActive = true
        questionSeven.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16).isActive = true
        questionSeven.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16).isActive = true
        questionSeven.answerSelected = checkAllQuestions
        surveyQuestions.append(questionSeven)
        
        containerView.addSubview(questionEight)
        questionEight.translatesAutoresizingMaskIntoConstraints = false
        questionEight.topAnchor.constraint(equalTo: questionSeven.bottomAnchor, constant: 45).isActive = true
        questionEight.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16).isActive = true
        questionEight.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16).isActive = true
        questionEight.answerSelected = checkAllQuestions
        surveyQuestions.append(questionEight)
        
        containerView.addSubview(questionNine)
        questionNine.translatesAutoresizingMaskIntoConstraints = false
        questionNine.topAnchor.constraint(equalTo: questionEight.bottomAnchor, constant: 45).isActive = true
        questionNine.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16).isActive = true
        questionNine.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16).isActive = true
        questionNine.answerSelected = checkAllQuestions
        surveyQuestions.append(questionNine)
        
        containerView.addSubview(questionTen)
        questionTen.translatesAutoresizingMaskIntoConstraints = false
        questionTen.topAnchor.constraint(equalTo: questionNine.bottomAnchor, constant: 45).isActive = true
        questionTen.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16).isActive = true
        questionTen.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16).isActive = true
        questionTen.answerSelected = checkAllQuestions
        surveyQuestions.append(questionTen)
        
        containerView.addSubview(submitButton)
        submitButton.translatesAutoresizingMaskIntoConstraints = false
        submitButton.topAnchor.constraint(equalTo: questionTen.bottomAnchor, constant: 45).isActive = true
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
        print(answers.count)
        if answers.count == 10 {
            submitButton.backgroundColor = CustomStyle.primaryYellow
            submitButton.setTitleColor( .black, for: .normal)
        } else {
            submitButton.backgroundColor = CustomStyle.secondShade
            submitButton.setTitleColor( CustomStyle.thirdShade, for: .normal)
        }
    }
    
    @objc func submitButtonPress() {
        if answers.count == 10 {
            User.surveysCompleted = []
            User.surveysCompleted!.append(betaVersion)
            
            view.addSubview(thankYouView)
            thankYouView.pinEdges(to: view)
            duneTabBar.isHidden = true
            
            let db = Firestore.firestore()
            
            DispatchQueue.global(qos: .userInitiated).async {
                let dateTime = Date.formattedToString(style: .medium)

                let userRef = db.collection("users").document(User.ID!)
                let surveyRef = db.collection("listenerSurveys").document(dateTime)
                
                userRef.updateData([
                    "surveysCompleted" : FieldValue.arrayUnion([self.betaVersion])
                ]) { (error) in
                    if let error = error {
                        print("Error updating survey completed: \(error.localizedDescription)")
                    } else {
                        print("Success updating survey completed")
                    }
                }
                
                let locale = Locale.current
                
                surveyRef.setData([
                    "UserID" : User.ID!,
                    "isSetUp" : User.isSetUp!,
                    "Interests" : User.interests!,
                    "betaVersion" : self.betaVersion,
                    "Device" : UIDevice.current.deviceType.rawValue,
                    "Surveys completed" : User.surveysCompleted!.count,
                    "regionCode" : locale.regionCode ?? "Unknown",
                    "Question 1" : self.answers[0],
                    "Question 2" : self.answers[1],
                    "Question 3" : self.answers[2],
                    "Question 4" : self.answers[3],
                    "Question 5" : self.answers[4],
                    "Question 6" : self.answers[5],
                    "Question 7" : self.answers[6],
                    "Question 8" : self.answers[7],
                    "Question 9" : self.answers[8],
                    "Question 10" : self.answers[9],
                ]) { (error) in
                    if let error = error {
                        print("Error adding survey entry \(error.localizedDescription)")
                    } else {
                        print("Success adding survey entry")
                    }
                }

            }
            
        }
    }
    
    func shareViaSMS() {
        if (MFMessageComposeViewController.canSendText()) {
            let controller = MFMessageComposeViewController()
            controller.body = "I think you would find this useful www.dailyune.com"
            controller.messageComposeDelegate = self
            present(controller, animated: true, completion: nil)
        }
    }

}

extension ListenerSurveyVC: MFMessageComposeViewControllerDelegate {

    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
        //... handle sms screen actions
        dismiss(animated: true, completion: nil)
    }

}

extension ListenerSurveyVC: CustomAlertDelegate {
    
    func primaryButtonPress() {
            navigationController?.popViewController(animated: true)
    }
    
    func cancelButtonPress() {
        // No implementation needed
    }

}

