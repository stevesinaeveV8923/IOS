import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var paswordField: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func login() {
        UserService.sharedInstance.logIn(username: self.usernameField.text!, password: self.paswordField.text!) {
            response in
            let geslaagd = response
            self.usernameField.text = ""
            self.paswordField.text = ""
            if geslaagd {
                self.performSegue(withIdentifier: "overzicht", sender: self)
            }
        }
    }
    
    @IBAction func unwindFromLogin(_ segue: UIStoryboardSegue) {
        switch segue.identifier {
        case "logout"?: print("uitgelogd")
        case "login"?: print("login")
        default:
            fatalError("Unkown segue")
        }
    }
    
    @IBAction func hideKeyboard(_ sender: UITextField) {
        sender.resignFirstResponder()
    }
    
    @IBAction func moveFocus() {
        usernameField.resignFirstResponder()
        paswordField.becomeFirstResponder()
    }
}

