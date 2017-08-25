import UIKit
import CitizenSDK

/*
 * Get decrypted user data such as name, date of birth, address etc in a Person object.
 *
 * This call needs the user's mnemonic code as an argument so that the user's private key
 * can be decrypted. This is then used to decrypt the user's data.
 *
 */


class GetPersonExample: UIViewController
{
    var demoDetails: DemoDetails = DemoDetails()
    
    let personService: PersonService = PersonService()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        nextExampleButton.isHidden = true
        
        if demoDetails.personId == nil || demoDetails.apiKey == nil || demoDetails.mnemonicCode == nil {
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
        let mnemonic = demoDetails.mnemonicCode!
        
        self.personService.getPerson(apiKey: apiKey, secret: mnemonic, completionHandler: getPersonCallback)
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "issueTokenExampleSegue" {
            if let issueTokenExample = segue.destination as? IssueTokenExample {
                issueTokenExample.demoDetails = self.demoDetails
            }
        }
    }
    
    
    func getPersonCallback(person: Person?, error: Error?) {
        
        if person != nil && person?.lastName != nil && error == nil {
            
            DispatchQueue.main.async {
                self.resultLabel.textColor = UIColor.black
                self.resultLabel.text = person!.lastName!
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
