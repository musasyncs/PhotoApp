//
//  LoginViewController.swift
//  PhotoApp
//
//  Created by Ewen on 2022/1/1.
//

import UIKit
import MBProgressHUD

class LoginViewController: UIViewController {
    
    private enum PageType {
        case login
        case signup
    }
    
    private var currentPageType: PageType = .login {
        didSet { setupViewFor(pageType: currentPageType) }
    }
    
    @IBOutlet weak var segmentControl: UISegmentedControl!
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var passwordComfirmationTextfield: UITextField!
    
    @IBOutlet weak var emailErrorLabel: UILabel!
    @IBOutlet weak var passwordErrorLabel: UILabel!
    @IBOutlet weak var resultLabel: UILabel!
    
    @IBOutlet weak var forgetPasswordButton: UIButton!
    @IBOutlet weak var signupButton: UIButton!
    @IBOutlet weak var loginButton: UIButton!
    
    let passwordToggleButton = UIButton(type: .custom)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViewFor(pageType: .login)
        enablePasswordToggle()
        
        /// 已經走過導覽流程
        LocalStorage.shared.hasOnboarded = true
        ///
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        emailTextField.becomeFirstResponder()
    }
        
}

// MARK: - Helper functions
extension LoginViewController {
    //登入、註冊畫面設定
    private func setupViewFor(pageType: PageType) {
        if pageType == .login {
            passwordComfirmationTextfield.isHidden = true
            signupButton.isHidden = true
            loginButton.isHidden = false
            loginButton.layer.cornerRadius = 10
            forgetPasswordButton.isHidden = false
        } else {
            passwordComfirmationTextfield.isHidden = false
            signupButton.isHidden = false
            signupButton.layer.cornerRadius = 10
            loginButton.isHidden = true
            forgetPasswordButton.isHidden = true
        }
        
        emailTextField.text = ""
        emailTextField.placeholder = "Email"
        emailErrorLabel.text = "Required"
        emailErrorLabel.isHidden = false
        
        passwordTextField.text = ""
        passwordTextField.placeholder = "Password"
        passwordErrorLabel.text = "Required"
        passwordErrorLabel.isHidden = false
        passwordTextField.isSecureTextEntry = true
        
        resultLabel.isHidden = true
        
        checkForValidForm()
    }
    
    // 密碼隱藏切換
    private func enablePasswordToggle(){
        passwordToggleButton.setImage(UIImage(systemName: "eye.fill"), for: .normal)
        passwordToggleButton.setImage(UIImage(systemName: "eye.slash.fill"), for: .selected)
        passwordToggleButton.addTarget(self, action: #selector(togglePasswordView), for: .touchUpInside)
        passwordTextField.rightView = passwordToggleButton
        passwordTextField.rightViewMode = .always
    }
    
    @objc func togglePasswordView(_ sender: Any) {
        passwordTextField.isSecureTextEntry.toggle()
        passwordToggleButton.isSelected.toggle()
    }
        
    // 無效Email判斷
    private func invalidEmail(_ value: String) -> String? {
        let reqularExpression = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let predicate = NSPredicate(format: "SELF MATCHES %@", reqularExpression)
        if !predicate.evaluate(with: value) {
            return "Invalid Email Address"
        }
        return nil
    }
    
    // 無效密碼判斷
    private func invalidPassword(_ value: String) -> String? {
        if value.count < 6 {
            return "Password must be at least 6 characters"
        }
        if containsDigit(value) {
            return "Password must contain at least 1 digit"
        }
        if containsLowerCase(value) {
            return "Password must contain at least 1 lowercase character"
        }
        if containsUpperCase(value) {
            return "Password must contain at least 1 uppercase character"
        }
        return nil
    }
    
    private func containsDigit(_ value: String) -> Bool {
        let reqularExpression = ".*[0-9]+.*"
        let predicate = NSPredicate(format: "SELF MATCHES %@", reqularExpression)
        return !predicate.evaluate(with: value)
    }
    
    private func containsLowerCase(_ value: String) -> Bool {
        let reqularExpression = ".*[a-z]+.*"
        let predicate = NSPredicate(format: "SELF MATCHES %@", reqularExpression)
        return !predicate.evaluate(with: value)
    }
    
    private func containsUpperCase(_ value: String) -> Bool {
        let reqularExpression = ".*[A-Z]+.*"
        let predicate = NSPredicate(format: "SELF MATCHES %@", reqularExpression)
        return !predicate.evaluate(with: value)
    }
    
    //紅色小字警告都消失才能按按鈕
    private func checkForValidForm() {
        if emailErrorLabel.isHidden && passwordErrorLabel.isHidden {
            loginButton.isEnabled = true
            signupButton.isEnabled = true
            loginButton.backgroundColor = .systemGreen
            signupButton.backgroundColor = .systemMint
        } else {
            loginButton.isEnabled = false
            signupButton.isEnabled = false
            loginButton.backgroundColor = .lightGray
            signupButton.backgroundColor = .lightGray
        }
    }
}

// MARK: - Signup Check / Login Check
extension LoginViewController {
    private func signupCheck() {
        guard let email = emailTextField.text, !email.isEmpty,
              let password = passwordTextField.text, !password.isEmpty,
              let passwordComfirmation = passwordComfirmationTextfield.text, !passwordComfirmation.isEmpty else {
                  showResult(withMessage: "Please fill your password again")
                  return
              }
        guard password == passwordComfirmation else {
            showResult(withMessage: "Password is not matched")
            return
        }
        
        MBProgressHUD.showAdded(to: view, animated: true)
        AuthManager.shared.signUpNewUser(withEmail: email, password: password) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let user):
                UserManager.shared.createProfile(userId: user.uid, username: email) { photoUser in
                    guard let photoUser = photoUser else {
                        print("Create profile failed")
                        return
                    }
                    /// local storage
                    LocalStorage.shared.saveUser(userId: photoUser.userId, username: photoUser.username)
                    LocalStorage.shared.hasLogedIn = true
                    ///
                    Presentaion.shared.show(vc: .MainTabBarController)
                    MBProgressHUD.hide(for: self.view, animated: true)
                }
            case .failure(let error):
                self.showResult(withMessage: error.localizedDescription)
            }
        }
    }
    
    
    private func loginCheck() {
        guard let email = emailTextField.text, !email.isEmpty,
              let password = passwordTextField.text, !password.isEmpty else {
                  showResult(withMessage: "email和密碼不可為為空")
                  return
              }
        
        MBProgressHUD.showAdded(to: view, animated: true)
        AuthManager.shared.loginUser(withEmail: email, password: password) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let user):
                UserManager.shared.createProfile(userId: user.uid, username: email) { photoUser in
                    guard let photoUser = photoUser else {
                        print("Retrieve profile failed")
                        return
                    }
                    /// Save user to local storage
                    LocalStorage.shared.saveUser(userId: photoUser.userId, username: photoUser.username)
                    LocalStorage.shared.hasLogedIn = true
                    ///
                    Presentaion.shared.show(vc: .MainTabBarController)
                    MBProgressHUD.hide(for: self.view, animated: true)
                }
            case .failure(let error):
                self.showResult(withMessage: error.localizedDescription)
            }
        }
    }
    
    private func showResult(withMessage message: String) {
        resultLabel.isHidden = false
        resultLabel.text = message
    }
}

// MARK: - Actions
extension LoginViewController {
    @IBAction func segmentControlPressed(_ sender: UISegmentedControl) {
        currentPageType = sender.selectedSegmentIndex == 0 ? .login : .signup
    }
    
    
    @IBAction func forgetPasswordButtonPressed(_ sender: UIButton) {
        let alertController = UIAlertController(title: "Forget password", message: "Please enter your email address", preferredStyle: .alert)
        alertController.addTextField(configurationHandler: nil)
        let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: nil)
        let okAction = UIAlertAction(title: "OK", style: .default) { _ in
            if let textField = alertController.textFields?.first, let email = textField.text, !email.isEmpty {
                
                // MARK: - resetPassword
                AuthManager.shared.resetPassword(withEmail: email) { [weak self] result in
                    guard let self = self else { return }
                    switch result {
                    case .success:
                        self.showAlert(title: "Password reset successful", message: "Please check your email to find the password link.")
                    case .failure(let error):
                        print(error.localizedDescription)
                    }
                }
                
            }
        }
        alertController.addAction(okAction)
        alertController.addAction(cancelAction)
        present(alertController, animated: true, completion: nil)
    }
    
    private func showAlert(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
    }
    
    
    // email changed
    @IBAction func emailChanged(_ sender: Any) {
        if let email = emailTextField.text {
            if let errorMessage = invalidEmail(email) {
                emailErrorLabel.text = errorMessage
                emailErrorLabel.isHidden = false
            } else {
                emailErrorLabel.isHidden = true
            }
        }
        checkForValidForm()
    }
    
    // password changed
    @IBAction func passwordChanged(_ sender: Any) {
        if let password = passwordTextField.text {
            if let errorMessage = invalidPassword(password) {
                passwordErrorLabel.text = errorMessage
                passwordErrorLabel.isHidden = false
            } else {
                passwordErrorLabel.isHidden = true
            }
        }
        checkForValidForm()
    }
    
    
    // 按 return 收鍵盤
    @IBAction func dismissKeyboard(_ sender: Any) {
        view.endEditing(true)
    }
    // 按 空白頁 收鍵盤
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    
    @IBAction func loginButtonPressed(_ sender: Any) {
        view.endEditing(true)
        delay(durationInSeconds: 2.0) {
            self.loginCheck()
        }
    }
    
    @IBAction func signupButtonPressed(_ sender: UIButton) {
        view.endEditing(true)
        delay(durationInSeconds: 2.0) {
            self.signupCheck()
        }
    }
}





// 檢查電話號碼
//@IBAction func phoneChanged(_ sender: Any) {
//    if let phoneNumber = phoneTF.text {
//        if let errorMessage = invalidPhoneNumber(phoneNumber) {
//            phoneError.text = errorMessage
//            phoneError.isHidden = false
//        } else {
//            phoneError.isHidden = true
//        }
//    }
//    checkForValidForm()
//}
//
//func invalidPhoneNumber(_ value: String) -> String? {
//    let set = CharacterSet(charactersIn: value)
//    if !CharacterSet.decimalDigits.isSuperset(of: set) {
//        return "Phone Number must contain only digits"
//    }
//
//    if value.count != 10 {
//        return "Phone Number must be 10 Digits in Length"
//    }
//    return nil
//}
