//
//  ProfileImageVC.swift
//  Dune
//
//  Created by Waylan Sands on 28/7/20.
//  Copyright © 2020 Waylan Sands. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseFirestore

class ProfileImageVC: UIViewController {
    
    @IBOutlet weak var headingLabel: UILabel!
    @IBOutlet weak var uploadImageButton: UIButton!
    @IBOutlet weak var addLaterButton: UIButton!
    @IBOutlet weak var headingLabelTopAnchor: NSLayoutConstraint!
    @IBOutlet weak var addLaterBottomAnchor: NSLayoutConstraint!
    @IBOutlet weak var continueButtonBottomAnchor: NSLayoutConstraint!
    @IBOutlet var profileImages: [UIImageView]!
    
    var accountType: String?
    let db = Firestore.firestore()
    let skipAddingImageAlert = CustomAlertView(alertType: .skipAddingListenerImage)
    
    let customNavBar: CustomNavBar = {
        let navBar = CustomNavBar()
        navBar.titleLabel.text = ""
        navBar.rightButton.isHidden = true
        navBar.leftButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: -10, bottom: 0, right: 0)
        navBar.leftButton.addTarget(self, action: #selector(backButtonPress), for: .touchUpInside)
        return navBar
    }()
    
    override func viewWillAppear(_ animated: Bool) {
        self.uploadImageButton.setTitle("Upload image", for: .normal)
        self.uploadImageButton.isEnabled = true
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
      return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        styleForScreens()
        addRoundedCorners()
        CustomStyle.styleRoundedSignUpButton(color: CustomStyle.primaryBlue, image: nil, button: uploadImageButton)
        view.addSubview(customNavBar)
        customNavBar.pinNavBarTo(view)
        skipAddingImageAlert.alertDelegate = self
    }
    
    func addRoundedCorners() {
        for eachImage in profileImages {
            eachImage.layer.cornerRadius = eachImage.frame.width / 2
            eachImage.clipsToBounds = true
        }
    }
    
    func styleForScreens() {
        switch UIDevice.current.deviceType {
        case .iPhone4S:
            break
        case .iPhoneSE:
            headingLabel.font = UIFont.systemFont(ofSize: 26, weight: .bold)
            headingLabelTopAnchor.constant = 40.0
            addLaterBottomAnchor.constant = 20.0
        case .iPhone8:
            headingLabelTopAnchor.constant = 70.0
            addLaterBottomAnchor.constant = 20.0
        case .iPhone8Plus:
            break
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
    
    @IBAction func addLaterButtonPress(_ sender: UIButton) {
        view.addSubview(self.skipAddingImageAlert)
    }
    
    @objc func backButtonPress() {
        navigationController?.popViewController(animated: true)
    }
    
    func presentNextVC() {
        let listenerBioVC = ListenerAddBioVC()
        navigationController?.pushViewController(listenerBioVC, animated: true)
//        if let interestsVC = UIStoryboard(name: "OnboardingPublisher", bundle: nil).instantiateViewController(withIdentifier: "interestsVC") as? InterestsVC {
//            navigationController?.pushViewController(interestsVC, animated: true)
//        }
    }
}

extension ProfileImageVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBAction func uploadImageButtonPress() {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        present(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        var selectedImageFromPicker: UIImage?
        
        if let editedImage = info[.editedImage] as? UIImage {
            selectedImageFromPicker = editedImage
        } else if let originalImage = info[.originalImage] as? UIImage {
            selectedImageFromPicker = originalImage
        }
        
        if let selectedImage = selectedImageFromPicker {
            CurrentProgram.image = selectedImage
            FileManager.storeInitialProgramImage(image: selectedImage, programID: CurrentProgram.ID!)
            
            dismiss(animated: true, completion: nil)
            self.presentNextVC()
        }
    }
}

extension ProfileImageVC: CustomAlertDelegate {
    
    func primaryButtonPress() {
        presentNextVC()
    }
    
    func cancelButtonPress() {
        //
    }
}
