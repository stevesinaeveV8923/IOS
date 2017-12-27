import UIKit


class EigenController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    private var voertuigen : [Voertuig] = []
    private var voorlopigVoertuig: Int = 0
    
    override func viewDidLoad() {
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
            let voertuigHuurController = segue.destination as! VoertuigHuurController
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
        cell.voertuig = voertuigen[indexPath.row]
        return cell
    }
}
