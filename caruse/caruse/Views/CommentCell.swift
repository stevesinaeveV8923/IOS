import UIKit
import SwiftKeychainWrapper

class CommentCell: UITableViewCell {
    
    @IBOutlet weak var datumField :UILabel!
    @IBOutlet weak var onderwerpField :UILabel!
    @IBOutlet weak var likeField :UILabel!
    @IBOutlet weak var dislikeField :UILabel!
    @IBOutlet weak var gebruikerField :UILabel!

    
    var review: Review! {
        didSet {
            self.instellenParam(review)
        }
    }
    
    var voertuigId: String!
    
    @IBAction func liken(){
        var waar = false;
        let userId = KeychainWrapper.standard.string(forKey: "userId")!
        review.like?.forEach({ (r) in
            if r == userId {
                waar = true ;
            }
        })
        if waar {
            let plaats = review.like?.index(of: userId)!
            review.like?.remove(at: plaats!)
        } else {
            review.like?.append(userId)
        }
        print("voertuigid \(voertuigId)")
        APIService.sharedInstance.editReview(review: review, voertuigId: voertuigId) { (r) in
            self.instellenParam(r)
        }
        
    }
    
    @IBAction func disliken(){
        var waar = false;
        let userId = KeychainWrapper.standard.string(forKey: "userId")!
        review.dislike?.forEach({ (r) in
            if r == userId {
                waar = true ;
            }
        })
        if waar {
            let plaats = review.dislike?.index(of: userId)!
            review.dislike?.remove(at: plaats!)
        } else {
            review.dislike?.append(userId)
        }
        print("voertuigid \(voertuigId)")
        APIService.sharedInstance.editReview(review: review, voertuigId: voertuigId) { (r) in
            self.instellenParam(r)
        }
    }
    
    func instellenParam(_ rev: Review){
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let datum = formatter.string(from: rev.date!)
        gebruikerField.text = rev.gebruiker
        datumField.text = datum
        onderwerpField.text = rev.onderwerp
        likeField.text = String(rev.like!.count)
        dislikeField.text = String(rev.dislike!.count)
        self.loadReview()
    }
    
    
    func loadReview() {
        APIService.sharedInstance.AlleVoertuigen { (v) in
            self.review = v.filter({ (voer) -> Bool in
                voer._id == self.voertuigId
            })[0].reviews?.filter({ (rev) -> Bool in
                rev._id == self.review._id
            })[0]
        }
    }
}


