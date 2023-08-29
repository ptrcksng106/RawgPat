//
//  SignInViewController.swift
//  RawgPat
//
//  Created by Patrick Samuel Owen Saritua Sinaga on 19/08/23.
//

import AuthenticationServices
import UIKit

protocol SignInViewControllerDelegate {
    func didFinishAuth()
}

class SignInViewController: UIViewController {
    private let signInButton = ASAuthorizationAppleIDButton()
    var delegate: SignInViewControllerDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        view.addSubview(signInButton)
        signInButton.addTarget(self, action: #selector(didTapSignIn), for: .touchUpInside)
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        signInButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            signInButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            signInButton.bottomAnchor.constraint(equalTo: view.centerYAnchor, constant: 300),
            signInButton.heightAnchor.constraint(equalToConstant: 50),
            signInButton.widthAnchor.constraint(equalToConstant: 300)
        ])
    }
    @objc func didTapSignIn() {
        let provider = ASAuthorizationAppleIDProvider()
        let request = provider.createRequest()
        request.requestedScopes = [.fullName, .email]
        let controller = ASAuthorizationController(authorizationRequests: [request])
        controller.delegate = self
        controller.presentationContextProvider = self
        controller.performRequests()
    }

}

extension SignInViewController: ASAuthorizationControllerDelegate {
    private func registerNewAccount(credential: ASAuthorizationAppleIDCredential) {
        delegate?.didFinishAuth()
        self.dismiss(animated: true, completion: nil)
    }
    private func signInWithExistingAccount(credential: ASAuthorizationAppleIDCredential) {
        delegate?.didFinishAuth()
        self.dismiss(animated: true, completion: nil)
    }
    private func signInWithUserAndPassword(credential: ASPasswordCredential) {
        delegate?.didFinishAuth()
        self.dismiss(animated: true, completion: nil)
    }
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        print("Failed")
    }
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        switch authorization.credential {
        case let appleIDCredential as ASAuthorizationAppleIDCredential:
            let userId = appleIDCredential.user
            UserDefaults.standard.set(userId, forKey: SignInWithAppleManager.userIdentifierKey)
            if let _ = appleIDCredential.email, let _ = appleIDCredential.fullName {
                registerNewAccount(credential: appleIDCredential)
            } else {
                signInWithExistingAccount(credential: appleIDCredential)
            }
            break
        case let passwordCredential as ASPasswordCredential:
            let userId = passwordCredential.user
            UserDefaults.standard.set(userId, forKey: SignInWithAppleManager.userIdentifierKey)
            signInWithUserAndPassword(credential: passwordCredential)
            break
        default:
            break
        }
    }
}

extension SignInViewController: ASAuthorizationControllerPresentationContextProviding {
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return view.window!
    }
}
