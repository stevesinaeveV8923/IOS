import UIKit

class VoertuigCell: UITableViewCell {
    
    @IBOutlet weak var merkLabel: UILabel!
    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var regioLabel: UILabel!
    @IBOutlet weak var picture: UIImageView!
    
    var voertuig: Voertuig! {
        didSet {
            merkLabel.text = voertuig.merk
            typeLabel.text = voertuig.type
            regioLabel.text = voertuig.regio
            picture.image = voertuig.convertImage()
        }
    }
}

