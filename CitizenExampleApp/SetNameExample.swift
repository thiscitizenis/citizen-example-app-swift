import UIKit
import CitizenSDK

/*
 * Set the user's name.
 *
 * A Person object is returned here rather than the User object returned  when logging in.
 * The Person object primarily concerns personal data such as name, date of birth, address
 * etc.
 *
 */

class SetNameExample: UIViewController
{
    var demoDetails: DemoDetails = DemoDetails()
    
    let personService: PersonService = PersonService()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        nextExampleButton.isHidden = true
        
        if demoDetails.personId == nil || demoDetails.apiKey == nil {
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
        
        var name: Name  = Name()
        name.title      = NameTitle.MR.toString()
        name.firstName  = "John"
        name.middleName = "Paul"
        name.lastName   = "Doe"
        name.gender     = GenderType.MALE.toString()
        
        let personId = demoDetails.personId!
        let apiKey = demoDetails.apiKey!
        
        self.personService.updateName(personId: personId, name: name, apiKey: apiKey, completionHandler: setNameCallback)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "setPhoneExampleSegue" {
            if let setPhoneExample = segue.destination as? SetPhoneExample {
                setPhoneExample.demoDetails = self.demoDetails
            }
        }
    }

    
    
    func setNameCallback(person: Person?, error: Error?) {
        if person != nil && person?.firstName != nil && error == nil {
            
            DispatchQueue.main.async {
                self.resultLabel.textColor = UIColor.black
                self.resultLabel.text = person!.firstName!
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
