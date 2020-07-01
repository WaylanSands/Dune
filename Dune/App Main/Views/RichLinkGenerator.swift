//
//  RichLinkView.swift
//  Dune
//
//  Created by Waylan Sands on 15/5/20.
//  Copyright © 2020 Waylan Sands. All rights reserved.
//

import UIKit
import SwiftLinkPreview

class RichLinkGenerator {
    
    var url: URL?
    var finalUrl: URL?
    var canonicalUrl: String?
    var mainTitle: String?
    var subHeading: String? // description
    var images: [String]?
    var imageLink: String?
    var largeImage: UIImage?
    var squareImage: UIImage?
    var icon: String?
    var video: String?
    var price: String?
    
    let imageNotSupportedAlert = CustomAlertView(alertType: .imageNotSupported)
    
    let slimView: UIView = {
        let view = UIView()
        view.backgroundColor = CustomStyle.secondShade
        return view
    }()
    
    let imageButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = CustomStyle.seventhShade
        button.imageView!.contentMode = .scaleAspectFill
        return button
    }()
    
    let linkBackgroundView: UIButton = {
        let button = UIButton()
        button.backgroundColor = CustomStyle.secondShade
        return button
    }()
    
    let slimImageView: UIView = {
        let view = UIView()
        view.backgroundColor = CustomStyle.secondShade
        return view
    }()
    
    let mainLabel: UILabel = {
        let label = UILabel()
        label.textColor = CustomStyle.primaryBlack
        label.font = UIFont.systemFont(ofSize: 14, weight: .bold)
        return label
    }()
    
    let squareLabel: UILabel = {
        let label = UILabel()
        label.textColor = CustomStyle.primaryBlack
        label.font = UIFont.systemFont(ofSize: 14, weight: .bold)
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 2
        return label
    }()
    
    let urlLabel: UILabel = {
        let label = UILabel()
        label.textColor = CustomStyle.fourthShade
        label.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        return label
    }()
    
    let subHeadingLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    
    // set for video
    let videoView: UIImageView = {
        let view = UIImageView()
        return view
    }()
    
    required init(response: Response) {
        self.url = response.url
        self.finalUrl = response.finalUrl
        self.canonicalUrl = response.canonicalUrl
        self.mainTitle = response.title
        self.subHeading = response.description
        self.images = response.images
        self.imageLink = response.image
        self.icon = response.icon
        self.video = response.video
        self.price = response.price
        
        if canonicalUrl != nil {
            self.urlLabel.text = canonicalUrl
        }
        
        if mainTitle != nil {
            self.mainLabel.text = mainTitle
            self.squareLabel.text = mainTitle

        }
    }
    
    func linkIsRich() -> Bool {
        if canonicalUrl != nil && mainTitle != nil && subHeading != nil && imageLink != nil {
            return true
        } else {
            return false
        }
    }
    
    func addRichLinkTo(stackedView: UIStackView) {
        isImageLarge { (result) in
            if result == true {
                DispatchQueue.main.async {
                    let button = self.configureRegularImageView()
                    self.addRegularButtonTo(stackedView: stackedView, button: button)
                }
            } else {
                DispatchQueue.main.async {
                    let button = self.configureSquareImageView()
                    self.addSquareButtonTo(stackedView: stackedView, button: button)
                }
            }
        }
    }
    
    func isImageLarge(completion: @escaping (Bool) -> ()) {
        self.setImageTwo(from: self.imageLink!) { image in
            if image != nil {
                let width = image!.size.width
                if width <= CGFloat(200) {
                    if self.icon != nil {
                        self.setImage(from: self.icon!) { image in
                            self.squareImage = image
                            completion(false)
                        }
                    } else {
                        self.setImage(from: self.imageLink!) { image in
                            self.squareImage = image
                            completion(false)
                        }
                    }
                } else {
                    self.largeImage = image
                    completion(true)
                }
            } else {
                DispatchQueue.main.async {
                    UIApplication.shared.windows.last?.addSubview(self.imageNotSupportedAlert)
                }
                return
            }
        }
    }
    
    func checkIfImageIsLarge(completion: @escaping (Bool) -> ()) {
        self.setImage(from: self.imageLink!) { image in
            if image != nil {
                let width = image!.size.width
                if width <= CGFloat(200) {
                    completion(false)
                } else {
                    self.largeImage = image
                    completion(true)
                }
            } else {
                completion(false)
            }
        }
    }

    
    
    func configureRegularImageView() -> UIView {
        
        let view = UIView()
        view.addSubview(imageButton)
        imageButton.translatesAutoresizingMaskIntoConstraints = false
        imageButton.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        imageButton.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        imageButton.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        imageButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -50).isActive = true
        
        view.addSubview(linkBackgroundView)
        linkBackgroundView.translatesAutoresizingMaskIntoConstraints = false
        linkBackgroundView.topAnchor.constraint(equalTo: imageButton.bottomAnchor).isActive = true
        linkBackgroundView.leadingAnchor.constraint(equalTo: imageButton.leadingAnchor).isActive = true
        linkBackgroundView.trailingAnchor.constraint(equalTo: imageButton.trailingAnchor).isActive = true
        linkBackgroundView.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        view.addSubview(mainLabel)
        mainLabel.translatesAutoresizingMaskIntoConstraints = false
        mainLabel.topAnchor.constraint(equalTo: linkBackgroundView.topAnchor, constant: 7).isActive = true
        mainLabel.leadingAnchor.constraint(equalTo: imageButton.leadingAnchor, constant: 15).isActive = true
        mainLabel.trailingAnchor.constraint(equalTo: imageButton.trailingAnchor, constant: -15).isActive = true
        
        view.addSubview(urlLabel)
        urlLabel.translatesAutoresizingMaskIntoConstraints = false
        urlLabel.topAnchor.constraint(equalTo: mainLabel.bottomAnchor, constant: 2).isActive = true
        urlLabel.leadingAnchor.constraint(equalTo: mainLabel.leadingAnchor).isActive = true
        urlLabel.trailingAnchor.constraint(equalTo: mainLabel.trailingAnchor).isActive = true
        
        self.imageButton.setImage(largeImage, for: .normal)
        
        return view
    }
    
    func configureSquareImageView() -> UIView {
        
        let view = UIView()
        view.addSubview(linkBackgroundView)
        linkBackgroundView.translatesAutoresizingMaskIntoConstraints = false
        linkBackgroundView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        linkBackgroundView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        linkBackgroundView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        linkBackgroundView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        
        view.addSubview(imageButton)
        imageButton.translatesAutoresizingMaskIntoConstraints = false
        imageButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 7).isActive = true
        imageButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10).isActive = true
        imageButton.heightAnchor.constraint(equalToConstant: 60).isActive = true
        imageButton.widthAnchor.constraint(equalToConstant: 60).isActive = true
        
        view.addSubview(squareLabel)
        squareLabel.translatesAutoresizingMaskIntoConstraints = false
        squareLabel.topAnchor.constraint(equalTo: linkBackgroundView.topAnchor, constant: 10).isActive = true
        squareLabel.leadingAnchor.constraint(equalTo: imageButton.trailingAnchor, constant: 15).isActive = true
        squareLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -15).isActive = true
        
        view.addSubview(urlLabel)
        urlLabel.translatesAutoresizingMaskIntoConstraints = false
        urlLabel.topAnchor.constraint(equalTo: squareLabel.bottomAnchor, constant: 2).isActive = true
        urlLabel.leadingAnchor.constraint(equalTo: squareLabel.leadingAnchor).isActive = true
        urlLabel.trailingAnchor.constraint(equalTo: squareLabel.trailingAnchor).isActive = true
        
        self.imageButton.setImage(squareImage, for: .normal)
        
        return view
    }
    
    func addRegularButtonTo(stackedView: UIStackView, button: UIView) {
        stackedView.addArrangedSubview(button)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.topAnchor.constraint(equalTo: stackedView.topAnchor).isActive = true
        button.leadingAnchor.constraint(equalTo: stackedView.leadingAnchor).isActive = true
        button.trailingAnchor.constraint(equalTo: stackedView.trailingAnchor).isActive = true
        button.heightAnchor.constraint(equalToConstant: 200).isActive = true
        
        imageButton.layer.cornerRadius = 8
        imageButton.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        imageButton.clipsToBounds = true
        linkBackgroundView.layer.cornerRadius = 8
        linkBackgroundView.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        linkBackgroundView.clipsToBounds = true
    }
    
    func addSquareButtonTo(stackedView: UIStackView, button: UIView) {
        stackedView.addArrangedSubview(button)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.topAnchor.constraint(equalTo: stackedView.topAnchor).isActive = true
        button.leadingAnchor.constraint(equalTo: stackedView.leadingAnchor).isActive = true
        button.trailingAnchor.constraint(equalTo: stackedView.trailingAnchor).isActive = true
        button.heightAnchor.constraint(equalToConstant: 74).isActive = true
        
        imageButton.layer.cornerRadius = 8
        imageButton.clipsToBounds = true
        linkBackgroundView.layer.cornerRadius = 8
        linkBackgroundView.clipsToBounds = true
    }
    
    
    func setImageTwo(from url: String, completion: @escaping (UIImage?) -> ()) {
        DispatchQueue.global(qos: .userInitiated).async {
            if let imageURL = URL(string: url), let imageData = try? Data(contentsOf: imageURL), let image = UIImage(data: imageData) {
                        completion(image)
                    
            } else {
                 completion(nil)
            }
        }
    }
    
    func setImage(from url: String, completion: @escaping (UIImage?) -> ()) {
        let urlArray = url.components(separatedBy: "/")
        let fileName = urlArray.last!
    
        let cacheURL = FileManager.getCacheDirectory()
        let fileURL = cacheURL.appendingPathComponent(fileName)
        
        DispatchQueue.global(qos: .userInitiated).async {
           
            if FileManager.default.fileExists(atPath: fileURL.path) {
                if let image = UIImage(contentsOfFile: fileURL.path) {
                      print("fileExists")
                    completion(image)
                } else {
                    print("Failed to turn file into an Image")
                }
            } else {
                
                if let imageURL = URL(string: url) {
                    if let imageData = try? Data(contentsOf: imageURL) {
                        if let image = UIImage(data: imageData) {
                            self.storeRichImageWith(fileName: fileName, image: image)
                            completion(image)
                        }
                    }
                } else {
                     completion(nil)
                }
            }
        }
    }
    
    func storeRichImageWith(fileName: String, image: UIImage) {

        if let data = image.jpegData(compressionQuality: 0.5) {
              let cacheURL = FileManager.getCacheDirectory()
              let fileURL = cacheURL.appendingPathComponent(fileName)

              do {
                try data.write(to: fileURL, options: .atomic)
                print("Storing image")
              }
              catch {
                print("Unable to Write Data to Disk (\(error.localizedDescription))")
              }
          }
      }

    
}
