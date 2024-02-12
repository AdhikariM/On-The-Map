//
//  LoginViewController.swift
//  OnTheMap
//
//  Created by Mahesh Adhikari

import UIKit

class LoginViewController: UIViewController {
    
    //MARK: Outlets
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    let segueToMapViewID = "LogInSuccessSegue"
    let udacityURL = URL(string: "https://www.udacity.com")!
    
    //MARK: Load or unload View
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        updateViewState(isViewClickable: true)
    }

    override func viewDidDisappear(_ animated: Bool) {
        self.emailTextField.text = nil
        self.passwordTextField.text = nil
        self.updateViewState(isViewClickable: true) 
    }
    //MARK: IBActions
    @IBAction func loginRequested(_ sender: Any) {
        self.updateViewState(isViewClickable: false)
        UdacityAPI.login(username: emailTextField.text ?? "", password: passwordTextField.text ?? "", completion: handleLogInResponse(success:errorMessage:))
    }
    
    @IBAction func sendToUdacity(_ sender: Any) {
        UIApplication.shared.open(self.udacityURL)
        
    }
    
    //MARK: Supporting Network Functions
    func postUdacitySession() -> Void {
        
    }
    
    //MARK: Completion Handlers
    func handleLogInResponse(success: Bool, errorMessage: String?) {
        if success {
            // get user public data
            UdacityAPI.getUserInformationRequest(completion: confirmLogIn(success:error:))
        } else {
            showLoginFailure(message: errorMessage ?? "")
        }
    }
    
    func confirmLogIn(success: Bool, error: Error?) {
        if success {
            performSegue(withIdentifier: "LogInSuccessSegue", sender: self)
        } else {
            showLoginFailure(message: error?.localizedDescription ?? "")
        }
    }
    
    
    //MARK: Supporting View Fuctions
    func updateViewState(isViewClickable: Bool) -> Void {
        loginButton.isEnabled = isViewClickable
        emailTextField.isEnabled = isViewClickable
        passwordTextField.isEnabled = isViewClickable
        if !isViewClickable {
            activityIndicator.startAnimating()
        } else {
            activityIndicator.stopAnimating()
        }
    }
    
    
    func showLoginFailure(message: String) {
        let alertVC = UIAlertController(title: "Login Failed", message: message, preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        show(alertVC, sender: nil)
        updateViewState(isViewClickable: true)
    }
  
}



