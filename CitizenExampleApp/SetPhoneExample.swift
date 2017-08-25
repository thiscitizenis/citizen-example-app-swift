import UIKit
import CitizenSDK

/*
 * Set the user's phone details.
 *
 * On making this call, an SMS is sent to the user's phone so they can confirm it.
 *
 * A Phone object is returned here, but phone details can also be accessed through
 * a Person object.
 */


class SetPhoneExample: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate
{
    var demoDetails: DemoDetails = DemoDetails()
    
    let personService: PersonService = PersonService()
    
    var pickerData: [String] = [String]()
    var countryInitials: [String] = [String]()
    
    var pickerCurrentSelection: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
        
        view.addGestureRecognizer(tap)
    
        nextExampleButton.isHidden = true
        
        if demoDetails.personId == nil || demoDetails.apiKey == nil {
            runExampleButton.isHidden = true
            resultLabel.textColor = UIColor.red
            resultLabel.text = "Unable to get example parameters"
        }
        
        self.pickerData = ["Select Code"]
        
        let countryInitials: [String] = CountryCode.allItems()
        let countryCodes: [String] = CountryCode.allDescriptions()
        
        for (index, _) in countryInitials.enumerated() {
            let pickerEntry: String = countryInitials[index] + " - " + countryCodes[index]
            pickerData.append(pickerEntry)
        }
        
        phoneCodeInput.delegate = self
        phoneCodeInput.dataSource = self
        phoneCodeInput.selectRow(0, inComponent:0, animated: false)
    }
    
    func dismissKeyboard() {
        view.endEditing(true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBOutlet weak var phoneNumberInput: UITextField!
    
    @IBOutlet weak var phoneCodeInput: UIPickerView!
    
    @IBOutlet weak var runExampleButton: UIButton!
    
    @IBOutlet weak var resultLabel: UILabel!
    
    @IBOutlet weak var nextExampleButton: UIButton!
    
    
    @IBAction func runExampleButton(_ sender: Any) {
        let phoneNumber: String? = phoneNumberInput.text
    
        if phoneNumber != nil &&
            (phoneNumber?.characters.count)! > 0 &&
            self.pickerCurrentSelection > 0
        {
            let countryInitials: [String] = CountryCode.allItems()
            
            let countryCode: CountryCode? = CountryCode.fromString(constant: countryInitials[pickerCurrentSelection - 1])
            
            let personId: String = demoDetails.personId!
            let apiKey: String = demoDetails.apiKey!
            
            var phone: Phone = Phone()
            phone.personId = personId
            phone.phoneType = PhoneType.MOBILE
            phone.countryCode = countryCode
            phone.phoneNumber = phoneNumber
            phone.formatPhoneNumber()
            
            self.personService.addPhone(personId: personId, phone: phone, apiKey: apiKey, completionHandler: setPhoneCallback)
            
        } else {
            resultLabel.textColor = UIColor.red
            resultLabel.text = "Enter phone number and country"
        }
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "confirmPhoneExampleSegue" {
            if let confirmPhoneExample = segue.destination as? ConfirmPhoneExample {
                confirmPhoneExample.demoDetails = self.demoDetails
            }
        }
    }
    
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.pickerData.count
    }
    
    
    func pickerView(_
        pickerView: UIPickerView,
                    titleForRow row: Int,
                    forComponent component: Int
        ) -> String? {
        return self.pickerData[row]
    }
    
    
    func pickerView(_
        pickerView: UIPickerView,
                    didSelectRow row: Int,
                    inComponent component: Int)
    {
        self.pickerCurrentSelection = phoneCodeInput.selectedRow(inComponent: 0)
       
        return
    }
    
    
    func setPhoneCallback(phone: Phone?, error: Error?) {
        
        if phone != nil && phone?.phoneNumber != nil && error == nil {
            self.demoDetails.phoneId = phone?.id
            
            DispatchQueue.main.async {
                self.resultLabel.textColor = UIColor.black
                self.resultLabel.text = "Phone added sucessfully: " + phone!.phoneNumber!
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
