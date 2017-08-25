import UIKit
import CitizenSDK

/*
 * Issue token requests.
 *
 * The following data is need to create a token:
 *
 *   Requester email - email address of the the user requesting data
 *   User email      - email address of the user from whom data is being requested
 *   Token duration  - specifies how long the requester can access the data
 *   Token access    - specifies the type of data requested (eg, name, DOB, address etc).
 *
 * Upon sending the token, the recipient user will receive a notification on their phone
 * and can grant or decline access to the data specified in it.
 *
 * In this example, the issuing and receiving user are the same, but in ordinary use they
 * would be different users.
 *
 */

class IssueTokenExample: UIViewController
{
    var demoDetails: DemoDetails = DemoDetails()
    
    let tokenService: TokenService = TokenService()
    
    var tokensIssued: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        nextExampleButton.isHidden = true
        
        if demoDetails.apiKey == nil || demoDetails.mnemonicCode == nil || demoDetails.username == nil {
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
        let username = demoDetails.username!
        var access: Int
        
        var token_1: Token = Token()
        token_1.requesterEmail = username
        token_1.userEmail = username
        token_1.durationType = TokenDurationType.MONTH
        token_1.duration = 2
        access = 0
        access = AccessType.add(access: access, accessType: AccessType.NAME)
        access = AccessType.add(access: access, accessType: AccessType.DOB)
        token_1.access = access
        
        var token_2: Token = Token()
        token_2.requesterEmail = username
        token_2.userEmail = username
        token_2.durationType = TokenDurationType.WEEK
        token_2.duration = 6
        access = 0
        access = AccessType.add(access: access, accessType: AccessType.NAME)
        access = AccessType.add(access: access, accessType: AccessType.PHONE)
        token_2.access = access
        
        var token_3: Token = Token()
        token_3.requesterEmail = username
        token_3.userEmail = username
        token_3.durationType = TokenDurationType.MONTH
        token_3.duration = 2
        access = 0
        access = AccessType.add(access: access, accessType: AccessType.NAME)
        access = AccessType.add(access: access, accessType: AccessType.DOB)
        access = AccessType.add(access: access, accessType: AccessType.NAME)
        access = AccessType.add(access: access, accessType: AccessType.TOKEN_SIGNATURE)
        token_3.access = access
        
        self.tokenService.issueToken(token: token_1, apiKey: apiKey, secret: secret, completionHandler: issueTokenCallback)
        
        sleep(1)
        
        self.tokenService.issueToken(token: token_2, apiKey: apiKey, secret: secret, completionHandler: issueTokenCallback)
        
        sleep(1)
        
        self.tokenService.issueToken(token: token_3, apiKey: apiKey, secret: secret, completionHandler: issueTokenCallback)
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "getRequestedTokensExampleSegue" {
            if let getRequestedTokensExample = segue.destination as? GetRequestedTokensExample {
                getRequestedTokensExample.demoDetails = self.demoDetails
            }
        }
    }

    
    func issueTokenCallback(token: Token?, error: Error?) {
        
        if token != nil && token?.id != nil && error == nil {
            
            if self.tokensIssued == 2 {
                DispatchQueue.main.async {
                    self.resultLabel.textColor = UIColor.black
                    self.resultLabel.text = token!.id!
                    self.nextExampleButton.isHidden = false
                }
            } else {
                self.tokensIssued = self.tokensIssued + 1
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
