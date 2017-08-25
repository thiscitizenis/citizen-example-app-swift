import UIKit
import CitizenSDK

/*
 * Grant a token.
 *
 * The following steps happen on the Citizen Service when granting a token:
 *
 *   1) Requested data is decrypted using the user's private key.
 *
 *   2) Requested data is encrypted using the requesting user's public key.
 *
 *   3) Token is added to the requesting user's token store.
 *
 * The token that is returned from this call has encrypted data, since it has
 * been encrypted with the requesting user's public key.
 *
 */

class GrantTokenExample: UIViewController
{
    var demoDetails: DemoDetails = DemoDetails()
    
    let tokenService: TokenService = TokenService()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        nextExampleButton.isHidden = true
        
        if demoDetails.apiKey == nil || demoDetails.mnemonicCode == nil  || demoDetails.tokenId_1 == nil {
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
        
        let apiKey = demoDetails.apiKey!
        let secret = demoDetails.mnemonicCode!
        
        var token: Token = Token()
        token.id = demoDetails.tokenId_1!
        
        self.tokenService.grantToken(token: token, apiKey: apiKey, secret: secret, completionHandler: grantTokenCallback)
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "declineTokenExampleSegue" {
            if let declineTokenExample = segue.destination as? DeclineTokenExample {
                declineTokenExample.demoDetails = self.demoDetails
            }
        }
    }
    
    
    func grantTokenCallback(token: Token?, error: Error?) {
        
        if token != nil && token?.tokenStatus != nil && error == nil {
            
            DispatchQueue.main.async {
                self.resultLabel.textColor = UIColor.black
                self.resultLabel.text = token!.tokenStatus!.toString()
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
