/*
 * Copyright (c) 2017 Razeware LLC
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 */

import UIKit
import CoreData
import LocalAuthentication

class LoginViewController: UIViewController {

    var managedObjectContext: NSManagedObjectContext?
    
   
    @IBOutlet weak var loginButtonHeight: NSLayoutConstraint!
    @IBOutlet weak var passwordHeightConstraint: NSLayoutConstraint!
    
    @IBAction func swipeGesture(_ sender: UISwipeGestureRecognizer) {
        let logged = UserDefaults.standard.bool(forKey: "hasLoginKey")
        if !logged{
            self.performSegue(withIdentifier: "goBackToWalkthrough", sender: Any.self)
            let walktroughView = WalktroughViewController()
            walktroughView.index = 4
        }
    }
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var createInfoLabel: UILabel!
    @IBOutlet weak var sampleLabel:UILabel!
    @IBOutlet weak var createLabel:UILabel!
    let touchMe = BiometricIDAuth()
    var currencyName:String = ""
    var currencyCode:String = ""
    var currencySymbol:String = ""
    
    struct KeychainConfiguration {
        static let serviceName = "Simple Expense"
        static let accessGroup: String? = nil
    }
    var passwordItems: [KeychainPasswordItem] = []
    let createLoginButtonTag = 0
    let loginButtonTag = 1
    @IBAction func unwindToLoginViewController(_ segue: UIStoryboardSegue) {
    }
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var forgotButton: UIButton!
    @IBAction func forgotPassword(_ sender: Any){
        let alert = UIAlertController(title: "Forgot Password", message: "", preferredStyle: .alert)
        
        let submitAction = UIAlertAction(title: "Submit", style: .default, handler: { (action) -> Void in
            guard let textField = alert.textFields?.first,
                let email = textField.text else {
                    return
            }
        
        if email != UserDefaults.standard.value(forKey: "email") as! String{
            alert.title = "Incorrect Email"
            self.present(alert, animated: true, completion: nil)
        }
        else if email == UserDefaults.standard.value(forKey: "email") as! String{
            let alert2 = UIAlertController(title: "FJF", message: "", preferredStyle: .alert)
            
            let passwordItem = KeychainPasswordItem(service: KeychainConfiguration.serviceName,
                account: UserDefaults.standard.value(forKey: "username")as! String,
                accessGroup: KeychainConfiguration.accessGroup)
            do {
                let keychainPassword = try passwordItem.readPassword()
                alert2.title = "Your password is: \(keychainPassword)"
                let ok = UIAlertAction(title: "OK", style: .destructive, handler: { (action) -> Void in })
                alert2.addAction(ok)
                self.present(alert2, animated: true, completion: nil)
            }
            catch {
                fatalError("Error updating keychain - \(error)")
            }
        }
        
        })
        
    let cancel = UIAlertAction(title: "Cancel", style: .destructive, handler: { (action) -> Void in })
    alert.addTextField { (textField: UITextField) in
    textField.keyboardAppearance = .dark
    textField.keyboardType = .default
    textField.autocorrectionType = .default
    textField.placeholder = "Email Adress"
    textField.clearButtonMode = .whileEditing
    }
        CoreDataHelper.save()
        alert.addAction(cancel)
        alert.addAction(submitAction)
        alert.message = "Please Enter Email Address"
        present(alert, animated: true, completion: nil)
}
    @IBAction func labelTapped(_ sender: Any) {
        let alertView = UIAlertController(title: "Please Enter Email", message: "",preferredStyle:. alert)
        let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: nil)
        let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
        alertView.addAction(cancelAction)
        alertView.addAction(okAction)
        present(alertView, animated: true, completion: nil)
        return
    }
    override func viewDidLoad() {
        
        super.viewDidLoad()
        let tapGestureRecognizer = UITapGestureRecognizer(target:self , action: #selector(LoginViewController.labelPressed(recognizer:)))
        tapGestureRecognizer.numberOfTapsRequired = 1
        sampleLabel.isUserInteractionEnabled = true
        sampleLabel.addGestureRecognizer(tapGestureRecognizer)
        sampleLabel.text = "Select Currency"
        sampleLabel.adjustsFontSizeToFitWidth = true
        // 1
        let hasLogin = UserDefaults.standard.bool(forKey: "hasLoginKey")
        
        // 2
        if hasLogin {
            loginButton.setTitle("Login", for: .normal)
            loginButton.tag = loginButtonTag
            createLabel.text = "Login"
            forgotButton.isHidden = false
            createInfoLabel.isHidden = true
            sampleLabel.isHidden = true
            emailTextField.isHidden = true
            passwordHeightConstraint.constant = -46
            loginButtonHeight.constant = -6
            authenticationWithTouchID()
        } else {
            loginButton.setTitle("Create", for: .normal)
            forgotButton.isHidden = true
            loginButton.tag = createLoginButtonTag
            createInfoLabel.isHidden = false
            createLabel.text = "Create"
            
            UserDefaults.standard.removeObject(forKey: "chosenCurrencyCode")
            UserDefaults.standard.removeObject(forKey: "chosenCurrencyName")
            UserDefaults.standard.removeObject(forKey: "chosenCurrencySymbol")
        }
        
        if let storedUsername = UserDefaults.standard.value(forKey: "username") as? String {
            usernameTextField.text = storedUsername
        }
        hideKeyboardWhenTappedAround()
    }
    @objc func labelPressed(recognizer:UITapGestureRecognizer){
        performSegue(withIdentifier: "currencyChoose", sender: Any?.self)
    }
    func isValidEmail(testStr:String) -> Bool {        
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: testStr)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?){
        if let identifier = segue.identifier{
            if identifier=="currencyChoose"{
                
            }
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(false)
        
        if let currencyCode = UserDefaults.standard.string(forKey: "chosenCurrencyCode"){
            self.currencyCode = currencyCode
        }
        
        if let currencyName = UserDefaults.standard.string(forKey: "chosenCurrencyName"){
            self.currencyName = currencyName
        }
        
        if let currencySymbol = UserDefaults.standard.string(forKey: "chosenCurrencySymbol"){
            self.currencySymbol = currencySymbol
        }
        if currencyCode == ""||currencySymbol == ""||currencyName == ""{
            sampleLabel.text = "Select Currency"
        }
        else{
            sampleLabel.text = "   "+currencySymbol+"-"+currencyCode+"-"+currencyName+"   "
        }
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(false)
    }
    @IBAction func loginAction(_ sender: AnyObject) {
        // 1
        // Check that text has been entered into both the username and password fields.
        

        // 3
        if sender.tag == createLoginButtonTag {
            
            // 4
            let hasLoginKey = UserDefaults.standard.bool(forKey: "hasLoginKey")
            if !hasLoginKey {
                if emailTextField.text==""||sampleLabel.text=="Select Currency" || usernameTextField.text=="" || passwordTextField.text==""{
                    let alertView = UIAlertController(title: "Some Fields are incomplete",
                                                      message: "Please fill all fields",
                                                      preferredStyle:. alert)
                    let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
                    alertView.addAction(okAction)
                    present(alertView, animated: true, completion: nil)
                    return
                }
                else if !isValidEmail(testStr: emailTextField.text!){
                    let alertView = UIAlertController(title: "Email is invalid",
                                                      message: "Please enter a valid email adress",
                                                      preferredStyle:. alert)
                    let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
                    alertView.addAction(okAction)
                    present(alertView, animated: true, completion: nil)
                    return
                }
                else{
                UserDefaults.standard.setValue(usernameTextField.text, forKey: "username")
                UserDefaults.standard.setValue(emailTextField.text, forKey:"email")
                UserDefaults.standard.setValue(currencySymbol, forKey:"chosenCurrencySymbol")
                UserDefaults.standard.setValue(currencyName, forKey:"chosenCurrencyName")
                UserDefaults.standard.setValue(currencyCode, forKey:"chosenCurrencyCode")
                    
                let newCategory:Category = CoreDataHelper.createNewCategory()
                newCategory.title = "Food"
                let newCategory2:Category = CoreDataHelper.createNewCategory()
                newCategory2.title = "Transport"
                let newCategory3:Category = CoreDataHelper.createNewCategory()
                newCategory3.title = "Travel"
                let newCategory4:Category = CoreDataHelper.createNewCategory()
                newCategory4.title = "Shopping"
                let newCategory5:Category = CoreDataHelper.createNewCategory()
                newCategory5.title = "Salary"
                let newCollection:Collections = CoreDataHelper.createNewCollection()
                newCollection.title = "Daily"
                    CoreDataHelper.save()
                }
            }
            
            // 5
            do {
                let passwordItem = KeychainPasswordItem(service: KeychainConfiguration.serviceName,
                                                        account: usernameTextField.text!,
                                                        accessGroup: KeychainConfiguration.accessGroup)
                
                // Save the password for the new item.
                try passwordItem.savePassword(passwordTextField.text!)
            } catch {
                fatalError("Error updating keychain - \(error)")
            }
            
            // 6
            UserDefaults.standard.set(true, forKey: "hasLoginKey")
            UserDefaults.standard.set(true, forKey: "first time opening")
            loginButton.tag = loginButtonTag
            
            performSegue(withIdentifier: "dismissLogin", sender: self)
            
        } else if sender.tag == loginButtonTag {
            
            // 7
           
            if checkLogin(username: usernameTextField.text!, password: passwordTextField.text!) {
                performSegue(withIdentifier: "dismissLogin", sender: self)
            } else {
                // 8
                let alertView = UIAlertController(title: "Login Problem",
                                                  message: "Wrong username or password.",
                                                  preferredStyle: .alert)
                let okAction = UIAlertAction(title: "Try Again!", style: .default)
                alertView.addAction(okAction)
                present(alertView, animated: true, completion: nil)
            }
        }
    }
    func checkLogin(username: String, password: String) -> Bool {
        guard username == UserDefaults.standard.value(forKey: "username") as? String else {
            return false
        }
        do {
            let passwordItem = KeychainPasswordItem(service: KeychainConfiguration.serviceName,
            account: username,accessGroup: KeychainConfiguration.accessGroup)
            let keychainPassword = try passwordItem.readPassword()
            return password == keychainPassword
        }catch {
            fatalError("Error reading password from keychain - \(error)")
        }
        return false
        
    }
    
    
    override func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
}



extension LoginViewController {
    
    func authenticationWithTouchID() {
        let localAuthenticationContext = LAContext()
        localAuthenticationContext.localizedFallbackTitle = "Use Passcode"
        
        var authError: NSError?
        let reasonString = "To access the secure data"
        
        if localAuthenticationContext.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &authError) {
            
            localAuthenticationContext.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reasonString) { success, evaluateError in
                
                if success {
                    DispatchQueue.main.async {
                    self.performSegue(withIdentifier: "dismissLogin", sender: self)
                    }//TODO: User authenticated successfully, take appropriate action
                    
                } else {
                    //TODO: User did not authenticate successfully, look at error and take appropriate action
                    guard let error = evaluateError else {
                        return
                    }
                    
                    //TODO: If you have choosen the 'Fallback authentication mechanism selected' (LAError.userFallback). Handle gracefully
                    
                }
            }
        } else {
            
            guard let error = authError else {
                return
            }
            //TODO: Show appropriate alert if biometry/TouchID/FaceID is lockout or not enrolled
        }
    }
    
    func evaluatePolicyFailErrorMessageForLA(errorCode: Int) -> String {
        var message = ""
        if #available(iOS 11.0, macOS 10.13, *) {
            switch errorCode {
            case LAError.biometryNotAvailable.rawValue:
                message = "Authentication could not start because the device does not support biometric authentication."
                
            case LAError.biometryLockout.rawValue:
                message = "Authentication could not continue because the user has been locked out of biometric authentication, due to failing authentication too many times."
                
            case LAError.biometryNotEnrolled.rawValue:
                message = "Authentication could not start because the user has not enrolled in biometric authentication."
                
            default:
                message = "Did not find error code on LAError object"
            }
        } else {
            switch errorCode {
            case LAError.touchIDLockout.rawValue:
                message = "Too many failed attempts."
                
            case LAError.touchIDNotAvailable.rawValue:
                message = "TouchID is not available on the device"
                
            case LAError.touchIDNotEnrolled.rawValue:
                message = "TouchID is not enrolled on the device"
                
            default:
                message = "Did not find error code on LAError object"
            }
        }
        
        return message;
    }
    
    func evaluateAuthenticationPolicyMessageForLA(errorCode: Int) -> String {
        
        var message = ""
        
        switch errorCode {
            
        case LAError.authenticationFailed.rawValue:
            message = "The user failed to provide valid credentials"
            
        case LAError.appCancel.rawValue:
            message = "Authentication was cancelled by application"
            
        case LAError.invalidContext.rawValue:
            message = "The context is invalid"
            
        case LAError.notInteractive.rawValue:
            message = "Not interactive"
            
        case LAError.passcodeNotSet.rawValue:
            message = "Passcode is not set on the device"
            
        case LAError.systemCancel.rawValue:
            message = "Authentication was cancelled by the system"
            
        case LAError.userCancel.rawValue:
            message = "The user did cancel"
            
        case LAError.userFallback.rawValue:
            message = "The user chose to use the fallback"
            
        default:
            message = evaluatePolicyFailErrorMessageForLA(errorCode: errorCode)
        }
        
        return message
    }
}

