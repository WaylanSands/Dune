//
//  FireStore+Ext-Comments.swift
//  Dune
//
//  Created by Waylan Sands on 30/5/20.
//  Copyright © 2020 Waylan Sands. All rights reserved.
//

import FirebaseStorage
import FirebaseFirestore

struct FireBaseComments {
    
    static let db = Firestore.firestore()
    
    static func fetchCommentsOrderedByVotesFrom(ID: String, completion: @escaping ([Comment]?) -> ()) {
        DispatchQueue.global(qos: .userInitiated).async {
            
            var comments = [Comment]()
            let commentsRef = db.collection("episodes").document(ID).collection("comments").order(by: "voteCount", descending: true)
            
            commentsRef.getDocuments { snapshot, error in
                if error != nil {
                    print("Error fetching episodes comments \(error!.localizedDescription)")
                    completion(nil)
                } else {
        
                    if snapshot!.isEmpty {
                        completion([])
                        return
                    }
                    
                    for eachDoc in snapshot!.documents {
                        let data = eachDoc.data()
                        let comment = Comment(data: data)
                        comments.append(comment)
                    }
                    completion(comments)
                }
            }
        }
    }
    
    static func fetchSubCommentsOrderedByVotesFrom(episodeID: String, commentID: String, completion: @escaping ([Comment]?) -> ()) {
        
        var comments = [Comment]()
        let commentsRef = db.collection("episodes").document(episodeID).collection("comments").document(commentID).collection("subComments").order(by: "voteCount", descending: true)
        
        DispatchQueue.global(qos: .userInitiated).async {
            commentsRef.getDocuments { snapshot, error in
                
                if error != nil {
                    print("Error fetching episodes comments \(error!.localizedDescription)")
                    completion(nil)
                } else {
                    
                    for eachDoc in snapshot!.documents {
                        let data = eachDoc.data()
                        let comment = Comment(data: data)
                        comments.append(comment)
                    }
                    completion(comments)
                }
            }
        }
    }
    
    static func addMentionToProgramWith(usernames: [String], caption: String, contentID: String, primaryEpisodeID: String?, mentionType: MentionType) {
        
        let limit: Int = 10
        var users = [String]()
        
        if usernames.count > limit {
            users = Array(usernames [0..<limit])
        } else {
            users = usernames
        }
                
        DispatchQueue.global(qos: .userInitiated).async {
            let userRef = db.collection("users").whereField("username", in: users)
                                    
            userRef.getDocuments { snapshot, error in
                if error != nil {
                    print("Error adding mention to program")
                    return
                }
                
                if snapshot!.isEmpty {
                    print("No user with that username")
                    return
                }
                
                guard let documents = snapshot?.documents else { return }
                print("User exists")
                
                for each in documents {
                    let data = each.data()
                    let programID = data["programID"] as! String
                    
                    let type = mentionType.rawValue
                    addMentionToProgram(programID: programID, caption: caption, contentID: contentID, primaryEpisodeID: primaryEpisodeID,  mentionType: type)
                }
            }
        }
    }
    
    static func addMentionToProgram(programID: String, caption: String, contentID: String, primaryEpisodeID: String?, mentionType: String) {
               
        let mentionRef = db.collection("programs").document(programID).collection("mentions").document()
        db.collection("programs").document(programID).updateData(["hasMentions" : true])
        
        mentionRef.setData([
            "publisherID" : CurrentProgram.ID!,
            "primaryEpisodeID" : (primaryEpisodeID ?? ""),
            "publisherUsername" : User.username!,
            "imageID" : CurrentProgram.imageID!,
            "ID" : mentionRef.documentID,
            "postedDate" : Timestamp(),
            "contentID" : contentID,
            "taggedID" : programID,
            "type" : mentionType,
            "caption" : caption,
        ]) { error in
            if error != nil {
                print("Error adding mention to program")
                return
            }
            print("Success adding mention to program")
        }
    }
    
    static func postCommentForEpisode(ID: String, comment: String, completion: @escaping (Comment) ->()) {

        let commentsRef = db.collection("episodes").document(ID).collection("comments").document()
        db.collection("episodes").document(ID).updateData(["commentCount" : FieldValue.increment(Double(1))])
        let commentID = commentsRef.documentID
        FireStoreManager.updateProgramMethodsUsed(programID: CurrentProgram.ID!, repMethod: commentID)
        CurrentProgram.repMethods?.append(commentID)
        
        commentsRef.setData([
            "profileImageID" : CurrentProgram.imageID!,
            "programID" : CurrentProgram.ID!,
            "username": User.username!,
            "postedDate": Timestamp(),
            "isSubComment": false,
            "subCommentCount": 0,
            "episodeID": ID,
            "comment": comment,
            "voteCount": 0,
            "ID" : commentID
        ]) { error in
            if error != nil {
                print("Error publishing comment \(error!.localizedDescription)")
                return
            }
            let data: [String: Any] = [
                "profileImageID" : CurrentProgram.imageID!,
                "programID" : CurrentProgram.ID!,
                "username": User.username!,
                "postedDate": Timestamp(),
                "isSubComment": false,
                "subCommentCount": 0,
                "episodeID": ID,
                "comment": comment,
                "voteCount": 0,
                "ID" : commentID
            ]
            print("Success publishing comment")
            let usernames = checkIfUserWasTagged(comment: comment)
            if !usernames.isEmpty {
                addMentionToProgramWith(usernames: usernames, caption: comment, contentID: commentID, primaryEpisodeID: ID, mentionType: .commentTag)
            }
            completion(Comment(data: data))
        }
    }
    
   static func checkIfUserWasTagged(comment: String) -> [String] {
        let words = comment.components(separatedBy: " ")
        var taggedUsers = [String]()
        for word in words{
            if word.hasPrefix("@"){
                let user = word.dropFirst()
                taggedUsers.append(String(user))
            }
        }
        print("Tagged users are \(taggedUsers)")
        return(taggedUsers)
    }
    
    static func postCommentReplyForEpisode(ID: String, primaryID: String, comment: String, completion: @escaping (Comment) ->()) {
        
        let commentRef = db.collection("episodes").document(ID).collection("comments").document(primaryID).collection("subComments").document()
        db.collection("episodes").document(ID).collection("comments").document(primaryID).updateData(["subCommentCount" : FieldValue.increment(Double(1))])
        db.collection("episodes").document(ID).updateData(["commentCount" : FieldValue.increment(Double(1))])
        let subCommentID = commentRef.documentID
        FireStoreManager.updateProgramMethodsUsed(programID: CurrentProgram.ID!, repMethod: subCommentID)
        CurrentProgram.repMethods?.append(subCommentID)
        
        commentRef.setData([
            "profileImageID" : CurrentProgram.imageID!,
            "programID" : CurrentProgram.ID!,
            "username": User.username!,
            "postedDate": Timestamp(),
            "subCommentCount": 0,
            "isSubComment": true,
            "primaryID": primaryID,
            "comment": comment,
            "ID" : subCommentID,
            "episodeID": ID,
            "voteCount": 0,
        ]) { error in
            if error != nil {
                print("Error publishing sub-comment \(error!.localizedDescription)")
                return
            }
            let data: [String: Any] = [
                "profileImageID" : CurrentProgram.imageID!,
                "programID" : CurrentProgram.ID!,
                "username": User.username!,
                "postedDate": Timestamp(),
                "primaryID": primaryID,
                "isSubComment": true,
                "subCommentCount": 0,
                "comment": comment,
                "ID" : subCommentID,
                "episodeID": ID,
                "voteCount": 0,
            ]
            
            let usernames = checkIfUserWasTagged(comment: comment)
            if !usernames.isEmpty {
                addMentionToProgramWith(usernames: usernames, caption: comment, contentID: subCommentID, primaryEpisodeID: ID, mentionType: .commentReply)
            }
            
            completion(Comment(data: data))
            print("Success publishing sub-comment")
        }
    }
    
    static func deleteCommentForEpisode(ID: String, commentID: String) {
        let commentRef = db.collection("episodes").document(ID).collection("comments").document(commentID)
        db.collection("episodes").document(ID).updateData(["commentCount" : FieldValue.increment(Double(-1))])
        
        commentRef.delete { error in
            if error != nil {
                print("Error attempting to delete comment \(error!.localizedDescription)")
            } else {
                print("Success deleting comment")
            }
        }
    }
    
    static func deleteSubCommentForEpisode(ID: String, primaryID: String, commentID: String) {
        let commentRef = db.collection("episodes").document(ID).collection("comments").document(primaryID).collection("subComments").document(commentID)
            db.collection("episodes").document(ID).updateData(["commentCount" : FieldValue.increment(Double(-1))])
            db.collection("episodes").document(ID).collection("comments").document(primaryID).updateData(["subCommentCount" : FieldValue.increment(Double(-1))])
        
        commentRef.delete { error in
            if error != nil {
                print("Error attempting to delete comment \(error!.localizedDescription)")
            } else {
                print("Success deleting comment")
            }
        }
    }
    
    static func deleteSubCommentsForEpisode(ID: String, commentID: String) {
        
        let subCommentsRef = db.collection("episodes").document(ID).collection("comments").document(commentID).collection("subComments")
        db.collection("episodes").document(ID).updateData(["commentCount" : FieldValue.increment(Double(-1))])
        
        subCommentsRef.getDocuments { snapshot, error in
            if error != nil {
                print("Error attempting to fetch subComment documents")
            } else {
                print("Success fetching subComment documents")
               
                let documents = snapshot!.documents
                
                for eachDocument in documents {
                    let docID = eachDocument.documentID
                    db.collection("episodes").document(ID).collection("comments")
                        .document(commentID).collection("subComments")
                        .document(docID)
                        .delete()
                }
            }
        }
    }
    
    static func upVote(comment: Comment, by votes: Int) {
        let vote = Double(votes)
        User.downVotedComments?.removeAll(where: { $0 == comment.ID })
        User.upVotedComments?.append(comment.ID)
        
        if comment.isSubComment {
            db.collection("episodes").document(comment.episodeID)
                .collection("comments").document(comment.primaryID!)
                .collection("subComments").document(comment.ID)
                .updateData(["voteCount" : FieldValue.increment(vote)])
        } else {
            db.collection("episodes").document(comment.episodeID)
                .collection("comments").document(comment.ID)
                .updateData(["voteCount" : FieldValue.increment(vote)])
        }

        let userRef = db.collection("users").document(User.ID!)
        
        userRef.updateData([
            "upVotedComments" : FieldValue.arrayUnion([comment.ID]),
            "downVotedComments" : FieldValue.arrayRemove([comment.ID])
        ]) { error in
            if error != nil {
                print("Error including upvote to user \(error!.localizedDescription)")
                return
            }
            print("Success including upvote to user")
        }
    }
    
    static func downVote(comment: Comment, by votes: Int) {
        let vote = Double(votes)
        User.upVotedComments?.removeAll(where: { $0 == comment.ID })
        User.downVotedComments?.append(comment.ID)
        
        if comment.isSubComment {
            db.collection("episodes").document(comment.episodeID)
                .collection("comments").document(comment.primaryID!)
                .collection("subComments").document(comment.ID)
                .updateData(["voteCount" : FieldValue.increment(vote)])
        } else {
            db.collection("episodes").document(comment.episodeID)
                .collection("comments").document(comment.ID)
                .updateData(["voteCount" : FieldValue.increment(vote)])
        }
        
        let userRef = db.collection("users").document(User.ID!)
        
        userRef.updateData([
            "downVotedComments" : FieldValue.arrayUnion([comment.ID]),
            "upVotedComments" : FieldValue.arrayRemove([comment.ID])
        ]) { error in
            if error != nil {
                print("Error including downvote to user \(error!.localizedDescription)")
                return
            }
            print("Success including downvote to user")
        }
    }
    
    static func removeUpVoted(comment: Comment) {
        let vote: Double = -1
        User.upVotedComments?.removeAll(where: { $0 == comment.ID })
        
        if comment.isSubComment {
            db.collection("episodes").document(comment.episodeID)
                .collection("comments").document(comment.primaryID!)
                .collection("subComments").document(comment.ID)
                .updateData(["voteCount" : FieldValue.increment(vote)])
        } else {
            db.collection("episodes").document(comment.episodeID)
                .collection("comments").document(comment.ID)
                .updateData(["voteCount" : FieldValue.increment(vote)])
        }

        let userRef = db.collection("users").document(User.ID!)
        
        userRef.updateData([
            "upVotedComments" : FieldValue.arrayRemove([comment.ID])
        ]) { error in
            if error != nil {
                print("Error removing upvote for user \(error!.localizedDescription)")
                return
            }
            print("Success removing upvote for user")
        }
    }
    
    static func removeDownVoted(comment: Comment) {
        let vote: Double = 1
        User.downVotedComments?.removeAll(where: { $0 == comment.ID })
        
        if comment.isSubComment {
            db.collection("episodes").document(comment.episodeID)
                .collection("comments").document(comment.primaryID!)
                .collection("subComments").document(comment.ID)
                .updateData(["voteCount" : FieldValue.increment(vote)])
        } else {
            db.collection("episodes").document(comment.episodeID)
                .collection("comments").document(comment.ID)
                .updateData(["voteCount" : FieldValue.increment(vote)])
        }

        let userRef = db.collection("users").document(User.ID!)
        
        userRef.updateData([
            "downVotedComments" : FieldValue.arrayRemove([comment.ID])
        ]) { error in
            if error != nil {
                print("Error removing downvote for user \(error!.localizedDescription)")
                return
            }
            print("Success removing downvote for user")
        }
    }
    
}

