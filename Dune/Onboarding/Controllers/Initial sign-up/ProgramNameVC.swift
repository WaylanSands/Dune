//
//  publisherNameController.swift
//  Dune
//
//  Created by Waylan Sands on 19/1/20.
//  Copyright © 2020 Waylan Sands. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseFirestore

class ProgramNameVC: UIViewController {
    
    @IBOutlet weak var headingLabel: UILabel!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var maxCharactersLabel: UILabel!
    @IBOutlet weak var headingLabelTopAnchor: NSLayoutConstraint!
    
    var homeIndicatorHeight:CGFloat = 34.0
    
    let customNavBar: CustomNavBar = {
        let navBar = CustomNavBar()
        navBar.titleLabel.text = ""
        navBar.rightButton.isHidden = true
        navBar.leftButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: -10, bottom: 0, right: 0)
        navBar.leftButton.addTarget(self, action: #selector(backButtonPress), for: .touchUpInside)
        return navBar
    }()
    
    lazy var containerView: UIView = {
        let view = UIView()
        view.frame = self.view.bounds
        return view
    }()
    
    let continueButton: UIButton = {
        let button = UIButton()
        button.isEnabled = true
        button.backgroundColor = CustomStyle.primaryBlue
        button.setTitle("Continue", for: .normal)
        button.setTitleColor(UIColor.white.withAlphaComponent(0.4), for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16.0, weight: .semibold)
        button.addTarget(self, action: #selector(continueButtonPress), for: .touchUpInside)
        button.isEnabled = false
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        styleForScreens()
        configureViews()
        styleTextField(textField: nameTextField, placeholder: "")
        setHeadline()
        setupKeyboardTracking()
        configureNavBar()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidAppear(_ animated: Bool) {
        nameTextField.becomeFirstResponder()
        checkIfOkToContinue()
    }
    
    func configureNavBar() {
        navigationController?.isNavigationBarHidden = true
        view.addSubview(customNavBar)
        customNavBar.pinNavBarTo(view)
    }
    
    func setupKeyboardTracking() {
        nameTextField.delegate = self
        nameTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: UIControl.Event.editingChanged)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange(notification:)), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
    }
    
    func configureViews() {
        view.addSubview(containerView)
        view.sendSubviewToBack(containerView)
        containerView.addSubview(continueButton)
        continueButton.translatesAutoresizingMaskIntoConstraints = false
        continueButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -homeIndicatorHeight).isActive = true
        continueButton.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        continueButton.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        continueButton.heightAnchor.constraint(equalToConstant: 45.0).isActive = true
    }
    
    func styleForScreens() {
        switch UIDevice.current.deviceType {
        case .iPhone4S:
            break
        case .iPhoneSE:
            headingLabel.font = UIFont.systemFont(ofSize: 26, weight: .bold)
            headingLabelTopAnchor.constant = 40.0
            homeIndicatorHeight = 0.0
        case .iPhone8:
            homeIndicatorHeight = 0.0
        case .iPhone8Plus:
            homeIndicatorHeight = 0.0
        case .iPhone11:
            break
        case .iPhone11Pro, .iPhone12:
            break
        case .iPhone11ProMax, .iPhone12ProMax:
            break
        case .unknown:
            break
        }
    }
    
    func styleTextField(textField: UITextField, placeholder: String) {
        textField.backgroundColor = CustomStyle.sixthShade
        textField.attributedPlaceholder = NSAttributedString(string: "\(placeholder)", attributes: [NSAttributedString.Key.foregroundColor: CustomStyle.fifthShade])
        textField.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        textField.borderStyle = UITextField.BorderStyle.none
        textField.autocorrectionType = UITextAutocorrectionType.no
        textField.keyboardType = UIKeyboardType.default
        textField.clearButtonMode = UITextField.ViewMode.whileEditing
        textField.contentVerticalAlignment = UIControl.ContentVerticalAlignment.center
        textField.layer.cornerRadius = 6.0
        textField.layer.masksToBounds = true
        textField.autocapitalizationType = .sentences
        textField.setLeftPadding(20)
    }
    
    func setHeadline() {
        headingLabel.text = """
        What's the name of
        your channel?
        """
    }
    
    @objc func backButtonPress(_ sender: Any) {
        nameTextField.resignFirstResponder()
        navigationController?.popViewController(animated: true)
    }
    
    @objc func continueButtonPress() {
        
        guard let name = self.nameTextField.text?.trimmingTrailingSpaces else { return }
        CurrentProgram.name = name
        if User.recommendedProgram == nil {
            CurrentProgram.subscriptionIDs = [String]()
        }
        
        DispatchQueue.global(qos: .userInitiated).async {
            
            let programID = NSUUID().uuidString
            guard let uid = Auth.auth().currentUser?.uid else { return }
            
            User.ID = uid
            CurrentProgram.rep = 0
            CurrentProgram.isPublisher = true
            CurrentProgram.hasMentions = false
            CurrentProgram.repMethods = [String]()
            CurrentProgram.username = User.username
            CurrentProgram.subscriptionIDs!.append(CurrentProgram.ID ?? programID)
            CurrentProgram.ID = CurrentProgram.ID ?? programID
            User.programID = CurrentProgram.ID ?? programID
            CurrentProgram.episodeIDs = [[String : Any]]()
            CurrentProgram.subscriberIDs = [String]()
            CurrentProgram.programIDs = [String]()
            CurrentProgram.isPrimaryProgram = true
            CurrentProgram.subscriberCount = 0
            CurrentProgram.hasIntro = false
            CurrentProgram.subPrograms = [Program]()
            
            // Private channel
            CurrentProgram.privacyStatus = .madePublic
            CurrentProgram.pendingChannels = [String]()
            CurrentProgram.deniedChannels = [String]()
            
            let db = Firestore.firestore()
            let userRef = db.collection("users").document(User.ID!)
            let programRef = db.collection("programs").document(User.programID!)
            
            userRef.updateData(["programID": User.programID!]) { error in
                if let error = error {
                    print("Error adding program ID to user: \(error.localizedDescription)")
                } else {
                    
                    programRef.setData([
                        "subscriptionIDs" :  CurrentProgram.subscriptionIDs!,
                        "episodeIDs" : CurrentProgram.episodeIDs!,
                        "summary": CurrentProgram.summary ?? "",
                        "privacyStatus" : "madePublic",
                        "username" : User.username!,
                        "ID" : CurrentProgram.ID!,
                        "isPrimaryProgram" : true,
                        "pendingChannels": [],
                        "deniedChannels" : [],
                        "subscriberCount" : 0,
                        "hasMentions" : false,
                        "isPublisher" : true,
                        "ownerID" : User.ID!,
                        "addedByDune": false,
                        "subscriberIDs": [],
                        "programIDs" : [],
                        "hasIntro" : false,
                        "repMethods" : [],
                        "locationType": "Global",
                        "name" : name,
                        "rep" : 0,
                        "tags": []
                    ]) { error in
                        if let error = error {
                            print("Error creating channel: \(error.localizedDescription)")
                        } else {
                            print("Successfully created channel")
                            self.nameTextField.resignFirstResponder()
                            
                            DispatchQueue.main.async {
                                self.continueButton.frame.origin.y =  self.view.frame.height - ( self.continueButton.frame.height +  self.homeIndicatorHeight)
                            }
                        }
                    }
                }
            }
        }
        self.presentNextVC()
    }
    
    func presentNextVC() {
        if CurrentProgram.image != nil {
            if let categoriesController = UIStoryboard(name: "OnboardingPublisher", bundle: nil).instantiateViewController(withIdentifier: "categoriesController") as? PublisherCategoriesVC {
                navigationController?.pushViewController(categoriesController, animated: true)
            }
        } else {
            if let imageController = UIStoryboard(name: "OnboardingPublisher", bundle: nil).instantiateViewController(withIdentifier: "ImageController") as? PublisherImageVC {
                navigationController?.pushViewController(imageController, animated: true)
            }
        }
    }
    
    func checkIfOkToContinue() {
        
        if !nameTextField.text!.isEmpty {
            continueButton.isEnabled = true
            continueButton.setTitleColor(UIColor.white, for: .normal)
        } else {
            continueButton.isEnabled = false
            continueButton.setTitleColor(UIColor.white.withAlphaComponent(0.4), for: .normal)
        }
    }
}

extension ProgramNameVC: UITextFieldDelegate {
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        
        if textField.text!.count > 32  {
            self.nameTextField.text = String(textField.text!.prefix(32))
            nameTextField.shake()
        }
        
        checkIfOkToContinue()
    }
    
    @objc func keyboardWillChange(notification : Notification) {
        guard let keyboardRect = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else {
            return
        }
        continueButton.frame.origin.y = view.frame.height - keyboardRect.height - 45.0
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        let  char = string.cString(using: String.Encoding.utf8)!
        let isBackSpace = strcmp(char, "\\b")
        
        if (isBackSpace == -92) {
            return true
        }
        
        if nameTextField.text?.count == 32 {
            nameTextField.shake()
            return false
        }
        return true
    }
    
}
