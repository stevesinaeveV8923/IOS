import Foundation
import ObjectMapper

class Review: Mappable{
    
    var _id : String?
    var like: [String]?
    var dislike: [String]?
    var onderwerp: String?
    var gebruiker: String?
    var createdDateString: String?
    var date: Date?
    
    init(onderwerp: String, gebruiker: String){
        self.like = Array<String>()
        self.dislike = Array<String>()
        self.onderwerp = onderwerp
        self.gebruiker = gebruiker
        self.date = Date()
    }
    
    required init?(map: Map) {
        
    }
    
    init(){
        
    }
    
    func mapping(map: Map) {
        self.like <- map["like"]
        self.dislike <- map["dislike"]
        self.onderwerp <- map["onderwerp"]
        self.gebruiker <- map["gebruiker"]
        self.createdDateString <- map["date"]
        
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        let date = dateFormatter.date(from: createdDateString!)

        self.date = date
        self._id <- map["_id"]
    }
    
}
