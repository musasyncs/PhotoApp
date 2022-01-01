//
//  AuthManager.swift
//  PhotoApp
//
//  Created by Ewen on 2021/12/28.
//

import FirebaseAuth

class AuthManager {
    static let shared = AuthManager()
    
    enum AuthError: Error {
        case unknownError
    }
    
    //沒用到
//    func isUserLoggedIn() -> Bool {
//        return Auth.auth().currentUser != nil
//    }
    
    func signUpNewUser(withEmail email: String, password: String, completion: @escaping (Result<User, Error>) -> Void) {
        Auth.auth().createUser(withEmail: email, password: password) { result, error in
            if let error = error {
                completion(.failure(error))
            } else if let user = result?.user {
                completion(.success(user))
            } else {
                completion(.failure(AuthError.unknownError))
            }
        }
    }
    
    func loginUser(withEmail email: String, password: String, completion: @escaping (Result<User, Error>) -> Void) {
        Auth.auth().signIn(withEmail: email, password: password) { result, error in
            if let error = error {
                completion(.failure(error))
            } else if let user = result?.user {
                completion(.success(user))
            } else {
                completion(.failure(AuthError.unknownError))
            }
        }
    }
        
    func logoutUser() -> Result<Void, Error> {
        do {
            try Auth.auth().signOut()
            return .success(())
        } catch(let error) {
            return .failure(error)
        }
    }
    
    func resetPassword(withEmail email: String, completion: @escaping (Result<Void, Error>) -> Void) {
        Auth.auth().sendPasswordReset(withEmail: email) { error in
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(()))
            }
        }
    }
    
}
