//
//  AuthViewModel.swift
//  FlickrClone
//
//  Created by Oğulcan Tamyürek on 19.10.2022.
//

import Foundation
import FirebaseAuth
import FirebaseRemoteConfig
import FirebaseFirestore

enum AuthViewModelChange {
    case didErrorOccurred(_ error: Error)
    case didSignUpSuccessful
}

final class AuthViewModel {
    
    private let db = Firestore.firestore()
    
    private let defaults = UserDefaults.standard
    
    var changeHandler: ((AuthViewModelChange) -> Void)?
    
    func signUp(email: String, password: String) {
        Auth.auth().createUser(withEmail: email, password: password) { result, error in
            
            if let error = error {
                self.changeHandler?(.didErrorOccurred(error))
                return
            }
            
            let user = User(username: result?.user.displayName,
                            email: result?.user.email,
                            pp: "",
                            favorites: [])
            
            do {
                guard let data = try user.dictionary,
                      let id = result?.user.uid else {
                    return
                }

                self.defaults.set(id, forKey: "uid")

                self.db.collection("users").document(id).setData(data) { error in

                    if let error = error {
                        self.changeHandler?(.didErrorOccurred(error))
                    } else {
                        self.changeHandler?(.didSignUpSuccessful)
                    }
                }
            } catch {
                self.changeHandler?(.didErrorOccurred(error))
            }
        }
    }
    
    func signIn(email: String,
                password: String,
                completion: @escaping () -> Void) {
        Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
            if let error = error {
                self.changeHandler?(.didErrorOccurred(error))
                return
            }
            
            guard let id = authResult?.user.uid else {
                return
            }
            
            self.defaults.set(id, forKey: "uid")
            
            completion()
        }
    }
    
    func fetchRemoteConfig(completion: @escaping (Bool) -> Void) {
        let remoteConfig = RemoteConfig.remoteConfig()
        let settings = RemoteConfigSettings()
        settings.minimumFetchInterval = 0
        remoteConfig.configSettings = settings
        remoteConfig.setDefaults(fromPlist: "RemoteConfigDefaults")
        
        remoteConfig.fetch { (status, error) -> Void in
            if status == .success {
                remoteConfig.activate { _, error in
                    
                    if let error = error {
                        self.changeHandler?(.didErrorOccurred(error))
                        return
                    }
                    
                    let isSignUpDisabled = remoteConfig.configValue(forKey: "register").boolValue
                    DispatchQueue.main.async {
                        completion(isSignUpDisabled)
                    }
                }
            } else {
                guard let error = error else {
                    return
                }
                self.changeHandler?(.didErrorOccurred(error))
            }
        }
    }
}

extension Encodable {
    var dictionary: [String: Any]? {
        get throws {
            let data = try JSONEncoder().encode(self)
            let dictionary = try JSONSerialization.jsonObject(with: data,
                                                              options: .allowFragments) as? [String: Any]
            return dictionary
        }
    }
}
