import UIKit


class OverzichtController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var voertuigen: [Voertuig] = []
    var refreshControl = UIRefreshControl()
    private var indexPathToEdit: IndexPath!
    

    
    override func viewDidLoad() {
        self.refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        self.refreshControl.addTarget(self, action: #selector(refresh(_:)), for: UIControlEvents.valueChanged)
        self.tableView?.addSubview(refreshControl)

        
        
        APIService.sharedInstance.AlleVoertuigen { (voertuigen) in
            self.voertuigen = voertuigen
            self.tableView.reloadData()
        }
    }

    @objc func refresh(_ sender:AnyObject) {
        self.loadVoertuigen()
    }
    
    func loadVoertuigen() {
        APIService.sharedInstance.AlleVoertuigen { (voertuigen) in
            self.voertuigen = voertuigen
            // tell refresh control it can stop showing up now
            if self.refreshControl.isRefreshing
            {
                self.refreshControl.endRefreshing()
            }
            
            self.tableView?.reloadData()
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch  segue.identifier {
        case "showDetailPage"?:
            let voertuigdetail = segue.destination as! VoertuigDetailController
            let selection = tableView.indexPathForSelectedRow!
            voertuigdetail.voertuig = voertuigen[selection.row]
            tableView.deselectRow(at: selection, animated: true)
        default:
            fatalError("Unknown segue")
        }
    }
}

extension OverzichtController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return voertuigen.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "voertuigCell", for: indexPath) as! VoertuigCell
        cell.voertuig = voertuigen[indexPath.row]
        return cell
    }
}
