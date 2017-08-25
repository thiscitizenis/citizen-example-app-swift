import UIKit

/* This view controller is the start of a simple app to demonstrate the Citizen API.
 *
 * It goes through the following actions:
 *
 *   - Create a new user (CreateNewUserExample.swift).
 *
 *   - Log in with a username and password (PasswordLoginExample.swift).
 *
 *   - Create a key pair for fingerprint login and signing (CreateFingerprintKeyExample.swift).
 *
 *   - Log in using a fingerprint signature (FingerprintLoginExample.swift).
 *
 *   - Set the user's name (SetNameExample.swift).
 *
 *   - Set the user's phone details (SetPhoneExample.swift).
 *
 *   - Confirm the user's phone with a code sent by SMS (ConfirmPhoneExample.swift).
 *
 *   - Set the user's date of birth, nationality and place of birth (SetOriginExample.swift).
 *
 *   - Set the user's address (SetAddressExample.swift).
 *
 *   - Get the user's details eg name, phone, DOB etc (GetPersonExample.swift).
 *
 *   - Issue tokens (IssueTokenExample.swift).
 *
 *   - Get token requests (GetRequestedTokensExample.swift).
 *
 *   - Grant a token (GrantTokenExample.swift).
 *
 *   - Decline a token (DeclineTokenExample.swift).
 *
 *   - Verify a token (VerifySignedTokenExample.swift).
 *
 *   - Log in in via a web browser by approving a token (GrantWebLoginTokenExample.swift).
 *
 */

class MainViewController: UIViewController
{
    var demoDetails: DemoDetails = DemoDetails()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

