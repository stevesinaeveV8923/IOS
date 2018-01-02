import UIKit


class RegistreerComponent: UIViewController {
    
    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var paswordField: UITextField!
    @IBOutlet weak var passwordCompareField: UITextField!
    
    override func viewDidLoad() {
        usernameField.setBottomBorder()
        paswordField.setBottomBorder()
        passwordCompareField.setBottomBorder()
        self.hideKeyboardWhenTappedAround()
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
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return UIInterfaceOrientationMask.portrait
    }
    
    override var shouldAutorotate: Bool {
        return false
    }
    
    @IBAction func hideKeyboard(_ sender: UITextField) {
        sender.resignFirstResponder()
    }
    
    @IBAction func login(){
        self.performSegue(withIdentifier: "login", sender: self)
    }

    
    @IBAction func moveFocus() {
        if usernameField.resignFirstResponder() {
            paswordField.becomeFirstResponder()
        } else if paswordField.resignFirstResponder() {
            passwordCompareField.becomeFirstResponder()
        }
    }
}
