import UIKit


class CommentController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var omschrijvingText: UITextField!
    var refreshControl = UIRefreshControl()
    
    var voertuig: Voertuig!
    
    private var indexPathToEdit: IndexPath!
    
    override func viewDidLoad() {
        omschrijvingText.setBottomBorder()
        self.hideKeyboardWhenTappedAround()
        self.refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        self.refreshControl.addTarget(self, action: #selector(refresh(_:)), for: UIControlEvents.valueChanged)
        self.tableView?.addSubview(refreshControl)
        
        title = "\(voertuig.merk!) \(voertuig.type!)"
        self.tableView.reloadData()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
    }
    
    @objc func refresh(_ sender:AnyObject) {
        self.loadVoertuigen()
    }
    
    func loadVoertuigen() {
        APIService.sharedInstance.AlleVoertuigen { (v) in
            self.voertuig = v.filter({ (voer) -> Bool in
                voer._id == self.voertuig._id
            })[0]
            if self.refreshControl.isRefreshing
            {
                self.refreshControl.endRefreshing()
            }
            
            self.tableView?.reloadData()
        }
    }
    
    @IBAction func hideKeyboard(_ sender: UITextField) {
        sender.resignFirstResponder()
    }
    
    @IBAction func addComment() {
        APIService.sharedInstance.addReview(omschrijving: self.omschrijvingText.text!, voertuigId: voertuig._id!) { (r) in
            self.omschrijvingText.text = ""
            self.voertuig.reviews?.append(r)
            self.tableView.reloadData()
        }
    }
}

extension CommentController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print(voertuig.reviews!.count)
        print("test")
        return voertuig.reviews!.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "commentCell", for: indexPath) as! CommentCell
        print("test2")
        print(voertuig.reviews![indexPath.row])
        cell.review = voertuig.reviews![indexPath.row]
        cell.viewCell.layer.cornerRadius = 20.0
        cell.voertuigId = voertuig._id
        return cell
    }
}

