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
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16.0, weight: .semibold)
        button.addTarget(self, action: #selector(continueButtonPress), for: .touchUpInside)
        button.isEnabled = false
        return button
    }()
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        styleForScreens()
        configureViews()
        styleTextField(textField: nameTextField, placeholder: "")
        nameTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: UIControl.Event.editingChanged)
        setHeadline()
        setupKeyboardTracking()
        configureNavBar()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        nameTextField.becomeFirstResponder()

    }
    
    func configureNavBar() {
        view.addSubview(customNavBar)
        customNavBar.pinNavBarTo(view)
    }
    
    func setupKeyboardTracking() {
        nameTextField.delegate = self
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
        case .iPhone11Pro:
            break
        case .iPhone11ProMax:
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
            your program?
            """
    }
    
    @objc func backButtonPress(_ sender: Any) {
        nameTextField.resignFirstResponder()
        navigationController?.popViewController(animated: true)
    }
    
    @objc func continueButtonPress() {
        
        guard let name = self.nameTextField.text else { return }
        Program.name = name

        DispatchQueue.global(qos: .userInitiated).async {
            
            let programID = NSUUID().uuidString
            guard let uid = Auth.auth().currentUser?.uid else { return }
            
            User.ID = uid
            User.programID = programID
            Program.ID = programID
            User.subscriptionIDs = [programID]
            Program.isPrimaryProgram = true
            
            FileManager.createUserFolderForPublisher(programID: Program.ID!)
            
            let db = Firestore.firestore()
            let userRef = db.collection("users").document(User.ID!)
            let programRef = db.collection("programs").document(User.programID!)
            
            
            
            userRef.updateData([
                "programID": User.programID!,
                "subscriptionIDs" : [User.programID!]
                    ])
             { (error) in
                if let error = error {
                    print("There has been an error adding program ID: \(error.localizedDescription)")
                } else {
                    print("Successfully added channel ID")
                    
                    programRef.setData([
                        "ID" : Program.ID!,
                        "name" : name,
                        "ownerID" : User.ID!,
                        "isPrimaryProgram" : true
                    ]) { (error) in
                        if let error = error {
                            print("There has been an error adding the program: \(error.localizedDescription)")
                        } else {
                            print("Successfully added channel")
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
        if let imageController = UIStoryboard(name: "OnboardingPublisher", bundle: nil).instantiateViewController(withIdentifier: "ImageController") as? publisherImageVC {
            navigationController?.pushViewController(imageController, animated: true)
        }
    }
    
}

extension ProgramNameVC: UITextFieldDelegate {
   
    @objc func textFieldDidChange(_ textField: UITextField) {
        if textField.text?.isEmpty == false {
            continueButton.isEnabled = true
        } else {
            continueButton.isEnabled = false
        }
    }
    
    @objc func keyboardWillChange(notification : Notification) {
        guard let keyboardRect = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else {
            return
        }
        continueButton.frame.origin.y = view.frame.height - keyboardRect.height - 45.0
    }
}
