import UIKit
import CitizenSDK

/*
 * Create a public/private key pair for use when logging in and signing tokens.
 *
 * The Android Key Store allows the creation of key which can only be used if the
 * user has authenticated within a given time period. After the user authenticates,
 * the app can use the private key to sign data.
 *
 * The fingerprint login works as follows:
 *
 *   1) Get a nonce from the Citizen Service
 *
 *   2) Sign the nonce using the private key.
 *
 *   3) Send the username, nonce and signed nonce to the Citizen Service
 *
 * For this mechanism to work, the the public key must be sent to the Citizen
 * Service in advance so that signatures can be verified with it.
 *
 * This example creates a key pair for the Android Key Store and registers the
 * public part of the key with the Citizen Service.
 *
 * Note that this key is not used to encrypt or decrypt data - only for logging
 * in and signing tokens.
 *
 */

class CreateFingerprintKeyExample: UIViewController
{
    var demoDetails: DemoDetails = DemoDetails()
    
    let cryptoService: CryptoService = CryptoService()
    let userService: UserService = UserService()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        nextExampleButton.isHidden = true
        
        if demoDetails.userId == nil || demoDetails.apiKey == nil {
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
        
        let authPublicKey: String? = self.cryptoService.generateKeys()
        
        if authPublicKey == nil {
            DispatchQueue.main.async {
                self.resultLabel.textColor = UIColor.red
                self.resultLabel.text = "Unable to create key pair"
            }
            
            return
        }
        
        let userId: String = demoDetails.userId!
        let apiKey: String = demoDetails.apiKey!
        
        self.userService.enrollAuthPublicKey(userId: userId, authPublicKey: authPublicKey!, apiKey: apiKey, completionHandler: createFingerprintKeyCallback)
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "fingerprintAuthExampleSegue" {
            if let fingerprintAuthExample = segue.destination as? FingerprintAuthExample {
                fingerprintAuthExample.demoDetails = self.demoDetails
            }
        }
    }
    
    
    func createFingerprintKeyCallback(user: User?, error: Error?) {
        
        if user != nil && user?.authPublicKey != nil && error == nil {
            
            DispatchQueue.main.async {
                self.resultLabel.textColor = UIColor.black
                self.resultLabel.text = user!.authPublicKey!
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
