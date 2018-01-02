import Foundation
import SwiftyJSON
import ObjectMapper

class Voertuig: Mappable {
    var _id: String?
    var _userId: String?
    var merk: String?
    var type: String?
    var verhuurd: Bool?
    var regio: String?
    var omschrijving: String?
    var username: String?
    var picture: String?
    var reviews: [Review]?
    
    init(merk: String, type: String, regio: String, omschrijving: String, username: String, userId: String) {
        self.merk = merk
        self.type = type
        self.regio = regio
        self.omschrijving = omschrijving
        self.verhuurd = false
        self.username = username
        self.reviews = Array<Review>()
        self.picture = ""
        self._userId = userId
        
    }
    
    required init?(map: Map) {
        
    }
    
    init(){
        
    }
    
    func mapping(map: Map) {
        self.merk <- map["merk"]
        self.type <- map["type"]
        self.regio <- map["regio"]
        self.omschrijving <- map["omschrijving"]
        self.verhuurd <- map["verhuurd"]
        self.username <- map["username"]
        self._id <- map["_id"]
        self._userId <- map["user"]
        self.reviews <- map["reviews"]
        self.picture <- map["picture"]
    }
    
    func convertImage() -> UIImage {
            let dataDecoded : Data = Data(base64Encoded: self.picture!, options: .ignoreUnknownCharacters)!
            return UIImage(data: dataDecoded)!
    }
    
    func imageToString(_ image: Data) -> Void {
        if (picture?.isEmpty) != nil {
            self.picture = image.base64EncodedString(options: .lineLength64Characters)
        }
    }
}
