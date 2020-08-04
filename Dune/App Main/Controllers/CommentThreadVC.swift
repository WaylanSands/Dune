//
//  CommentThreadVC.swift
//  Dune
//
//  Created by Waylan Sands on 30/5/20.
//  Copyright © 2020 Waylan Sands. All rights reserved.
//

import UIKit

class CommentThreadVC: UIViewController {
    
    var episode: Episode
    var keyboardUp = false
    var primarySubCount = 0
    var attributedCharCount = 0
    var replyIsAttributed = false
    var tableView = UITableView()
    var isModallyPresented = false
    var keyboardRectHeight: CGFloat = 0
    var downloadedComments = [Comment]()
    var homeIndicatorHeight:CGFloat = 34.0
    var tableViewBottomConstraint: NSLayoutConstraint!    
    
    lazy var passThoughView = PassThoughView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height))
    var commentTextView = CommentTextView()
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    let publisherNotSetUpAlert = CustomAlertView(alertType: .publisherNotSetUp)
    let listenerNotSetUpAlert = CustomAlertView(alertType: .listenerNotSetUp)

    let customNavBar: CustomNavBar = {
        let nav = CustomNavBar()
        nav.leftButton.isHidden = true
        nav.backgroundColor = CustomStyle.blackNavBar
        nav.titleLabel.text = "Comments"
        nav.titleLabel.textColor = .white
        return nav
    }()

    required init(episode: Episode) {
        self.episode = episode
        super.init(nibName: nil, bundle: nil)
    }
    
    override func viewDidLoad() {
        configureKeyboardTracking()
        configureDelegates()
        styleForScreens()
        addInitialCell()
        configureViews()
        fetchComments()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        configureNavigation()
        checkIfModallyPresented()
    }
    
    func styleForScreens() {
        switch UIDevice.current.deviceType {
        case .iPhoneSE, .iPhone8Plus, .iPhone8, .iPhone4S:
            homeIndicatorHeight = 0
        default:
            break
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        isModallyPresented = false
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
    }
    
    func checkIfModallyPresented() {
        if isModallyPresented {
            customNavBar.isHidden = true
            tableView.contentInset = UIEdgeInsets(top: 40, left: 0, bottom: 0, right: 0)
        }
    }
    
    func configureDelegates() {
        tableView.register(PrimaryCommentCell.self, forCellReuseIdentifier: "primaryCommentCell")
        tableView.register(SubCommentCell.self, forCellReuseIdentifier: "subCommentCell")
        tableView.register(CommentCell.self, forCellReuseIdentifier: "commentCell")
        commentTextView.commentView.delegate = self
        commentTextView.commentDelegate = self
        publisherNotSetUpAlert.alertDelegate = self
        listenerNotSetUpAlert.alertDelegate = self
        tableView.dataSource = self
        tableView.delegate = self
    }
    
   func configureNavigation() {
    navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
    navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
    navigationController?.navigationBar.backIndicatorTransitionMaskImage = #imageLiteral(resourceName: "back-button-white")
    navigationController?.navigationBar.prefersLargeTitles = false
    navigationController?.navigationBar.backIndicatorImage = #imageLiteral(resourceName: "back-button-white")
    navigationController?.navigationBar.isTranslucent = true
    navigationController?.navigationBar.shadowImage = nil
    navigationController?.navigationBar.barStyle = .black
    navigationController?.navigationBar.shadowImage = UIImage()
    navigationController?.navigationBar.tintColor = .white
    navigationController?.navigationBar.isHidden = false
    navigationItem.largeTitleDisplayMode = .never
    }
    
    func configureViews() {
        view.backgroundColor = CustomStyle.onBoardingBlack
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        tableViewBottomConstraint = tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -homeIndicatorHeight)
        tableViewBottomConstraint.isActive = true
        tableView.separatorStyle = .none
        
        view.addSubview(passThoughView)
        passThoughView.addSubview(commentTextView)
        commentTextView.translatesAutoresizingMaskIntoConstraints = false
        commentTextView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        commentTextView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        commentTextView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -homeIndicatorHeight).isActive = true
        commentTextView.heightAnchor.constraint(greaterThanOrEqualToConstant: 48).isActive = true
        commentTextView.episodeID = episode.ID
        
        view.addSubview(customNavBar)
        customNavBar.pinNavBarTo(view)
    }
    
    func configureKeyboardTracking() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange(notification:)), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
    }
    
    func resetTableView() {
        downloadedComments = [Comment]()
        addInitialCell()
    }
    
    func addInitialCell() {
        downloadedComments.append(Comment(episode: episode))
    }
    
    func fetchComments() {
        FireBaseComments.fetchCommentsOrderedByVotesFrom(ID: episode.ID) { (comments) in
            if comments != nil && comments?.count != 0 {
                self.downloadedComments += comments!
                self.tableView.reloadData()
            } else if comments?.count == 0 {
             print("No comments")
            }
        }
    }
    
    @objc func keyboardWillChange(notification : Notification) {
        guard let keyboardRect = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else {
            return
        }
        keyboardRectHeight = keyboardRect.height
        commentTextView.frame.origin.y = view.frame.height - keyboardRect.height - commentTextView.commentView.frame.height - 14
        if !keyboardUp {
          animateTableView()
        }
    }
    
    func animateTableView() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.tableViewBottomConstraint.constant = -(self.keyboardRectHeight + self.commentTextView.commentView.frame.height - 30)
        }
    }
}

extension CommentThreadVC: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return downloadedComments.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var commentCell: CommentCell
        print(" \(downloadedComments.count) : \(indexPath.row)")
        let comment = downloadedComments[indexPath.row]
        
        if comment.subCommentCount > 0 && !comment.isUnwrapped {
            commentCell = tableView.dequeueReusableCell(withIdentifier: "primaryCommentCell") as! PrimaryCommentCell
        } else if comment.subCommentCount > 0 && comment.isUnwrapped {
            commentCell = tableView.dequeueReusableCell(withIdentifier: "commentCell") as! CommentCell
        } else if comment.isSubComment {
            commentCell = tableView.dequeueReusableCell(withIdentifier: "subCommentCell") as! SubCommentCell
        } else{
            commentCell = tableView.dequeueReusableCell(withIdentifier: "commentCell") as! CommentCell
        }
        
        commentCell.replyCountButton.addTarget(commentCell, action: #selector(PrimaryCommentCell.viewRepliesPress), for: .touchUpInside)
        commentCell.profileImageButton.addTarget(commentCell, action: #selector(CommentCell.visitCommenter), for: .touchUpInside)
        commentCell.usernameButton.addTarget(commentCell, action: #selector(CommentCell.visitCommenter), for: .touchUpInside)
        commentCell.voteDownButton.addTarget(commentCell, action: #selector(CommentCell.voteDownPress), for: .touchUpInside)
        commentCell.voteUpButton.addTarget(commentCell, action: #selector(CommentCell.voteUpPress), for: .touchUpInside)
        commentCell.replyButton.addTarget(commentCell, action: #selector(CommentCell.replyPress), for: .touchUpInside)
        commentCell.normalSetUp(comment: comment)
        commentCell.cellDelegate = self
        return commentCell
    }
    
      func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
          
            if editingStyle == .delete {
//              tableView.deleteRows(at: [indexPath], with: .fade)
          } else if editingStyle == .insert {
          }
        
      }
      
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let comment = self.downloadedComments[indexPath.row]
        let deleteItem = UIContextualAction(style: .destructive, title: "Delete") {  (contextualAction, view, completionBool) in
            let comment = self.downloadedComments[indexPath.row]
            if comment.isSubComment {
                FireBaseComments.deleteSubCommentForEpisode(ID: comment.episodeID, primaryID: comment.primaryID!, commentID: comment.ID)
                guard var primaryComment = self.downloadedComments.first(where: { $0.ID == comment.primaryID }) else { return }
                primaryComment.subCommentCount -= 1
                guard let primaryIndex = self.downloadedComments.firstIndex(where: {$0.ID == comment.primaryID}) else { return }
                self.downloadedComments[primaryIndex] = primaryComment
            } else if comment.subCommentCount > 0 {
                  FireBaseComments.deleteSubCommentsForEpisode(ID: comment.episodeID, commentID: comment.ID)
                  FireBaseComments.deleteCommentForEpisode(ID: comment.episodeID, commentID: comment.ID)
            } else {
                 FireBaseComments.deleteCommentForEpisode(ID: comment.episodeID, commentID: comment.ID)
            }
            
            if self.downloadedComments.count == 0 {
                print("No comments to display")
            }
            
            self.downloadedComments.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            
        }
        deleteItem.backgroundColor = CustomStyle.primaryBlack
        
        let alertItem = UIContextualAction(style: .normal, title: "Report") {  (contextualAction, view, completionBool) in
        }
        
        alertItem.backgroundColor = CustomStyle.thirdShade
        
        if comment.username == User.username {
            return UISwipeActionsConfiguration(actions: [deleteItem])
        } else {
            return UISwipeActionsConfiguration(actions: [alertItem])
        }
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
       return commentTextView.commentView.frame.height + homeIndicatorHeight
    }

    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = .clear
        view.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: (commentTextView.commentView.frame.height + homeIndicatorHeight))
        return view
    }
    
}

extension CommentThreadVC: UITextViewDelegate {
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        commentTextView.placeholderLabel.isHidden = true
        keyboardUp = true
    }
    
    func textViewDidChange(_ textView: UITextView) {
        
//        if !User.isPublisher! || CurrentProgram.imagePath == nil {
//            UIApplication.shared.windows.last?.addSubview(nonPublisherAlert)
//            textView.text = ""
//        }
        
        if !User.isSetUp! {
            UIApplication.shared.windows.last?.addSubview(publisherNotSetUpAlert)
            textView.text = ""
        }
        
        var textViewHeight: CGFloat
        let intrinsicHeight = commentTextView.commentView.intrinsicContentSize.height
        if intrinsicHeight > 34 {
            textViewHeight = intrinsicHeight
        } else {
            textViewHeight = 34
        }
        commentTextView.commentView.frame.size = CGSize(width: commentTextView.commentView.frame.width , height: textViewHeight)
        commentTextView.frame.size = CGSize(width: commentTextView.backgroundView.frame.width , height: commentTextView.backgroundView.frame.height)
        commentTextView.frame.origin.y = view.frame.height - keyboardRectHeight - commentTextView.commentView.frame.height - 14
        tableViewBottomConstraint.constant = -(keyboardRectHeight + commentTextView.commentView.frame.height - 30)
        
        if textView.text.isEmpty {
            commentTextView.placeholderLabel.isHidden = false
            commentTextView.postButton.setTitleColor(CustomStyle.fourthShade, for: .normal)
        } else {
            commentTextView.placeholderLabel.isHidden = true
            commentTextView.postButton.setTitleColor(CustomStyle.linkBlue, for: .normal)
        }
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        
        let  char = text.cString(using: String.Encoding.utf8)!
        let isBackSpace = strcmp(char, "\\b")
        
        if (isBackSpace == -92) {
            if replyIsAttributed && textView.text.count < attributedCharCount {
                textView.text = textView.attributedText.string
                textView.textColor = CustomStyle.primaryBlack
                replyIsAttributed = false
                attributedCharCount = 0
            }
        }
        return true
    }
    
}

extension CommentThreadVC: CommentCellDelegate {
  
    func visitProfile(program: Program) {
        if CurrentProgram.programsIDs().contains(program.ID) {
            let tabBar = MainTabController()
            tabBar.selectedIndex = 4
            if #available(iOS 13.0, *) {
                let sceneDelegate = UIApplication.shared.connectedScenes.first!.delegate as! SceneDelegate
                sceneDelegate.window?.rootViewController = tabBar
            } else {
                let appDelegate = UIApplication.shared.delegate as! AppDelegate
                appDelegate.window?.rootViewController = tabBar
            }
        } else if program.isPublisher {
            if program.isPrimaryProgram && !program.programIDs!.isEmpty  {
                let programVC = ProgramProfileVC()
                programVC.program = program
                navigationController?.pushViewController(programVC, animated: true)
            } else {
                let programVC = SingleProgramProfileVC(program: program)
                navigationController?.pushViewController(programVC, animated: true)
            }
        } else {
            let programVC = ListenerProfileVC(program: program)
            navigationController?.pushViewController(programVC, animated: true)
        }
    }
   
    func fetchSubCommentsFor(comment: Comment) {
        guard let commentIndex = downloadedComments.firstIndex(where: {$0.ID == comment.ID}) else { return }
       
        var replacement = comment
        replacement.isUnwrapped = true
        
        downloadedComments[commentIndex] = replacement
        
        FireBaseComments.fetchSubCommentsOrderedByVotesFrom(episodeID: comment.episodeID, commentID: comment.ID) { comments in
            if comments == nil {
                print("Error obtaining the sub-comments")
            } else {
                self.downloadedComments.insert(contentsOf: comments!, at: commentIndex + 1)
                self.tableView.reloadData()
            }
        }
    }
    
    func updateCommentTextFieldWithReply(comment: Comment) {
        commentTextView.commentView.attributedText = attributedReplyText(comment: comment)
        commentTextView.commentView.becomeFirstResponder()
        commentTextView.placeholderLabel.isHidden = true
        commentTextView.placeholderIsActive = false
         commentTextView.isReply = true
        if comment.isSubComment {
            commentTextView.commentID = comment.primaryID
        } else {
            commentTextView.commentID = comment.ID
        }
    }
    
    func attributedReplyText(comment: Comment) -> NSMutableAttributedString {
        replyIsAttributed = true
        attributedCharCount = comment.username.count + 2
        let mutableAttributedString = NSMutableAttributedString()
        
        let attributedDisplayName = NSAttributedString(string: "@\(comment.username)", attributes: [
            .foregroundColor :CustomStyle.linkBlue,
            .font: UIFont.systemFont(ofSize: 15, weight: .regular)
        ])
                
        let attributedComment = NSAttributedString(string: " ", attributes: [
            .foregroundColor :CustomStyle.primaryBlack,
            .font: UIFont.systemFont(ofSize: 15, weight: .regular)
        ])
        
        mutableAttributedString.append(attributedDisplayName)
        mutableAttributedString.append(attributedComment)
        
        return mutableAttributedString
    }
    
    func updateTableView() {
        tableView.reloadData()
    }
 
}

extension CommentThreadVC: commentTextViewDelegate {
   
    func append(comment: Comment, primaryID: String?) {
        DispatchQueue.main.async {
            self.commentTextView.commentView.resignFirstResponder()
            self.commentTextView.frame.size = CGSize(width: self.commentTextView.backgroundView.frame.width , height: 48)
            self.commentTextView.frame.origin.y = self.view.frame.height - (self.commentTextView.frame.height + self.homeIndicatorHeight)
            self.tableViewBottomConstraint.constant = -self.homeIndicatorHeight
            self.keyboardUp = false
        }
        
        if comment.isSubComment {
            guard let commentIndex = downloadedComments.firstIndex(where: { $0.ID == primaryID }) else { return }
            guard var primaryComment = downloadedComments.first(where: { $0.ID == primaryID }) else { return }
            let subCommentCount = primaryComment.subCommentCount
            let index = commentIndex + subCommentCount
            primaryComment.subCommentCount += 1
            replyIsAttributed = false
            attributedCharCount = 0
            downloadedComments[commentIndex] = primaryComment
            if primaryComment.isUnwrapped {
                print("unwrapped")
                downloadedComments.insert(comment, at: index + 1)
                tableView.reloadData()
            } else {
                tableView.reloadData()
            }
        } else {
            downloadedComments.append(comment)
            tableView.reloadData()
        }
    }
    
    func reloadTableView() {
        resetTableView()
        fetchComments()
    }
    
    func dismissKeyBoard() {
        DispatchQueue.main.async {
            print("dismissKeyBoard")
            self.keyboardUp = false
            self.commentTextView.frame.size = CGSize(width: self.commentTextView.backgroundView.frame.width , height: self.commentTextView.backgroundView.frame.height)
            self.commentTextView.frame.origin.y = self.view.frame.height - (self.commentTextView.frame.height + self.homeIndicatorHeight)
            self.tableViewBottomConstraint.constant =  -self.homeIndicatorHeight
        }
        if commentTextView.commentView.text.isEmpty {
            commentTextView.placeholderLabel.isHidden = false
            commentTextView.postButton.setTitleColor(CustomStyle.fourthShade, for: .normal)
        } else {
            commentTextView.placeholderLabel.isHidden = true
            commentTextView.postButton.setTitleColor(CustomStyle.linkBlue, for: .normal)
        }
    }
 
}

extension CommentThreadVC: CustomAlertDelegate {
   
    func primaryButtonPress() {
        if CurrentProgram.isPublisher! {
            let editProgramVC = EditProgramVC()
            editProgramVC.hidesBottomBarWhenPushed = true
            navigationController?.pushViewController(editProgramVC, animated: true)
        } else {
            let editListenerVC = EditListenerVC()
            editListenerVC.hidesBottomBarWhenPushed = true
            navigationController?.pushViewController(editListenerVC, animated: true)
        }
    }
    
    func cancelButtonPress() {
        //
    }
    
    
}


