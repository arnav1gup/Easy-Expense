//
//  SettingsChangeController.swift
//  Expense Tracker Final
//
//  Created by Arnav Gupta  on 3/2/18.
//  Copyright © 2018 Arnav Gupta. All rights reserved.
//

import UIKit
import Foundation
import LocalAuthentication

class SettingsChangeController: UIViewController {
    @IBAction func unwindToChangeController(_ segue: UIStoryboardSegue) {
    }
    
    @IBOutlet weak var nameLabel: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var currencyField: UITextField!
    
    var tabBarItemONE: UITabBarItem = UITabBarItem()
    var tabBarItemTWO: UITabBarItem = UITabBarItem()
    var tabBarItemTHREE:UITabBarItem = UITabBarItem()
    var tabBarItemFOUR:UITabBarItem = UITabBarItem()
    
    var passwordToCheck2:String? = nil
    
    @IBOutlet weak var navigationBarIphoneX: UIImageView!
    @IBAction func editButton(_ sender: Any) {
        authenticationWithTouchID()
    }
    @IBOutlet weak var navigationBarIphoneRest: UIImageView!
    //    @IBAction func gopBack(_ sender: Any) {
//        performSegue(withIdentifier: "unwindToMainScreenController", sender: Any?.self)
//    }
    struct KeychainConfiguration {
        static let serviceName = "Simple Expense"
        static let accessGroup: String? = nil
    }
    override func viewDidAppear(_ animated: Bool) {
        let tabBarControllerItems = self.tabBarController?.tabBar.items
        
        if let arrayOfTabBarItems = tabBarControllerItems as AnyObject as? NSArray{
            
            tabBarItemONE = arrayOfTabBarItems[0] as! UITabBarItem
            tabBarItemONE.isEnabled = true
            
            tabBarItemTWO = arrayOfTabBarItems[1] as! UITabBarItem
            tabBarItemTWO.isEnabled = true
            
            tabBarItemTHREE = arrayOfTabBarItems[2] as! UITabBarItem
            tabBarItemTHREE.isEnabled = true
            
            tabBarItemFOUR = arrayOfTabBarItems[3] as! UITabBarItem
            tabBarItemFOUR.isEnabled = true
            
        }
        super.viewDidAppear(false)
    }
    override func viewDidLoad() {
        

        super.viewDidLoad()
        nameLabel.isEnabled = false
        passwordField.isEnabled = false
        emailField.isEnabled = false
        currencyField.isEnabled = false
        nameLabel.text = UserDefaults.standard.value(forKey: "username") as! String
        emailField.text = UserDefaults.standard.value(forKey: "email") as! String
        currencyField.text = "\(UserDefaults.standard.value(forKey: "chosenCurrencySymbol")!)\(UserDefaults.standard.value(forKey: "chosenCurrencyCode")!) - \(UserDefaults.standard.value(forKey: "chosenCurrencyName")!)"
        currencyField.adjustsFontSizeToFitWidth = true
        let passwordItem = KeychainPasswordItem(service: KeychainConfiguration.serviceName,
                                                account: UserDefaults.standard.value(forKey: "username")as! String,
                                                accessGroup: KeychainConfiguration.accessGroup)
        do {
       
        let keychainPassword = try passwordItem.readPassword()
        passwordField.text = keychainPassword
        passwordField.isSecureTextEntry = true
            
        }
        catch {
            fatalError("Error updating keychain - \(error)")
        }
        }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
extension SettingsChangeController {
    
    func checkLogin(password: String) -> Bool {
        do {
            let passwordItem = KeychainPasswordItem(service: KeychainConfiguration.serviceName,
                                                    account: UserDefaults.standard.value(forKey: "username")as! String,
                                                    accessGroup: KeychainConfiguration.accessGroup)
            let keychainPassword = try passwordItem.readPassword()
            return password == keychainPassword
        }
        catch {
            fatalError("Error reading password from keychain - \(error)")
        }
        
        return false
    }
    
    func authenticationWithTouchID() {
        let localAuthenticationContext = LAContext()
        localAuthenticationContext.localizedFallbackTitle = "Use Passcode"
        var authError: NSError?
        let reasonString = "To access the secure data"
        
        if localAuthenticationContext.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &authError) {
            
            localAuthenticationContext.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reasonString) { success, evaluateError in
                
                if success {
                    DispatchQueue.main.async(execute: {
                        self.performSegue(withIdentifier: "settingChange", sender: self)
                    })
                } else {
                    //TODO: User did not authenticate successfully, look at error and take appropriate action
                    let message: String
                    
                    if #available(iOS 11.0, *) {
                        switch evaluateError {
                        case LAError.authenticationFailed?:
                            message = "There was a problem verifying your identity."
                        case LAError.userCancel?:
                            message = "You pressed cancel."
                        case LAError.userFallback?:
                            print("hello")
                            let alert = UIAlertController(title: "Enter Password", message: "", preferredStyle: .alert)
                            let submitAction = UIAlertAction(title: "Confirm", style: .default, handler: { (action) -> Void in
                                guard let textField = alert.textFields?.first,
                                    let passwordToCheck = textField.text else {
                                        return
                                }
                                self.checkLogin(password: passwordToCheck)
                                if self.checkLogin(password: passwordToCheck){
                                    self.performSegue(withIdentifier: "settingChange", sender: self)
                                }
                                else {
                                    textField.text = ""
                                    alert.title = "Try Again"
                                    self.present(alert, animated: true, completion: nil)
                                }
                            })
                            
                            let cancel = UIAlertAction(title: "Cancel", style: .destructive, handler: { (action) -> Void in })
                            alert.addTextField { (textField: UITextField) in
                                textField.keyboardAppearance = .dark
                                textField.keyboardType = .default
                                textField.autocorrectionType = .default
                                textField.placeholder = "Enter Password"
                                textField.clearButtonMode = .whileEditing
                                textField.isSecureTextEntry = true
                                
                            }
                            alert.addAction(submitAction)
                            alert.addAction(cancel)
                            self.present(alert, animated: true, completion: nil)
                            
                            message = "You pressed password."
                        case LAError.biometryNotAvailable?:
                            message = "Face ID/Touch ID is not available."
                        case LAError.biometryNotEnrolled?:
                            message = "Face ID/Touch ID is not set up."
                        case LAError.biometryLockout?:
                            message = "Face ID/Touch ID is locked."
                        default:
                            message = "Face ID/Touch ID may not be configured"
                        }
                    } else {
                        // Fallback on earlier versions
                    }
                    //TODO: If you have choosen the 'Fallback authentication mechanism selected' (LAError.userFallback). Handle gracefully
                    
                }
            }
        } else {
            
            guard let error = authError else {
                return
            }
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
        default: break
        }
        
        return message
    }
}
