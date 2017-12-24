import UIKit


class RegistreerComponent: UIViewController {
    
    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var paswordField: UITextField!
    @IBOutlet weak var passwordCompareField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func registreer() {
        if let paswoord = self.paswordField.text, let paswoordCompare = self.passwordCompareField.text {
            if paswoord == paswoordCompare {
                UserService.sharedInstance.registreer(username: self.usernameField.text!, password: paswoord) {response in
                    let geslaagd = response
                    if geslaagd {
                        self.performSegue(withIdentifier: "overzicht", sender: self)
                    }
                }
            }
        }
    }
}
