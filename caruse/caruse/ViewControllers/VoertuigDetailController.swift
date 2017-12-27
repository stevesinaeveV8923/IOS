import UIKit


class VoertuigDetailController: UIViewController {
    
    @IBOutlet weak var merkField :UILabel!
    @IBOutlet weak var typeField :UILabel!
    @IBOutlet weak var imageField :UIImageView!
    @IBOutlet weak var regioField : UILabel!
    @IBOutlet weak var omschrijvingField :UILabel!
    @IBOutlet weak var gebruikerField: UILabel!
    
    var voertuig: Voertuig!
    
    override func viewDidLoad() {
        title = "\(voertuig.merk!) \(voertuig.type!)"
        self.merkField.text = voertuig.merk
        self.typeField.text = voertuig.type
        self.imageField.image = voertuig.convertImage()
        self.regioField.text = voertuig.regio
        self.omschrijvingField.text = voertuig.omschrijving
        self.omschrijvingField.numberOfLines = 0
        self.omschrijvingField.lineBreakMode = .byTruncatingTail
        self.omschrijvingField.minimumScaleFactor = 0.8
        self.gebruikerField.text = voertuig.username
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch  segue.identifier {
        case "addComment"?:
            let commentController = segue.destination as! CommentController
            commentController.voertuig = self.voertuig
        default:
            fatalError("Unknown segue")
        }
    }

    @IBAction func bekijkComments() {
        self.performSegue(withIdentifier: "addComment", sender: self)
    }
}
