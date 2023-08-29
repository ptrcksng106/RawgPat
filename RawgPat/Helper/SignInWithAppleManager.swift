//
//  SignInWithAppleManager.swift
//  RawgPat
//
//  Created by Patrick Samuel Owen Saritua Sinaga on 19/08/23.
//

import Foundation
import AuthenticationServices

struct SignInWithAppleManager {
    static let userIdentifierKey = "userIdentifier"
    static func checkUserAuth(completion: @escaping (AuthState) -> ()) {
        guard let userIdentifier = UserDefaults.standard.string(forKey: userIdentifierKey) else {
            print("User Identifier doesnt exist")
            completion(.undefined)
            return
        }
        if userIdentifier == "" {
            print("User identifier is empty string")
            completion(.undefined)
            return
        }
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        appleIDProvider.getCredentialState(forUserID: userIdentifier) { (credentialState, _) in
            DispatchQueue.main.async {
                switch credentialState {
                case .authorized:
                    completion(.signedIn)
                case .revoked:
                    completion(.undefined)
                case .notFound:
                    completion(.signedOut)
                default:
                    break
                }
            }
        }
    }
}
