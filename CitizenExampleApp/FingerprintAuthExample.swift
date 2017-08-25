import UIKit
import CitizenSDK

/*
 * Log in with a fingerprint. This assumes that a public key has been registered with
 * the Citizen Service for the user (see CreateFingerprintKeyExample.swift).
 *
 */

class FingerprintAuthExample: UIViewController
{
    var demoDetails: DemoDetails = DemoDetails()
    
    var userService: UserService = UserService()
    var cryptoService: CryptoService = CryptoService()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        nextExampleButton.isHidden = true
        
        if demoDetails.username == nil {
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
    
    
    @IBOutlet weak var runExampleButton: UIButton!
    
    
    @IBOutlet weak var nextExampleButton: UIButton!
    
    
    @IBAction func runExampleButton(_ sender: Any) {
        
        if FingerprintService.hasFingerprintIDConfigured() == false {
            DispatchQueue.main.async {
                self.resultLabel.textColor = UIColor.red
                self.resultLabel.text = "Fingerprint authentication not configured"
                self.nextExampleButton.isHidden = false
            }
            
            return
        }
        
        self.userService.getLoginNonce(completionHandler: getNonceCallback)
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "setNameExampleSegue" {
            if let setNameExample = segue.destination as? SetNameExample {
                setNameExample.demoDetails = self.demoDetails
            }
        }
    }
    
    
    func getNonceCallback(loginNonce: JsonString?, error: Error?) {
        
        if loginNonce != nil && loginNonce?.string != nil && error == nil {
            
            let username: String = demoDetails.username!
            let nonce: String = (loginNonce?.string!)!
            
            let encodedSignature: String? = cryptoService.signLoginTransaction(username: username, token: nonce)
            
            if encodedSignature != nil {
                self.userService.loginWithSignedTransaction(username: username, token: nonce, encodedTransactionSignature: encodedSignature!, completionHandler: fingerprintAuthCallback)
            } else {
                DispatchQueue.main.async {
                    self.resultLabel.text = CryptoServiceError.unableToSignLoginTransaction.localizedDescription
                    self.resultLabel.textColor = UIColor.red
                }
            }
            
        } else if error != nil {
            DispatchQueue.main.async {
                self.resultLabel.text = error?.localizedDescription
                self.resultLabel.textColor = UIColor.red
            }
        } else {
            DispatchQueue.main.async {
                self.resultLabel.text = "Unknown error retrieving nonce"
                self.resultLabel.textColor = UIColor.red
            }
        }
    }
    
    
    func fingerprintAuthCallback(user: User?, error: Error?) {
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
                self.resultLabel.text = "Unknown error auth"
                self.resultLabel.textColor = UIColor.red
            }
        }
    }
}
