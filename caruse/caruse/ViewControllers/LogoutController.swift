import UIKit

class LogoutController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func logout() {
        UserService.sharedInstance.logout(){
            response in
            let geslaagd = response
            if geslaagd {
                self.performSegue(withIdentifier: "logout", sender: self)
            }
        }
    }
}

