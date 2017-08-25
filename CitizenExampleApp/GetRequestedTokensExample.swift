import UIKit
import CitizenSDK


/*
 * Get a list of requested tokens.
 *
 * A list of issued tokens can be similarly obtained using the GetIssuedTokens task.
 *
 * Token calls usually require a user's mnemonic because user data, including email addresses
 * are stored encrypted on the Citizen Service.
 */

class GetRequestedTokensExample: UIViewController
{
    var demoDetails: DemoDetails = DemoDetails()
    
    let tokenService: TokenService = TokenService()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        nextExampleButton.isHidden = true
        
        if demoDetails.apiKey == nil || demoDetails.mnemonicCode == nil {
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
        
        self.tokenService.getTokensRequested(apiKey: apiKey, secret: secret, completionHandler: getTokensCallback)
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "grantTokenExampleSegue" {
            if let grantTokenExample = segue.destination as? GrantTokenExample {
                grantTokenExample.demoDetails = self.demoDetails
            }
        }
    }
    
    
    func getTokensCallback(tokenWrapper: TokenWrapper?, error: Error?) {
        
        if tokenWrapper != nil && (tokenWrapper?.count())! == 3 && error == nil {
            
            let tokens: [Token] = (tokenWrapper?.sort(sortType: TokenSortType.SORT_DATE))!
                
            demoDetails.tokenId_1 = tokens[0].id
            demoDetails.tokenId_2 = tokens[1].id
            demoDetails.tokenId_3 = tokens[2].id
            
            DispatchQueue.main.async {
                self.resultLabel.textColor = UIColor.black
                self.resultLabel.text = self.demoDetails.tokenId_1!
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
