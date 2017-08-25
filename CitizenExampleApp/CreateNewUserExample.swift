import Foundation

import UIKit
import CitizenSDK

/*
 * Create a new user.
 *
 * New user's can be created by specifying a username, password and passphrase.
 *
 * Username and password are self-explanatory. The passphrase is used to generate the
 * user's 'mnemonic code', which is used to encrypt their private key for crypto
 * operations. The passphrase can also be used to recover their mnemonic code should
 * they switch phones etc.
 *
 * A User object is returned upon successfully creating the user. This object primarily
 * concerns login and key functionality.
 */

class CreateNewUserExample: UIViewController
{
    var demoDetails: DemoDetails = DemoDetails()
    
    let userService: UserService = UserService()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        nextExampleButton.isHidden = true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBOutlet weak var resultLabel: UILabel!
    @IBOutlet weak var nextExampleButton: UIButton!
    
    
    @IBAction func runExampleButton(_ sender: Any) {
        
        let username: String = Random.randomString(length: 8) + "@test.com"
        let password: String = "Test1234"
        let passphrase: String = "Test12"
        
        self.demoDetails.password = password
        self.demoDetails.passphrase = passphrase
        
        self.userService.createUser(username: username, password: password, passPhrase: passphrase, authPublicKey: nil, completionHandler: createNewUserCallback)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "passwordLoginExampleSegue" {
            if let passwordLoginExample = segue.destination as? PasswordLoginExample {
                passwordLoginExample.demoDetails = self.demoDetails
            }
        }
    }
    
    func createNewUserCallback(user: User?, error: Error?) {
        
        if user != nil && user?.username != nil && error == nil {
            
            self.demoDetails.userId = user?.id
            self.demoDetails.personId = user?.personId
            self.demoDetails.username = user?.username
            self.demoDetails.apiKey = user?.apiKey
            self.demoDetails.authPublicKey = user?.authPublicKey
            self.demoDetails.mnemonicCode = user?.mnemonicCode
            
            DispatchQueue.main.async {
                self.resultLabel.textColor = UIColor.black
                self.resultLabel.text = user!.username!
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
