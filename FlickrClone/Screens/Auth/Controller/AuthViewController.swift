//
//  AuthViewController.swift
//  FlickrClone
//
//  Created by Oğulcan Tamyürek on 19.10.2022.
//

import UIKit

class AuthViewController: UIViewController {
    
    private let viewModel: AuthViewModel
    
    enum AuthType: String {
        case signIn = "Sign In"
        case signUp = "Sign Up"
        
        init(text: String) {
            switch text {
            case "Sign In":
                self = .signIn
            case "Sign Up":
                self = .signUp
            default:
                self = .signIn
            }
        }
    }
    
    var authType: AuthType = .signIn {
        didSet {
            titleLabel.text = title
            confirmButton.setTitle(title, for: .normal)
        }
    }
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var credentionTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var confirmButton: UIButton!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    
    // MARK: - Init
    init(viewModel: AuthViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel.changeHandler = { change in
            switch change {
            case .didErrorOccurred(let error):
                self.showError(error)
            case .didSignUpSuccessful:
                self.showAlert(title: "SIGN UP SUCCESSFUL!")
            }
        }
        /*
         flickrApiProvider.request(.getRecentPhotos) { result in
         switch result {
         case .failure(let error):
         print(error.localizedDescription)
         case .success(let response):
         print(String(decoding: response.data, as: UTF8.self))
         }
         }
         */
        title = "Auth"
        
        viewModel.fetchRemoteConfig { isSignUpDisabled in
            self.segmentedControl.isHidden = !isSignUpDisabled
        }
    }
    
    @IBAction private func didTapLoginButton(_ sender: UIButton) {
        guard let credential = credentionTextField.text,
              let password = passwordTextField.text else {
            return
        }
        switch authType {
        case .signIn:
            viewModel.signIn(email: credential,
                             password: password,
                             completion: { [weak self] in
                guard let self = self else { return }
                let homeViewModel = HomeViewModel()
                let homeViewController = HomeViewController(viewModel: homeViewModel)
                
                let searchViewModel = SearchViewModel()
                let searchViewController = SearchViewController()
                
                let profileViewModel = ProfileViewModel()
                let profileViewController = ProfileViewController()
                
                let tabBarController = UITabBarController()
                tabBarController.viewControllers = [homeViewController,
                                                    searchViewController,
                                                    profileViewController]
                self.navigationController?.pushViewController(tabBarController, animated: true)
            })
        case .signUp:
            viewModel.signUp(email: credential,
                             password: password)
        }
    }
    
    @IBAction private func didValueChangedSegmentedControl(_ sender: UISegmentedControl) {
        let title = segmentedControl.titleForSegment(at: segmentedControl.selectedSegmentIndex)
        authType = AuthType(text: title ?? "Sign In")
    }
}

extension UIViewController {
    func showAlert(title: String? = nil,
                   message: String? = nil,
                   cancelButtonTitle: String? = nil,
                   handler: ((UIAlertAction) -> Void)? = nil ) {
        let alertController = UIAlertController(title: title,
                                                message: message,
                                                preferredStyle: .alert)
        
        let defaultAction = UIAlertAction(title: "OK",
                                          style: .default,
                                          handler: handler)
        
        if let cancelButtonTitle = cancelButtonTitle {
            let cancelAction = UIAlertAction(title: cancelButtonTitle,
                                             style: .cancel)
            alertController.addAction(cancelAction)
        }
        
        alertController.addAction(defaultAction)
        self.present(alertController, animated: true)
    }
    
    func showError(_ error: Error) {
        showAlert(title: "Error Occurred",
                  message: error.localizedDescription)
    }
}
