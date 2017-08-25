import UIKit
import CitizenSDK

/*
 * Set the user's address.
 *
 * The address can be subsequently accessed through a Person object.
 *
 */

class SetAddressExample: UIViewController
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
        
        var address: Address = Address()
        address.addressLine1 = "101 Main Street"
        address.addressLine2 = "Main Avenue"
        address.addressLine3 = "Main Town"
        address.city = "Mainton"
        address.state = "Maine"
        address.countryName = CountryName.GB
        address.addressType = AddressType.HOME
        address.postCode = "111 222"
    
        let personId = demoDetails.personId!
        let apiKey = demoDetails.apiKey!
        
        self.personService.addAddress(personId: personId, address: address, apiKey: apiKey, completionHandler: setAddressCallback)
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "getPersonExampleSegue" {
            if let getPersonExample = segue.destination as? GetPersonExample {
                getPersonExample.demoDetails = self.demoDetails
            }
        }
    }

    
    
    func setAddressCallback(address: Address?, error: Error?) {
        if address != nil && address?.postCode != nil && error == nil {
            
            DispatchQueue.main.async {
                self.resultLabel.textColor = UIColor.black
                self.resultLabel.text = address!.postCode!
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
