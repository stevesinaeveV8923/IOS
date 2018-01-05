import UIKit

class EmptyViewController: UIViewController {
    
    override func viewDidLoad() {
        navigationItem.leftBarButtonItem = splitViewController!.displayModeButtonItem
    }
}
