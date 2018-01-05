
import UIKit


class VoertuigHuurController: UIViewController {
    
    @IBOutlet weak var merkField :UILabel!
    @IBOutlet weak var typeField :UILabel!
    @IBOutlet weak var verhuurdField :UILabel!
    @IBOutlet weak var verhuurdButton : UIButton!
    
    var voertuig: Voertuig!
    var verhuurd: Bool = false
    
    override func viewDidLoad() {
        title = "\(voertuig.merk!) \(voertuig.type!)"
        self.merkField.text = voertuig.merk
        self.typeField.text = voertuig.type
        self.reload(voer: self.voertuig)
    }
    
    @IBAction func verhuurAuto() {
        APIService.sharedInstance.editVoertuig(voertuig: voertuig) { (voer) in
            let voert = voer
            if voert.merk != nil {
                self.voertuig = voert
                self.reload(voer: self.voertuig)
                self.performSegue(withIdentifier: "didEditVoertuig", sender: self)

            }
        }
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        if !splitViewController!.isCollapsed {
            navigationItem.leftBarButtonItem = splitViewController!.displayModeButtonItem
        }
    }
    
    
    private func reload(voer: Voertuig) {
        self.verhuurd = voer.verhuurd!
        if self.verhuurd {
            self.verhuurdField.text = "Auto wordt momenteel verhuurd"
            self.verhuurdButton.setTitle("Beschikbaar", for: .normal)
        } else {
            self.verhuurdField.text = "Niet verhuurd"
            self.verhuurdButton.setTitle("Verhuur auto", for: .normal)
        }
    }
}
