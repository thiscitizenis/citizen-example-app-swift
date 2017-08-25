import UIKit
import CitizenSDK

/*
 * The key pair that was generated in CreateFingerprintKeyExample.swift
 * can also be used to sign a token.
 *
 * This gives extra confidence that the user has granted consent for access
 * to their data.
 *
 * Similarly to logging using a fingerprint signature, a UI element is also
 * provided here given that there is a lot of boilerplate code involved in
 * implementing this functionality in Android.
 */

class SignTokenExample: UIViewController
{
    var demoDetails: DemoDetails = DemoDetails()
    
    let tokenService: TokenService = TokenService()
    let cryptoService: CryptoService = CryptoService()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        nextExampleButton.isHidden = true
        
        if demoDetails.apiKey == nil || demoDetails.mnemonicCode == nil  || demoDetails.tokenId_3 == nil {
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
        
        let apiKey: String = demoDetails.apiKey!
        let secret: String = demoDetails.mnemonicCode!
        let tokenId: String = demoDetails.tokenId_3!
        
        var token: Token = Token()
        token.id = tokenId
        token.tokenStatus = TokenStatus.GRANTED
        
        let signature = self.cryptoService.signString(value: tokenId)
        
        if signature != nil {
            token.setProperty(property: PropertyType.SIGNED_TOKEN_ID, value: signature!)
            self.tokenService.grantToken(token: token, apiKey: apiKey, secret: secret, completionHandler: signTokenCallback)
        } else {
            DispatchQueue.main.async {
                self.resultLabel.textColor = UIColor.red
                self.resultLabel.text = "Unable to get signature"
                self.nextExampleButton.isHidden = false
            }
        }
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "verifyTokenSignatureExampleSegue" {
            if let verifyTokenSignatureExample = segue.destination as? VerifyTokenSignatureExample {
                verifyTokenSignatureExample.demoDetails = self.demoDetails
            }
        }
    }
    
    
    func signTokenCallback(token: Token?, error: Error?) {
        
        if token != nil && error == nil {
            
            let tokenSignature = token?.getStringProperty(property: PropertyType.SIGNED_TOKEN_ID)
            
            if tokenSignature != nil {
                DispatchQueue.main.async {
                    self.resultLabel.textColor = UIColor.black
                    self.resultLabel.text = tokenSignature
                    self.nextExampleButton.isHidden = false
                }
            } else {
                DispatchQueue.main.async {
                    self.resultLabel.textColor = UIColor.red
                    self.resultLabel.text = "Token does not have signature"
                    self.nextExampleButton.isHidden = false
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
