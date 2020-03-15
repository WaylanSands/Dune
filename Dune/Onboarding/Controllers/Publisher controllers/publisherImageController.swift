//
//  publisherImageController.swift
//  Snippets
//
//  Created by Waylan Sands on 20/1/20.
//  Copyright © 2020 Waylan Sands. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseFirestore

class publisherImageVC: UIViewController {
    
    @IBOutlet weak var headingLabel: UILabel!
    @IBOutlet weak var uploadImageButton: UIButton!
    @IBOutlet weak var headingLabelTopAnchor: NSLayoutConstraint!
    @IBOutlet weak var addLaterBottomAnchor: NSLayoutConstraint!
    @IBOutlet weak var continueButtonBottomAnchor: NSLayoutConstraint!
    @IBOutlet var profileImages: [UIImageView]!
    
    var accountType: String?
    
    let customNavBar: CustomNavBar = {
        let navBar = CustomNavBar()
        navBar.titleLabel.text = ""
        navBar.rightButton.isHidden = true
        navBar.leftButton.addTarget(self, action: #selector(backButtonPress), for: .touchUpInside)
        return navBar
    }()
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.uploadImageButton.setTitle("Upload image", for: .normal)
        self.uploadImageButton.isEnabled = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        styleForScreens()
        addRoundedCorners()
        CustomStyle.styleRoundedSignUpButton(color: CustomStyle.primaryBlue, image: nil, button: uploadImageButton)
        view.addSubview(customNavBar)
        customNavBar.pinNavBarTo(view)
    }
    
    func addRoundedCorners() {
        for eachImage in profileImages {
            eachImage.layer.cornerRadius = 7
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
        case .iPhone11Pro:
            break
        case .iPhone11ProMax:
            break
        case .unknown:
            break
        }
    }
    
    @objc func backButtonPress() {
        navigationController?.popViewController(animated: true)
    }
    
    func presentNextVC() {
        if let categoriesController = UIStoryboard(name: "OnboardingPublisher", bundle: nil).instantiateViewController(withIdentifier: "categoriesController") as? publisherCategoriesVC {
            navigationController?.pushViewController(categoriesController, animated: true)
        }
    }
    
    func addImageLinksToChannel(path: String, url: String) {
        
        let db = Firestore.firestore()
        let channelRef = db.collection(publisherType.channel.rawValue).document(Channel.channelID!)
        
        channelRef.setData([
            "imagePath" : Channel.imagePath!,
            "downloadURL" : url
        ]) { (error) in
            if let error = error {
                print("There has been an error adding the imagePath to channel: \(error.localizedDescription)")
            } else {
                print("Successfully added imagPath to channel")
                self.presentNextVC()
            }
        }
    }
}

extension publisherImageVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBAction func uploadImageButtonPress() {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        present(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        let imagePath = NSUUID().uuidString
        Channel.imagePath = imagePath
        
        var selectedImageFromPicker: UIImage?
        
        if let editedImage = info[.editedImage] as? UIImage {
            selectedImageFromPicker = editedImage
        } else if let originalImage = info[.originalImage] as? UIImage {
            selectedImageFromPicker = originalImage
        }
        
        if let selectedImage = selectedImageFromPicker {
            
            let storageRef = Storage.storage().reference().child(Channel.imagePath!)
            
            if let uploadData = selectedImage.jpegData(compressionQuality: 0.5) {
                
                let uploadTask = storageRef.putData(uploadData, metadata: nil, completion: { (metadata, error) in
            
                    if let errorMessage = error {
                        print("There has was an error adding the image \(errorMessage)")
                        return
                    }
                    
                    if let imagePath = metadata?.path {
                        print("complete")
                        self.uploadImageButton.setTitle("Complete", for: .normal)
                        storageRef.downloadURL { (url, error) in
                          
                            if error != nil {
                                print("Error getting image url")
                            }
                            
                            if let url = url {
                                Channel.downloadURL = url.absoluteString
                                ImageCache.storeImage(urlString: url.absoluteString, Image: selectedImage)
                                self.addImageLinksToChannel(path: imagePath, url: Channel.downloadURL!)
                            }
                            
                            
                        }
                    }
                })
                
                uploadTask.observe(.progress) { snapshot in
                    self.uploadImageButton.setTitle("Uploading...", for: .normal)
                    self.uploadImageButton.isEnabled = false
                }
            }
            dismiss(animated: true, completion: nil)
        }
    }
}
