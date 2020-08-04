//
//  ListenerAddBioVC.swift
//  abseil
//
//  Created by Waylan Sands on 29/7/20.
//

import UIKit
import OneSignal
import FirebaseFirestore

class ListenerAddBioVC: UIViewController {
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    let maxCaptionCharacters = 240
    
    let summaryPlaceholder = "Include a short bio, what makes you unique?"
    
    var scrollContentHeightConstraint: NSLayoutConstraint!
    
    var homeIndicatorHeight:CGFloat = 34.0
    var summaryPlaceholderIsActive = true
    
    let db = Firestore.firestore()
    
    lazy var screenHeight = view.frame.height
        
    // For screen-size adjustment
    var imageViewSize:CGFloat = 55.0
    var floatingBarHeight:CGFloat = 65.0
    var imageBarViewSize:CGFloat = 45.0
    var scrollPadding: CGFloat = 0
        
    let customNavBar: CustomNavBar = {
        let navBar = CustomNavBar()
        navBar.titleLabel.text = "Biography"
        navBar.leftButton.addTarget(self, action: #selector(backButtonPress), for: .touchUpInside)
        return navBar
    }()
    
    let scrollView: UIScrollView = {
        let view = UIScrollView()
        view.isScrollEnabled = true
        view.contentInsetAdjustmentBehavior = .never
        return view
    }()
    
    let scrollContentView: UIView = {
        let view = UIView()
        return view
    }()
    
    let mainImage: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 7
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    let programNameStackedView: UIStackView = {
        let view = UIStackView()
        view.spacing = 5
        return view
    }()
    
    let programNameLabel: UILabel = {
        let label = UILabel()
        label.text = CurrentProgram.name
        label.font = UIFont.systemFont(ofSize: 14, weight: .bold)
        return label
    }()
    
    let usernameLabel: UILabel = {
        let label = UILabel()
        label.text = "@\(User.username!)"
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        label.textColor = CustomStyle.linkBlue
        return label
    }()
    
    let summaryLabel: UITextView = {
        let label = UITextView()
        label.text = ""
        label.textContainer.maximumNumberOfLines = 7
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        label.textColor = CustomStyle.white
        label.textContainerInset = .zero
        label.textContainer.lineFragmentPadding = 0
        label.isScrollEnabled = false
        label.isEditable = false
        return label
    }()
    
    let summaryBar: UIView = {
        let view = UIView()
        view.backgroundColor = CustomStyle.secondShade
        return view
    }()
    
    let summaryBarLabel: UILabel = {
        let label = UILabel()
        label.text = "Include a bio"
        label.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        label.textColor = CustomStyle.fifthShade
        return label
    }()
    
    lazy var summaryCounterLabel: UILabel = {
        let label = UILabel()
        label.text = String(maxCaptionCharacters)
        label.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        label.textColor = CustomStyle.fourthShade
        return label
    }()
    
    lazy var summaryTextView: UITextView = {
        let textView = UITextView()
        textView.text = summaryPlaceholder
        textView.font = UIFont.systemFont(ofSize: 15, weight: .regular)
        textView.textContainer.maximumNumberOfLines = 12
        textView.isUserInteractionEnabled = false
        textView.isScrollEnabled = false
        textView.textColor = CustomStyle.fourthShade
        textView.keyboardType = .twitter
        textView.textAlignment = .left
        return textView
    }()
    
    lazy var passThoughView = PassThoughView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height))
    
    let floatingDetailsView: UIView = {
        let view = UIView()
        view.backgroundColor = CustomStyle.primaryBlack
        return view
    }()
    
    let bottomBarImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 7
        imageView.clipsToBounds = true
        return imageView
    }()
    
    let bottomBarNameLabel: UILabel = {
        let label = UILabel()
        label.text = CurrentProgram.name
        label.font = UIFont.systemFont(ofSize: 14.0, weight: .bold)
        label.textColor = .white
        return label
    }()
    
    let bottomBarUsernameLabel: UILabel = {
        let label = UILabel()
        label.text = "@\(User.username!)"
        label.font = UIFont.systemFont(ofSize: 14.0, weight: .regular)
        label.textColor = .white
        return label
    }()
    
    let confirmButton: UIButton = {
        let button = UIButton()
        button.alpha = 0.2
        button.layer.borderWidth = 1
        button.layer.cornerRadius = 7.0
        button.setTitle("Confirm", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.layer.borderColor = CustomStyle.white.cgColor
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14.0, weight: .semibold)
        button.addTarget(self, action: #selector(confirmButtonPress), for: .touchUpInside)
        button.contentEdgeInsets = UIEdgeInsets(top: 0, left: 10.0, bottom: 0, right: 10.0)
        button.isEnabled = false
        return button
    }()
    
    let bottomFill: UIView = {
        let view = UIView()
        view.backgroundColor = CustomStyle.primaryBlack
        return view
    }()
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
      return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        summaryTextView.delegate = self
        callBottomFill()
        setProgramImage()
        styleForScreens()
        setupViews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        addFloatingView()
        setupKeyboardObserver()
        if CurrentProgram.summary != nil && CurrentProgram.summary != "" {
            summaryPlaceholderIsActive = false
            summaryLabel.text = CurrentProgram.summary
            summaryTextView.text = CurrentProgram.summary
            summaryLabel.textColor =  CustomStyle.sixthShade
            summaryTextView.textColor = CustomStyle.fifthShade
        } else {
            let startPosition: UITextPosition = self.summaryTextView.beginningOfDocument
            self.summaryTextView.selectedTextRange = self.summaryTextView.textRange(from: startPosition, to: startPosition)
        }
        self.floatingDetailsView.frame.origin.y =  self.view.frame.height - ( self.floatingDetailsView.frame.height +  self.homeIndicatorHeight)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        summaryTextView.becomeFirstResponder()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        summaryTextView.resignFirstResponder()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
    }
    
    func styleForScreens() {
        switch UIDevice.current.deviceType {
        case .iPhone4S, .iPhoneSE:
            floatingBarHeight = 50.0
            imageBarViewSize = 36.0
            scrollPadding = 140
            imageViewSize = 50
        case .iPhone8:
            break
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
    
    func setupKeyboardObserver() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange(notification:)), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
    }
    
    func setProgramImage() {
        if CurrentProgram.image != nil {
            mainImage.image = CurrentProgram.image
            bottomBarImageView.image = CurrentProgram.image
        } else {
            mainImage.image = #imageLiteral(resourceName: "missing-image-large")
            bottomBarImageView.image = #imageLiteral(resourceName: "missing-image-large")
            CurrentProgram.image = #imageLiteral(resourceName: "missing-image-large")
        }
    }
    
    @objc func keyboardWillChange(notification : Notification) {
        guard let keyboardRect = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else {
            return
        }
        floatingDetailsView.frame.origin.y = view.frame.height - keyboardRect.height -  floatingDetailsView.frame.height
    }
    
    func configureNavBar() {
        self.title = "New Episode"
        navigationController?.isNavigationBarHidden = false
        
        let navBar = navigationController?.navigationBar
        navBar?.barStyle = .black
        navBar?.setBackgroundImage(UIImage(), for: .default)
        navBar?.shadowImage = UIImage()
        navBar?.titleTextAttributes = [.foregroundColor: UIColor.white]
        navBar?.tintColor = .white
        
        let imgBackArrow = #imageLiteral(resourceName: "back-button-white")
        navBar?.backIndicatorImage = imgBackArrow
        navBar?.backIndicatorTransitionMaskImage = imgBackArrow
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: .plain, target: self, action: nil)
        navigationItem.rightBarButtonItem!.setTitleTextAttributes(CustomStyle.barButtonAttributes, for: .normal)
    }
    
    func callBottomFill() {
        view.addSubview(bottomFill)
        view.sendSubviewToBack(bottomFill)
        bottomFill.translatesAutoresizingMaskIntoConstraints = false
        bottomFill.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        bottomFill.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        bottomFill.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        bottomFill.heightAnchor.constraint(equalToConstant: 70.0).isActive = true
    }
    
    func setupViews() {
        view.backgroundColor = .white
        
        view.addSubview(scrollView)
        scrollView.pinEdges(to: view)
        
        scrollView.addSubview(scrollContentView)
        scrollContentView.translatesAutoresizingMaskIntoConstraints = false
        scrollContentView.topAnchor.constraint(equalTo: scrollView.topAnchor).isActive = true
        scrollContentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor).isActive = true
        scrollContentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor).isActive = true
        scrollContentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor).isActive = true
        scrollContentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor).isActive = true
        scrollContentHeightConstraint = scrollContentView.heightAnchor.constraint(equalToConstant: screenHeight + scrollPadding)
        scrollContentHeightConstraint.isActive = true
        
        scrollContentView.addSubview(mainImage)
        mainImage.translatesAutoresizingMaskIntoConstraints = false
        mainImage.topAnchor.constraint(equalTo: scrollContentView.topAnchor, constant: UIDevice.current.navBarHeight() + 10).isActive = true
        mainImage.leadingAnchor.constraint(equalTo: scrollContentView.leadingAnchor, constant: 16).isActive = true
        mainImage.heightAnchor.constraint(equalToConstant: imageViewSize).isActive = true
        mainImage.widthAnchor.constraint(equalToConstant: imageViewSize).isActive = true
        
        scrollContentView.addSubview(programNameStackedView)
        programNameStackedView.translatesAutoresizingMaskIntoConstraints = false
        programNameStackedView.topAnchor.constraint(equalTo: mainImage.topAnchor).isActive = true
        programNameStackedView.leadingAnchor.constraint(equalTo: mainImage.trailingAnchor, constant: 10).isActive = true
        programNameStackedView.trailingAnchor.constraint(lessThanOrEqualTo: view.trailingAnchor, constant: 20).isActive = true
        
        programNameStackedView.addArrangedSubview(programNameLabel)
        programNameLabel.translatesAutoresizingMaskIntoConstraints = false
        programNameLabel.leadingAnchor.constraint(equalTo: programNameStackedView.leadingAnchor).isActive = true
        programNameLabel.widthAnchor.constraint(equalToConstant: programNameLabel.intrinsicContentSize.width).isActive = true
        
        programNameStackedView.addArrangedSubview(usernameLabel)
        usernameLabel.translatesAutoresizingMaskIntoConstraints = false
        usernameLabel.widthAnchor.constraint(equalToConstant: usernameLabel.intrinsicContentSize.width).isActive = true
        
        scrollContentView.addSubview(summaryLabel)
        summaryLabel.translatesAutoresizingMaskIntoConstraints = false
        summaryLabel.topAnchor.constraint(equalTo: programNameStackedView.bottomAnchor, constant: 2).isActive = true
        summaryLabel.leadingAnchor.constraint(equalTo: programNameStackedView.leadingAnchor).isActive = true
        summaryLabel.trailingAnchor.constraint(equalTo: scrollContentView.trailingAnchor, constant: -16.0).isActive = true
        summaryLabel.heightAnchor.constraint(greaterThanOrEqualToConstant: 60).isActive = true
        
        scrollContentView.addSubview(summaryBar)
        summaryBar.translatesAutoresizingMaskIntoConstraints = false
        summaryBar.topAnchor.constraint(equalTo: summaryLabel.bottomAnchor, constant: 40).isActive = true
        summaryBar.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        summaryBar.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        summaryBar.heightAnchor.constraint(equalToConstant: 37.0).isActive = true
        
        summaryBar.addSubview(summaryBarLabel)
        summaryBarLabel.translatesAutoresizingMaskIntoConstraints = false
        summaryBarLabel.centerYAnchor.constraint(equalTo: summaryBar.centerYAnchor).isActive = true
        summaryBarLabel.leadingAnchor.constraint(equalTo: summaryBar.leadingAnchor, constant: 16).isActive = true
        
        summaryBar.addSubview(summaryCounterLabel)
        summaryCounterLabel.translatesAutoresizingMaskIntoConstraints = false
        summaryCounterLabel.centerYAnchor.constraint(equalTo: summaryBar.centerYAnchor).isActive = true
        summaryCounterLabel.trailingAnchor.constraint(equalTo: summaryBar.trailingAnchor, constant: -16).isActive = true
        
        scrollContentView.addSubview(summaryTextView)
        summaryTextView.translatesAutoresizingMaskIntoConstraints = false
        summaryTextView.topAnchor.constraint(equalTo: summaryBarLabel.bottomAnchor, constant: 20).isActive = true
        summaryTextView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 13).isActive = true
        summaryTextView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -13).isActive = true
        summaryTextView.heightAnchor.constraint(greaterThanOrEqualToConstant: 60).isActive = true
        
        view.addSubview(customNavBar)
        customNavBar.pinNavBarTo(view)
    }
    
    func addFloatingView() {
        view.addSubview(passThoughView)
        
        passThoughView.addSubview(floatingDetailsView)
        floatingDetailsView.translatesAutoresizingMaskIntoConstraints = false
        floatingDetailsView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        floatingDetailsView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        floatingDetailsView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        floatingDetailsView.heightAnchor.constraint(equalToConstant: floatingBarHeight).isActive = true
        
        floatingDetailsView.addSubview(bottomBarImageView)
        bottomBarImageView.translatesAutoresizingMaskIntoConstraints = false
        bottomBarImageView.centerYAnchor.constraint(equalTo: floatingDetailsView.centerYAnchor).isActive = true
        bottomBarImageView.leadingAnchor.constraint(equalTo: floatingDetailsView.leadingAnchor, constant: 16.0).isActive = true
        bottomBarImageView.heightAnchor.constraint(equalToConstant: imageBarViewSize).isActive = true
        bottomBarImageView.widthAnchor.constraint(equalToConstant: imageBarViewSize).isActive = true
        
        floatingDetailsView.addSubview(bottomBarNameLabel)
        bottomBarNameLabel.translatesAutoresizingMaskIntoConstraints = false
        bottomBarNameLabel.topAnchor.constraint(equalTo: bottomBarImageView.topAnchor, constant: 1).isActive = true
        bottomBarNameLabel.leadingAnchor.constraint(equalTo: bottomBarImageView.trailingAnchor, constant: 10.0).isActive = true
//        bottomBarNameLabel.heightAnchor.constraint(equalToConstant: 20.0).isActive = true
        
        floatingDetailsView.addSubview(bottomBarUsernameLabel)
        bottomBarUsernameLabel.translatesAutoresizingMaskIntoConstraints = false
        bottomBarUsernameLabel.topAnchor.constraint(equalTo: bottomBarNameLabel.bottomAnchor).isActive = true
        bottomBarUsernameLabel.leadingAnchor.constraint(equalTo: bottomBarNameLabel.leadingAnchor).isActive = true
//        bottomBarUsernameLabel.heightAnchor.constraint(equalToConstant: 20.0).isActive = true
        
        floatingDetailsView.addSubview(confirmButton)
        confirmButton.translatesAutoresizingMaskIntoConstraints = false
        confirmButton.centerYAnchor.constraint(equalTo: floatingDetailsView.centerYAnchor).isActive = true
        confirmButton.trailingAnchor.constraint(equalTo: floatingDetailsView.trailingAnchor, constant: -16.0).isActive = true
        confirmButton.heightAnchor.constraint(equalToConstant: 32.0).isActive = true
    }

    
    func updateCharacterCount(textView: UITextView) {
        if !summaryPlaceholderIsActive {
            summaryCounterLabel.text =  String(maxCaptionCharacters - summaryTextView.text!.count)
        } else {
           summaryCounterLabel.text =  String(maxCaptionCharacters)
        }
        
        if Int(summaryCounterLabel.text!)! < 0 {
            summaryCounterLabel.font = UIFont.systemFont(ofSize: 12, weight: .bold)
            summaryCounterLabel.textColor = CustomStyle.warningRed
        } else {
            summaryCounterLabel.font = UIFont.systemFont(ofSize: 12, weight: .regular)
            summaryCounterLabel.textColor = CustomStyle.fourthShade
        }
    }

    
    func addCaptionPlaceholderText() {
        DispatchQueue.main.async {
            self.summaryTextView.text = self.summaryPlaceholder
            let startPosition: UITextPosition = self.summaryTextView.beginningOfDocument
            self.summaryTextView.selectedTextRange = self.summaryTextView.textRange(from: startPosition, to: startPosition)
            self.summaryTextView.textColor = CustomStyle.fourthShade
            self.summaryPlaceholderIsActive = true
            
            self.summaryLabel.text = ""
            self.summaryLabel.textColor = .white
            self.disablePublishButton()
        }
    }
    
    func enablePublishButton() {
        confirmButton.isEnabled = true
        confirmButton.alpha = 1
    }
    
    func disablePublishButton() {
        confirmButton.isEnabled = false
        confirmButton.alpha = 0.2
    }
    
    @objc func backButtonPress() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc func confirmButtonPress() {
        CurrentProgram.rep = 25
        CurrentProgram.tags = []
        CurrentProgram.summary = summaryLabel.text?.trimmingTrailingSpaces
        
        let programRef = db.collection("programs").document(CurrentProgram.ID!)
        let userRef = db.collection("users").document(User.ID!)
        FireStoreManager.updateProgramRep(programID: CurrentProgram.ID!, repMethod: "signup", rep: 25)
        
        if CurrentProgram.imageID != nil {
            User.isSetUp = true
        }
        
        DispatchQueue.global(qos: .userInitiated).async {
            OneSignal.sendTags([ "onboarded" : true ])
            programRef.updateData([
                "summary" : CurrentProgram.summary!,
                "isPublisher" : false,
                "tags" : []
            ]) { (error) in
                if let error = error {
                    print("Error adding bio: \(error.localizedDescription)")
                } else {
                    print("Successfully added bio")
                }
            }
            userRef.updateData([
                "completedOnBoarding" : true,
                "isSetUp" : User.isSetUp!
            ]) { error in
                if error != nil {
                    print("Error with updating on-boarding bool for user \(error!)")
                }
            }
        }
        presentSearchView()
    }

    func presentSearchView() {
        let tabBar = MainTabController()
        tabBar.selectedIndex = 3
        
        if User.recommendedProgram != nil {
            let searchNav = tabBar.selectedViewController as! UINavigationController
            let searchVC = searchNav.viewControllers[0] as! SearchVC
            searchVC.programToPush = User.recommendedProgram!
        }
        
        if #available(iOS 13.0, *) {
            let sceneDelegate = UIApplication.shared.connectedScenes.first!.delegate as! SceneDelegate
             sceneDelegate.window?.rootViewController = tabBar
        } else {
             appDelegate.window?.rootViewController = tabBar
        }
    }
    
    // Determine if ok to confirm
    func checkIfAbleToPublish() {
        if summaryPlaceholderIsActive == false && summaryTextView.text.count < maxCaptionCharacters {
            enablePublishButton()
        } else {
            disablePublishButton()
        }
    }
}

extension ListenerAddBioVC: UITextViewDelegate {
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView == summaryTextView {
            if summaryPlaceholderIsActive == true {
                addCaptionPlaceholderText()
            }
        }
    }
    
    func textViewDidChange(_ textView: UITextView) {
        updateCharacterCount(textView: textView)
        if textView == summaryTextView {
            if summaryTextView.text.isEmpty {
                addCaptionPlaceholderText()
                scrollContentHeightConstraint.constant = scrollView.frame.height + scrollPadding
            } else {
                scrollContentHeightConstraint.constant = scrollView.frame.height + summaryTextView.frame.height + scrollPadding
                summaryLabel.textColor = CustomStyle.sixthShade
                summaryLabel.text = summaryTextView.text
            }
        }
        checkIfAbleToPublish()
    }

    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
       
        if textView == summaryTextView {
            if summaryPlaceholderIsActive == true {
                summaryTextView.text.removeAll()
                self.summaryTextView.textColor = CustomStyle.fifthShade
                summaryPlaceholderIsActive = false
            } else {
                summaryLabel.textColor = CustomStyle.sixthShade
            }
        }
        return true
    }
}

