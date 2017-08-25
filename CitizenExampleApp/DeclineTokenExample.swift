import UIKit
import CitizenSDK

/*
 * Decline a token.
 *
 */

class DeclineTokenExample: UIViewController
{
    var demoDetails: DemoDetails = DemoDetails()
    
    let tokenService: TokenService = TokenService()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        nextExampleButton.isHidden = true
        
        if demoDetails.apiKey == nil || demoDetails.mnemonicCode == nil  || demoDetails.tokenId_2 == nil {
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
        token.id = demoDetails.tokenId_2!
        
        self.tokenService.declineToken(token: token, apiKey: apiKey, secret: secret, completionHandler: declineTokenCallback)
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "signTokenExampleSegue" {
            if let signTokenExample = segue.destination as? SignTokenExample {
                signTokenExample.demoDetails = self.demoDetails
            }
        }
    }
    
    
    func declineTokenCallback(token: Token?, error: Error?) {
        
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

