import UIKit
import SwiftKeychainWrapper

class CommentCell: UITableViewCell {
    
    @IBOutlet weak var datumField :UILabel!
    @IBOutlet weak var onderwerpField :UILabel!
    @IBOutlet weak var likeField :UILabel!
    @IBOutlet weak var dislikeField :UILabel!
    @IBOutlet weak var gebruikerField :UILabel!
    @IBOutlet weak var viewCell: UIView!

    
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
            self.likeField.text = String(self.review.like!.count)
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
            self.dislikeField.text = String(self.review.dislike!.count)
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
    }
}


