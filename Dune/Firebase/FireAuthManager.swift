//
//  FireAuthManager.swift
//  Dune
//
//  Created by Waylan Sands on 11/4/20.
//  Copyright © 2020 Waylan Sands. All rights reserved.
//

import FirebaseAuth

enum Result {
    case success
    case fail
}

struct FireAuthManager {
    
    static let wrongPasswordForChangAlert = CustomAlertView(alertType: .wrongPasswordForChange)
    static let wrongPasswordAlert = CustomAlertView(alertType: .wrongPassword)
    static let networkIssueAlert = CustomAlertView(alertType: .networkIssue)
    static let invalidEmailAlert = CustomAlertView(alertType: .invalidEmail)
    static let noUserAlert = CustomAlertView(alertType: .noUserFound)
    
    static func updateUser(with newEmail: String, using password: String, completion: @escaping (Result) -> ()){
        
        DispatchQueue.global(qos: .userInitiated).async {
            
            guard let email = User.email else { return }
            print(email)
            print(password)
            
            let credential = EmailAuthProvider.credential(withEmail: email, password: password)
            Auth.auth().currentUser?.reauthenticate(with: credential) { authData, error in
                
                if let error = error {
                    if let errCode = AuthErrorCode(rawValue: error._code) {
                        
                        switch errCode {
                        case .networkError:
                            UIApplication.shared.windows.last?.addSubview(networkIssueAlert)
                            print("There was a networkError")
                        case .wrongPassword:
                            UIApplication.shared.windows.last?.addSubview(wrongPasswordForChangAlert)
                            print("Wrong password")
                        case .userNotFound:
                            UIApplication.shared.windows.last?.addSubview(noUserAlert)
                            print("No user found")
                        case .invalidEmail:
                            UIApplication.shared.windows.last?.addSubview(invalidEmailAlert)
                            print("Invalid Email")
                        default:
                            print("Other error! \(errCode)")
                        }
                    }
                    completion(.fail)
                } else {
                    print("The user was successfully re-authenticated.")
                    authData?.user.updateEmail(to: newEmail, completion: { error in
                        if error != nil {
                            print("Error updating new email")
                        } else {
                            print("User has changed their email")
                            User.email = newEmail
                            FireStoreManager.updateUserEmail()
                            completion(.success)
                        }
                    })
                }
            }
        }
    }
    
    static func updateUser(password: String, with newPassword: String, completion: @escaping (Result) -> ()){
        
        DispatchQueue.global(qos: .userInitiated).async {
            
            guard let email = User.email else { return }
            print(email)
            print(password)
            
            let credential = EmailAuthProvider.credential(withEmail: email, password: password)
            Auth.auth().currentUser?.reauthenticate(with: credential) { authData, error in
                
                if let error = error {
                    if let errCode = AuthErrorCode(rawValue: error._code) {
                        
                        switch errCode {
                        case .networkError:
                            UIApplication.shared.windows.last?.addSubview(networkIssueAlert)
                            print("There was a networkError")
                        case .wrongPassword:
                            UIApplication.shared.windows.last?.addSubview(wrongPasswordAlert)
                            print("Wrong password")
                        case .userNotFound:
                            UIApplication.shared.windows.last?.addSubview(noUserAlert)
                            print("No user found")
                        case .invalidEmail:
                            UIApplication.shared.windows.last?.addSubview(invalidEmailAlert)
                            print("Invalid Email")
                        default:
                            print("Other error! \(errCode)")
                        }
                    }
                    completion(.fail)
                } else {
                    print("The user was successfully re-authenticated.")
                    authData?.user.updatePassword(to: newPassword, completion: { error in
                        
                        if error != nil {
                            print("Error updating new password")
                        } else {
                            print("User has changed their password")
                            completion(.success)
                        }
                    })
                }
            }
        }
    }
    
    
    static func reAuthenticate(with email: String, using password: String, completion: @escaping (Result) -> ()) {
        
        DispatchQueue.global(qos: .userInitiated).async {
            
            guard let email = User.email else { return }
            
            let credential = EmailAuthProvider.credential(withEmail: email, password: password)
            Auth.auth().currentUser?.reauthenticate(with: credential) { authData, error in
                
                if let error = error {
                    if let errCode = AuthErrorCode(rawValue: error._code) {
                        
                        switch errCode {
                        case .networkError:
                            UIApplication.shared.windows.last?.addSubview(networkIssueAlert)
                            print("There was a networkError")
                        case .wrongPassword:
                            UIApplication.shared.windows.last?.addSubview(wrongPasswordForChangAlert)
                            print("Wrong password")
                        case .userNotFound:
                            UIApplication.shared.windows.last?.addSubview(noUserAlert)
                            print("No user found")
                        case .invalidEmail:
                            UIApplication.shared.windows.last?.addSubview(invalidEmailAlert)
                            print("Invalid Email")
                        default:
                            print("Other error! \(errCode)")
                        }
                    }
                    completion(.fail)
                } else {
                    print("The user was successfully re-authenticated.")
                    completion(.success)
                }
            }
        }
    }

    static func reAuthenticate(credential: AuthCredential, completion: @escaping (Result) -> ()) {
        Auth.auth().currentUser?.reauthenticate(with: credential, completion: {  authData, error in
            if let error = error {
                print("Error with re-authentication \(error.localizedDescription)")
                 completion(.fail)
            } else {
                completion(.success)
            }
        })
     }
    
}

