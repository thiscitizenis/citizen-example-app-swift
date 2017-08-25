import UIKit
import CitizenSDK


/*
 * Grant a web token. Web tokens are used to log in to the Citizen Servce from a web browser.
 *
 * All the token calls so far have passed the mnemonic as an argument because encrypted data
 * is involved. The mnemonic is a sensitive piece of data that is usually and should be stored
 * securely on the user's phone.
 *
 * If a user wants to access tokens from a relatively insecure environment, such as a web browser,
 * a temporary key can be used in place of the mnemonic. The process involves generating ECDH
 * shared secrets between three parties - the browser, the Citizen Service and the user's phone.
 *
 * The process is started by the user visiting the Citizen website and sending a web login token
 * to their account. The web login token is then received and granted on the user's phone. Upon
 * granting the web login token, the user's browser session automatically logs in to the Citizen
 * Service and can use a temporary key to decrypt data.
 *
 * This example retrieves requested tokens for the user's account and grants any that are web login
 * tokens.
 */

class GrantWebLoginTokenExample: UIViewController
{
    var demoDetails: DemoDetails = DemoDetails()
    
    let tokenService: TokenService = TokenService()
    
    var apiKey: String = ""
    var secret: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        nextExampleButton.isHidden = true
        
        if demoDetails.username == nil || demoDetails.apiKey == nil || demoDetails.mnemonicCode == nil {
            runExampleButton.isHidden = true
            resultLabel.textColor = UIColor.red
            resultLabel.text = "Unable to get example parameters"
        } else {
            self.apiKey = demoDetails.apiKey!
            self.secret = demoDetails.mnemonicCode!
            self.userLabel.text = demoDetails.username!
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBOutlet weak var userLabel: UILabel!
    
    @IBOutlet weak var resultLabel: UILabel!
    
    @IBOutlet weak var runExampleButton: UIButton!
    
    @IBOutlet weak var nextExampleButton: UIButton!
    
    
    @IBAction func runExampleButton(_ sender: Any) {
        tokenService.getTokensRequested(apiKey: self.apiKey, secret: self.secret, completionHandler: getTokensCallback)
    }
    
    
    func getTokensCallback(tokenWrapper: TokenWrapper?, error: Error?) {
        
        if tokenWrapper != nil && (tokenWrapper?.count())! > 0 && error == nil {
            
            var webAccessTokenFound: Bool = false
            
            let tokens: [Token] = (tokenWrapper?.sort(sortType: TokenSortType.SORT_DATE))!
            
            for token in tokens {
                let tokenId = token.id
                let access = token.access
                let status = token.tokenStatus
                
                if tokenId != nil &&
                   access != nil &&
                   status != nil &&
                   AccessType.contains(access: access!, accessType: AccessType.WEB_ACCESS) &&
                   status == TokenStatus.WEB_ACCESS_REQUEST
                {
                    webAccessTokenFound = true
                    
                    tokenService.getToken(tokenId: tokenId!, apiKey: self.apiKey, secret: self.secret, completionHandler: getTokenCallback)
                }
            }
            
            if webAccessTokenFound == false {
                DispatchQueue.main.async {
                    self.resultLabel.textColor = UIColor.black
                    self.resultLabel.text = "No web access tokens to approve"
                    // self.nextExampleButton.isHidden = false
                }
            }
            
        } else if error != nil {
            DispatchQueue.main.async {
                self.resultLabel.text = error?.localizedDescription
                self.resultLabel.textColor = UIColor.red
            }
        } else {
            DispatchQueue.main.async {
                self.resultLabel.text = "No tokens to approve"
                self.resultLabel.textColor = UIColor.red
            }
        }
    }
    
    
    func getTokenCallback(token: Token?, error: Error?) {
        
        if token != nil && error == nil {
            
            tokenService.grantToken(token: token!, apiKey: self.apiKey, secret: self.secret, completionHandler: grantTokenCallback)
            
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
    
    
    func grantTokenCallback(token: Token?, error: Error?) {
        
        if token != nil && token?.tokenStatus != nil && error == nil {
            
            DispatchQueue.main.async {
                self.resultLabel.textColor = UIColor.black
                self.resultLabel.text = token!.tokenStatus!.toString()
                // self.nextExampleButton.isHidden = false
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
