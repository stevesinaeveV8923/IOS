import UIKit


class EigenController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    private var voertuigen : [Voertuig] = []
    private var voorlopigVoertuig: Int = 0
    
    override func viewDidLoad() {
        splitViewController!.delegate = self
        APIService.sharedInstance.AlleEigenVoertuigen {
            (v) in
            self.voertuigen = v
            self.tableView.reloadData()
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch  segue.identifier {
        case "addVoertuig"?:
            break
        case "showDetail"?:
            let voertuigHuurController = (segue.destination as! UINavigationController).topViewController as! VoertuigHuurController
            let selection = tableView.indexPathForSelectedRow!
            voorlopigVoertuig = selection.row
            voertuigHuurController.voertuig = self.voertuigen[selection.row]
            tableView.deselectRow(at: selection, animated: true)
        default:
            fatalError("Unknown segue")
        }
    }
    
    @IBAction func unwindFromVoertuig(_ segue: UIStoryboardSegue) {
        switch segue.identifier {
        case "didAddVoertuig"?:
            let addVoertuigController = segue.source as! AddVoertuigController
            APIService.sharedInstance.addVoertuig(voertuig: addVoertuigController.voertuig!, Completion: { (voertuig) in
                self.voertuigen.append(voertuig)
                self.tableView.insertRows(at: [IndexPath(row: self.voertuigen.count - 1, section: 0)], with: .automatic)
                
                if self.checkwidth() {
                    self.tableView.selectRow(at: NSIndexPath(row: self.voertuigen.count - 1, section: 0) as IndexPath, animated: true, scrollPosition: .bottom)
                    self.performSegue(withIdentifier: "showDetail", sender: self)
                }
                let bericht = "Voertuig \(voertuig.merk!) \(voertuig.type!) is toegevoegd"
                let alert = UIAlertController(title: "Update", message: bericht, preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "sluit", style: UIAlertActionStyle.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            })
        case "didEditVoertuig"?:
            let voertuigHuurController = segue.source as! VoertuigHuurController
            self.voertuigen.remove(at: voorlopigVoertuig)
            self.voertuigen.insert(voertuigHuurController.voertuig, at: voorlopigVoertuig)
            self.tableView.reloadData()
        default:
            fatalError("Unkown segue")
        }
    }
    
    
    
    func checkwidth() -> Bool {
        
        let width = UIScreen.main.bounds.size.width
        
        return (width > 700)
    }
}

extension EigenController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: "Verwijder") {
            (action, view, completionHandler) in
            let voerVerwijder = self.voertuigen[indexPath.row]
            let voer = self.voertuigen.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
            APIService.sharedInstance.deleteVoertuig(voerVerwijder._id!) { (response) in
                let geslaagd = response
                if !geslaagd {
                    self.voertuigen.append(voer)
                }
            }
            completionHandler(true)
        }
        return UISwipeActionsConfiguration(actions: [deleteAction])
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 250
    }
}



extension EigenController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return voertuigen.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "detailsVoertuig", for: indexPath) as! VoertuigCell
        cell.picture.roundCorners([.topLeft, .topRight], radius: 20.0)
        cell.cellView.layer.cornerRadius = 20.0
        cell.voertuig = voertuigen[indexPath.row]
        return cell
    }
}

extension EigenController: UISplitViewControllerDelegate {
    
    func splitViewController(_ splitViewController: UISplitViewController, collapseSecondary secondaryViewController: UIViewController, onto primaryViewController: UIViewController) -> Bool {
        let showingProjects = (secondaryViewController as? UINavigationController)?.topViewController is VoertuigDetailController
        return !showingProjects
    }
}
