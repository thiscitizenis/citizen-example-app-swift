import UIKit
import CitizenSDK

/*
 * Confirm the user's phone using the code sent to them via SMS.
 *
 * Whether or not the phone was confirmed successfully can be determined from the
 * returned Phone object.
 */

class ConfirmPhoneExample: UIViewController
{
    var demoDetails: DemoDetails = DemoDetails()
    
    let personService: PersonService = PersonService()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
        
        view.addGestureRecognizer(tap)
        
        nextExampleButton.isHidden = true
        
        if demoDetails.personId == nil ||
            demoDetails.apiKey == nil ||
            demoDetails.phoneId == nil
        {
            runExampleButton.isHidden = true
            resultLabel.textColor = UIColor.red
            resultLabel.text = "Unable to get example parameters"
        }
    }
    
    func dismissKeyboard() {
        view.endEditing(true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBOutlet weak var confirmCodeInput: UITextField!
    
    @IBOutlet weak var resultLabel: UILabel!
    
    @IBOutlet weak var runExampleButton: UIButton!
    
    @IBOutlet weak var nextExampleButton: UIButton!
    
    
    @IBAction func runExampleButton(_ sender: Any) {
        
        let confirmCode: String? = confirmCodeInput.text
        
        if confirmCode != nil && (confirmCode?.characters.count)! > 0 {
            
            var phone: Phone = Phone()
            phone.id = demoDetails.phoneId
            phone.smsConfirmCode = confirmCode
            
            let apiKey: String = demoDetails.apiKey!
            
            self.personService.confirmPhone(phone: phone, apiKey: apiKey, completionHandler: confirmPhoneCallback)
            
        } else {
            resultLabel.textColor = UIColor.red
            resultLabel.text = "Enter confirm code"
        }
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "setOriginExampleSegue" {
            if let setOriginExample = segue.destination as? SetOriginExample {
                setOriginExample.demoDetails = self.demoDetails
            }
        }
    }

    
    
    func confirmPhoneCallback(phone: Phone?, error: Error?) {
        
        if phone != nil && phone?.smsConfirmed != nil && error == nil {
            
            var resultString: String
            
            if phone?.smsConfirmed == true {
                resultString = "Phone confirmed successfully"
            } else {
                resultString = "Phone not confirmed"
            }
            
            DispatchQueue.main.async {
                self.resultLabel.textColor = UIColor.black
                self.resultLabel.text = resultString
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
