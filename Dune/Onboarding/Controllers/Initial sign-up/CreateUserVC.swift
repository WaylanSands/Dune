//
//  CreateUsernameViewController.swift
//  Snippets
//
//  Created by Waylan Sands on 9/1/20.
//  Copyright © 2020 Waylan Sands. All rights reserved.
//

import UIKit
import FirebaseFirestore

protocol NextButtonDelegate {
    func makeNextButton(active: Bool)
    func keyboatrdNextButtonPress()
}

class CreateUserVC: UIViewController {
    
    @IBOutlet weak var progressBar: UIImageView!
    @IBOutlet weak var progressBarSE: UIImageView!
    @IBOutlet weak var progressBarTopAnchor: NSLayoutConstraint!
    
    var nextButtonYPosition: CGFloat = 14
    var datePickerDistance: CGFloat  = 40.0
    lazy var screenWidth = view.frame.width
    lazy var centerXposition = self.view.frame.origin.x
    let Under18Years = Calendar.current.date(byAdding: .year, value: -18, to: Date())
    
    let db = Firestore.firestore()
    
    let nextButtonReal: UIButton = {
        let button = UIButton()
        button.setTitle("Next", for: .normal)
        button.backgroundColor = CustomStyle.primaryBlue
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        button.addTarget(self, action: #selector(nextButtonPress), for: .touchUpInside)
        button.layer.cornerRadius = 6
        return button
    }()
    
    let customNavBar: CustomNavBar = {
        let navbar = CustomNavBar()
        navbar.leftButton.setImage(#imageLiteral(resourceName: "back-button-blk"), for: .normal)
        navbar.rightButton.isHidden = true
        navbar.leftButton.addTarget(self, action: #selector(backButtonPress), for: .touchUpInside)
        navbar.backgroundColor = .clear
        return navbar
    }()
    
    let datePicker: UIDatePicker = {
        let picker = UIDatePicker()
        picker.datePickerMode = .date
        picker.addTarget(self, action: #selector(updateDateLabel), for: .valueChanged)
        picker.isHidden = true
        return picker
    }()
    
    lazy var dateLabel: UIButton = {
        let button = UIButton()
        button.isEnabled = false
        button.titleLabel!.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        button.setTitle("", for: .normal)
        button.setTitleColor(CustomStyle.primaryblack, for: .normal)
        button.backgroundColor = CustomStyle.secondShade
        button.layer.cornerRadius = 7
        button.isHidden = true
        button.titleEdgeInsets = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 0)
        return button
    }()
    
    // Subviews
    let containerView = UIView()
    let addEmail = AddEmail(frame: .zero)
    let createPassword = CreatePassword(frame: .zero)
    let addBirthDate = AddBirthDate(frame: .zero)
    let createUsername = CreateUsername(frame: .zero)
    
    // First subview
    lazy var currentView: UIView = createUsername
    var nextButtonActive = false
    
    // View Did Load
    override func viewDidLoad() {
        super.viewDidLoad()
        styleForScreens()
        configureViews()
    }

    
    func styleForScreens() {
        switch UIDevice.current.deviceType {
        case .iPhoneSE:
            nextButtonYPosition = 4
            progressBar.isHidden = true
            datePickerDistance = 20.0
        case .iPhone8:
            nextButtonYPosition = 20
            progressBarTopAnchor.constant = 60.0
        case .iPhone8Plus:
            break
        case .iPhone11:
            break
        case .iPhone11Pro:
            break
        case .iPhone11ProMax:
            break
        default:
            break
        }
    }
    
    func configureViews() {
        
        self.view.addSubview(containerView)
        containerView.translatesAutoresizingMaskIntoConstraints = false
        containerView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        containerView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        containerView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        containerView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        
        containerView.addSubview(createUsername)
        createUsername.translatesAutoresizingMaskIntoConstraints = false
        createUsername.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        createUsername.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        createUsername.widthAnchor.constraint(equalToConstant: screenWidth).isActive = true
        createUsername.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        createUsername.nextButtonDelegate = self
        
        containerView.addSubview(addEmail)
        addEmail.translatesAutoresizingMaskIntoConstraints = false
        addEmail.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        addEmail.leadingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        addEmail.widthAnchor.constraint(equalToConstant: screenWidth).isActive = true
        addEmail.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        addEmail.nextButtonDelegate = self
        
        containerView.addSubview(createPassword)
        createPassword.translatesAutoresizingMaskIntoConstraints = false
        createPassword.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        createPassword.leadingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        createPassword.widthAnchor.constraint(equalToConstant: screenWidth).isActive = true
        createPassword.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        createPassword.nextButtonDelegate = self
        
        containerView.addSubview(addBirthDate)
        addBirthDate.translatesAutoresizingMaskIntoConstraints = false
        addBirthDate.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        addBirthDate.widthAnchor.constraint(equalToConstant: screenWidth).isActive = true
        addBirthDate.leadingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        addBirthDate.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        addBirthDate.nextButtonDelegate = self
        
        view.addSubview(nextButtonReal)
        nextButtonReal.translatesAutoresizingMaskIntoConstraints = false
        nextButtonReal.heightAnchor.constraint(equalToConstant: 40).isActive = true
        nextButtonReal.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16).isActive = true
        nextButtonReal.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16).isActive = true
        nextButtonReal.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: nextButtonYPosition).isActive = true
        
        view.addSubview(datePicker)
        datePicker.translatesAutoresizingMaskIntoConstraints = false
        datePicker.topAnchor.constraint(equalTo: nextButtonReal.bottomAnchor, constant: datePickerDistance).isActive = true
        datePicker.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        datePicker.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        datePicker.setYearValidation()
        
        view.addSubview(dateLabel)
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        dateLabel.bottomAnchor.constraint(equalTo: nextButtonReal.topAnchor, constant: -10.0).isActive = true
        dateLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16.0).isActive = true
        dateLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16).isActive = true
        dateLabel.heightAnchor.constraint(equalToConstant: 40.0).isActive = true
        updateDateLabel()
        
        view.bringSubviewToFront(progressBar)
        
        view.addSubview(customNavBar)
        customNavBar.pinNavBarTo(view)
    }
    
    // Transition functions
    func toCenter(view: UIView) {
        view.frame.origin.x = self.centerXposition
    }

    func backOffScreen(view: UIView) {
        view.frame.origin.x -= screenWidth
    }
    
    func forwardOffScreen(view: UIView) {
        view.frame.origin.x += screenWidth
    }
    
    func transitionToCenter(view: UIView) {
        UIView.transition(with: view, duration: 0.5, options: .curveEaseInOut, animations: {self.toCenter(view: view)}, completion: {(value: Bool) in
            self.currentView = view
        })
    }
    
    func transitionBackwards(view: UIView) {
        UIView.transition(with: view, duration: 0.5, options: .curveEaseInOut, animations:  {self.backOffScreen(view: view)}, completion: {(value: Bool) in
        })
    }
    
    func transitionForward(view: UIView) {
        UIView.transition(with: view, duration: 0.5, options: .curveEaseInOut, animations: {self.forwardOffScreen(view: view)}, completion: {(value: Bool) in
        })
    }
    
    // SubViews Controls
    
    @IBAction func nextButtonPress() {
        
        if datePicker.date > Under18Years! && currentView == addBirthDate {
            
            let alert = UIAlertController(title: "Age Restrictions", message: """
                The current date entered indicates you are under 18 years old.

                Is this correct?
                """, preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "Yes", style: UIAlertAction.Style.default, handler: {(alert: UIAlertAction!) in
                self.navigateToAccountType()
            }))
                
            alert.addAction(UIAlertAction(title: "No", style: UIAlertAction.Style.cancel, handler: nil))
            self.present(alert, animated: true, completion: nil)
        } else if datePicker.date <= Under18Years! && currentView == addBirthDate {
            User.birthDate = datePicker.dateToStringMMMddYYY()
            self.navigateToAccountType()
        }
        
        if nextButtonActive == false && currentView == addEmail {
            if addEmail.emailAvailable != false {
                addEmail.emailTextField.shake()
                addEmail.showInvalidMessage()
            } else {
                let alert = UIAlertController(title: "Email Address Taken", message: "This email address is already in use.", preferredStyle: .alert)
                          
                          alert.addAction(UIAlertAction(title: "Reset Password", style: UIAlertAction.Style.default, handler: {(alert: UIAlertAction!) in
                              self.navigateToAccountType()
                          }))
                              
                          alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler: nil))
                          self.present(alert, animated: true, completion: nil)
            }
        }
        
        if nextButtonActive {
            switch currentView {
            case createUsername:
                User.username = createUsername.username
                transitionBackwards(view: createUsername)
                transitionToCenter(view: addEmail)
                updateProgressImage(2)
                nextButtonActive = addEmail.nextButtonActive
                createUsername.userTextField.resignFirstResponder()
                addEmail.emailTextField.becomeFirstResponder()
            case addEmail:
                User.email = addEmail.emailTextField.text!
                transitionBackwards(view: addEmail)
                transitionToCenter(view: createPassword)
                updateProgressImage(3)
                nextButtonActive = createPassword.nextButtonActive
                addEmail.emailTextField.resignFirstResponder()
                createPassword.passwordTextField.becomeFirstResponder()
            case createPassword:
                User.password = createPassword.password
                transitionBackwards(view: createPassword)
                transitionToCenter(view: addBirthDate)
                updateProgressImage(4)
                nextButtonActive = false
                createPassword.passwordTextField.resignFirstResponder()
                addBirthDate.dateTextField.becomeFirstResponder();
                datePicker.isHidden = false
                dateLabel.isHidden = false
            case addBirthDate:
                User.birthDate = datePicker.dateToStringMMMddYYY()
                navigateToAccountType()
                dateLabel.titleLabel?.text = nil
            default: return
            }
        }
    }
    
    func navigateToAccountType() {
        if let accountTypeController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "accountTypeController") as? AccountTypeVC {
            navigationController?.pushViewController(accountTypeController, animated: true)
        }
    }
    
    @IBAction func backButtonPress() {
        switch currentView {
        case createUsername:
            createUsername.userTextField.resignFirstResponder();
            navigationController?.popViewController(animated: true)
        case addEmail:
            transitionForward(view: addEmail)
            transitionToCenter(view: createUsername)
            updateProgressImage(1)
            currentView = createUsername
            self.nextButtonActive = createUsername.nextButtonActive
            addEmail.emailTextField.resignFirstResponder()
            createUsername.userTextField.becomeFirstResponder()
        case createPassword:
            transitionForward(view: createPassword)
            transitionToCenter(view: addEmail)
            updateProgressImage(2)
            currentView = addEmail
            self.nextButtonActive = addEmail.nextButtonActive
            createPassword.passwordTextField.resignFirstResponder()
            addEmail.emailTextField.becomeFirstResponder()
        case addBirthDate:
            transitionForward(view: addBirthDate)
            transitionToCenter(view: createPassword)
            updateProgressImage(3)
            currentView = createPassword
            datePicker.isHidden = true
            dateLabel.isHidden = true
        default: return
        }
    }
    
    func updateProgressImage(_ imageNumber: Int) {
        if UIDevice.current.deviceType == .iPhoneSE {
//            switch imageNumber {
//            case 1:
//                progressBarSE.image = #imageLiteral(resourceName: "signup-step-one")
//            case 2:
//                progressBarSE.image = #imageLiteral(resourceName: "signup-step-two")
//            case 3:
//                progressBarSE.image = #imageLiteral(resourceName: "signup-step-three")
//            case 4:
//                progressBarSE.image = #imageLiteral(resourceName: "signup-step-four")
//            default:
//                progressBarSE.isHidden = true
//            }
        } else {
            switch imageNumber {
            case 1:
                progressBar.image = #imageLiteral(resourceName: "signup-step-one")
            case 2:
                progressBar.image = #imageLiteral(resourceName: "signup-step-two")
            case 3:
                progressBar.image = #imageLiteral(resourceName: "signup-step-three")
            case 4:
                progressBar.image = #imageLiteral(resourceName: "signup-step-four")
            default:
                progressBar.isHidden = true
            }
        }
    }
    
    @objc func updateDateLabel() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM dd, yyyy"
        let date = dateFormatter.string(from: datePicker.date)
        dateLabel.setTitle(date, for: .normal)
    }
}

extension CreateUserVC: NextButtonDelegate {
    
    func makeNextButton(active: Bool) {
        nextButtonActive = active
    }
    
    func keyboatrdNextButtonPress() {
        nextButtonPress()
    }
    
}
