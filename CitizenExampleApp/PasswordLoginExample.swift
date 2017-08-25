import Foundation

import UIKit
import CitizenSDK

/*
 * Log in with a username and password.
 *
 * Upon successful login a User object is returned.
 *
 * Note here that when logging in the mnemonic code is not contained in the User
 * object as it is intended to be stored securely on the phone. It can be fetched
 * using GetMnemonicTask if needed.
 *
 */

class PasswordLoginExample: UIViewController
{
    var demoDetails: DemoDetails = DemoDetails()
    
    let userService: UserService = UserService()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        nextExampleButton.isHidden = true
        
         if demoDetails.username == nil || demoDetails.password == nil {
            runExampleButton.isHidden = true
            resultLabel.textColor = UIColor.red
            resultLabel.text = "Unable to get example parameters"
         }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBOutlet weak var resultLabel: UILabel!
    
    @IBOutlet weak var nextExampleButton: UIButton!
    
    @IBOutlet weak var runExampleButton: UIButton!
    
    @IBAction func runExampleButton(_ sender: Any) {
        
        let username: String = demoDetails.username!
        let password: String = demoDetails.password!
        
        self.userService.loginUserPass(username: username, password: password, completionHandler: passwordLoginCallback)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "createFingerprintKeyExampleSegue" {
            if let createFingerprintKeyExample = segue.destination as? CreateFingerprintKeyExample {
                createFingerprintKeyExample.demoDetails = self.demoDetails
            }
        }
    }
    
    func passwordLoginCallback(user: User?, error: Error?) {
        
        if user != nil && user?.apiKey != nil && error == nil {
            
            DispatchQueue.main.async {
                self.resultLabel.textColor = UIColor.black
                self.resultLabel.text = user!.apiKey!
                self.nextExampleButton.isHidden = false
            }
            
        } else if error != nil {
            DispatchQueue.main.async {
                self.resultLabel.text = error?.localizedDescription
                self.resultLabel.textColor = UIColor.red
            }
        } else {
            DispatchQueue.main.async {
                self.resultLabel.text = "Unknown error"
                self.resultLabel.textColor = UIColor.red
            }
        }
    }
}
