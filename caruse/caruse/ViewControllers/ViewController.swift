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
            if geslaagd {
                self.performSegue(withIdentifier: "overzicht", sender: self)
            }
        }
    }
}

