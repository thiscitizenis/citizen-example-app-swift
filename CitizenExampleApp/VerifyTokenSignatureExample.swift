import UIKit
import CitizenSDK

/*
 * Verify a signed token.
 *
 * This functionality uses the signing user's public key to verify that they
 * signed the token.
 */

class VerifyTokenSignatureExample: UIViewController
{
    var demoDetails: DemoDetails = DemoDetails()
    
    let tokenService: TokenService = TokenService()
    let userService: UserService = UserService()
    let cryptoService: CryptoService = CryptoService()
    
    var tokenSignature: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        nextExampleButton.isHidden = true
        
        if  demoDetails.apiKey == nil ||
            demoDetails.mnemonicCode == nil ||
            demoDetails.tokenId_3 == nil
        {
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
        
        let apiKey = demoDetails.apiKey!
        let secret = demoDetails.mnemonicCode!
        let tokenId = demoDetails.tokenId_3!
        
        self.tokenService.getToken(tokenId: tokenId, apiKey: apiKey, secret: secret, completionHandler: getTokenCallback)
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "grantWebLoginTokenExampleSegue" {
            if let grantWebLoginTokenExample = segue.destination as? GrantWebLoginTokenExample {
                grantWebLoginTokenExample.demoDetails = self.demoDetails
            }
        }
    }
    
    
    func getTokenCallback(token: Token?, error: Error?) {
        
        if token != nil &&
           token?.hashedUserEmail != nil &&
           token?.getStringProperty(property: PropertyType.SIGNED_TOKEN_ID) != nil &&
           error == nil {
            
            let apiKey = demoDetails.apiKey!
            
            self.tokenSignature = token!.getStringProperty(property: PropertyType.SIGNED_TOKEN_ID)!
            
            self.userService.getDevicePublicKey(hashedUserEmail: token!.hashedUserEmail!, apiKey: apiKey, completionHandler: getPublicKeyCallback)
            
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

    
    func getPublicKeyCallback(publicKey: JsonString?, error: Error?) {
        
        if publicKey != nil && publicKey?.string != nil && error == nil {
            
            let publicKeyString: String = publicKey!.string!
            let tokenId: String = demoDetails.tokenId_3!
            let tokenSignature: String = self.tokenSignature
            
            let result: Bool? = self.cryptoService.verifySignature(publicKey: publicKeyString, value: tokenId, signature: tokenSignature)
            
            if result != nil {
                DispatchQueue.main.async {
                    self.resultLabel.text = String(result!)
                    self.resultLabel.textColor = UIColor.black
                    self.nextExampleButton.isHidden = false
                }
            } else {
                DispatchQueue.main.async {
                    self.resultLabel.text = "Unable to verify signature"
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
                self.resultLabel.text = "Unknown error"
                self.resultLabel.textColor = UIColor.red
            }
        }
    }
}
