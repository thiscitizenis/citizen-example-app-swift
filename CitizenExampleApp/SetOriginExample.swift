import UIKit
import CitizenSDK

/*
 * Set the user's date of birth, place of birth and nationality.
 *
 * These currently need to be set together, but they will be able to be set
 * individually in a future release.
 *
 * Note here that the data in the person object is returned encrypted because
 * that structure has ready been initialised in an earlier call and has been
 * encrypted on the Citizen Service.
 *
 */

class SetOriginExample: UIViewController
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

        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd HH:mm"
        let dateOfBirth = formatter.date(from: "1984/01/02 00:01")
        
        var person: Person = Person()
        person.id = demoDetails.personId
        person.dateOfBirth = dateOfBirth
        person.countryNationality = CountryName.GB
        person.placeOfBirth = "London"
        
        let apiKey = demoDetails.apiKey!
        
        self.personService.updateOrigin(person: person, apiKey: apiKey, completionHandler: setOriginCallback)
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "setAddressExampleSegue" {
            if let setAddressExample = segue.destination as? SetAddressExample {
                setAddressExample.demoDetails = self.demoDetails
            }
        }
    }
    
    
    func setOriginCallback(person: Person?, error: Error?) {
        
        if person != nil && person?.id != nil && error == nil {
            
            DispatchQueue.main.async {
                self.resultLabel.textColor = UIColor.black
                self.resultLabel.text = "Origin Details Sent"
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

