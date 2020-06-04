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
        
        var comments = [Comment]()
        let commentsRef = db.collection("episodes").document(ID).collection("comments").order(by: "voteCount", descending: true)
        
        DispatchQueue.global(qos: .userInitiated).async {
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
    
    
    static func postCommentForEpisode(ID: String, comment: String, completion: @escaping (Comment) ->()) {
        
        let commentsRef = db.collection("episodes").document(ID).collection("comments").document()
        let commentID = commentsRef.documentID
        
        commentsRef.setData([
            "profileImageID" : (CurrentProgram.imageID ?? User.imageID)!,
            "ownerID" : (CurrentProgram.ID ?? User.ID)!,
            "isPublisher" : User.isPublisher!,
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
                "profileImageID" : (CurrentProgram.imageID ?? User.imageID)!,
                "ownerID" : (CurrentProgram.ID ?? User.ID)!,
                "isPublisher" : User.isPublisher!,
                "username": User.username!,
                "postedDate": Timestamp(),
                "isSubComment": false,
                "subCommentCount": 0,
                "episodeID": ID,
                "comment": comment,
                "voteCount": 0,
                "ID" : commentID
            ]
            completion(Comment(data: data))
            print("Success publishing comment")
        }
    }
    
    static func postCommentReplyForEpisode(ID: String, primaryID: String, comment: String, completion: @escaping (Comment) ->()) {
        
        let commentRef = db.collection("episodes").document(ID).collection("comments").document(primaryID).collection("subComments").document()
        db.collection("episodes").document(ID).collection("comments").document(primaryID).updateData(["subCommentCount" : FieldValue.increment(Double(1))])
        let subCommentID = commentRef.documentID
        
        commentRef.setData([
            "profileImageID" : (CurrentProgram.imageID ?? User.imageID)!,
            "ownerID" : (CurrentProgram.ID ?? User.ID)!,
            "isPublisher" : User.isPublisher!,
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
                "profileImageID" : (CurrentProgram.imageID ?? User.imageID)!,
                "ownerID" : (CurrentProgram.ID ?? User.ID)!,
                "isPublisher" : User.isPublisher!,
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
            completion(Comment(data: data))
            print("Success publishing sub-comment")
        }
    }
    
    static func deleteCommentForEpisode(ID: String, commentID: String) {
        let commentRef = db.collection("episodes").document(ID).collection("comments").document(commentID)
        
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
        if let index = User.upVotedComments?.firstIndex(of: comment.ID) {
            User.upVotedComments?.remove(at: index)
        }
        
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
        if let index = User.downVotedComments?.firstIndex(of: comment.ID) {
            User.upVotedComments?.remove(at: index)
        }
        
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
    
    
    static func fetchProfileWith(ownerID: String, isPublisher: Bool, completion: @escaping (Program?, Listener?) ->()) {
        
        DispatchQueue.global(qos: .userInteractive).async {
            if isPublisher {
                let programRef = db.collection("programs").document(ownerID)
                
                programRef.getDocument { snapshot, error in
                    if error != nil {
                        print("Error fetching program's profile")
                        return
                    }
                    guard let data = snapshot?.data() else { return }
                    let program = Program(data: data)
                   
                    if program.isPrimaryProgram && program.hasMultiplePrograms! {
                        FireStoreManager.fetchSubProgramsWithIDs(programIDs: program.programIDs!, for: program) {
                            completion(program, nil)
                        }
                    } else {
                        completion(program, nil)
                    }
                }
            } else {
                let userRef = db.collection("users").document(ownerID)
                
                userRef.getDocument { snapshot, error in
                    if error != nil {
                        print("Error fetching user's profile")
                        return
                    }
                    guard let data = snapshot?.data() else { return }
                    let listener = Listener(data: data)
                    completion(nil, listener)
                }
            }
        }
    }
    
}

