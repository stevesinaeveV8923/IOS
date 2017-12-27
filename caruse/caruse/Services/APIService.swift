import Foundation
import ObjectMapper
import Alamofire
import SwiftyJSON
import SwiftKeychainWrapper


class APIService {
    static let sharedInstance = APIService()
    private let urlVoer : String =  "https://backendheroku.herokuapp.com/API/voertuigen"
    private let urlBericht: String = "https://backendheroku.herokuapp.com/API/berichten"
    private let token : String
    private let Auth_header: [String: String]
    private let username : String
    private let userId: String
//    private var manager: SessionManager
    
    private init() {
        self.token = "Bearer \(KeychainWrapper.standard.string(forKey: "token")!)"
        self.Auth_header = [ "Access-Control-Allow-Origin": "*","Access-Control-Allow-Headers": "Origin, X-Requested-With, Content-Type, Accept","Authorization" : self.token]
        self.username = KeychainWrapper.standard.string(forKey: "username")!
        self.userId = KeychainWrapper.standard.string(forKey: "userId")!
    }
    

    
    
    func AlleVoertuigen(completion: @escaping ([Voertuig]) -> Void) -> Void {

        Alamofire.request(urlVoer + "/all",method: .get, encoding: JSONEncoding.default, headers: self.Auth_header).validate()
            .responseJSON { response in
                //let statusCode = response.response?.statusCode
                switch response.result {
                case .success:
                    //if let value = response.result.value {
//                        let post = JSON(value)
//                        print(post)
//                        // mappen naar voertuig
//                        let json = response.result.value
                    guard let jsonArray = response.result.value as? Array<[String: AnyObject]> else { return }
                        
                    guard let voertuigen:[Voertuig] = Mapper<Voertuig>().mapArray(JSONArray: jsonArray ) else { print ("error with mapping")}
                        completion(voertuigen)
//                    }
                default : completion(Array<Voertuig>())
                }
        }
    }
    
    
    func AlleEigenVoertuigen(completion: @escaping ([Voertuig]) -> Void) -> Void {
        let urlVoertuigEigen = urlVoer + "/" + self.userId
        Alamofire.request(urlVoertuigEigen ,method: .get, encoding: JSONEncoding.default, headers: self.Auth_header).validate()
            .responseJSON { response in
                switch response.result {
                case .success:
                    guard let jsonArray = response.result.value as? Array<[String: AnyObject]> else { return }
                    
                    guard let voertuigen:[Voertuig] = Mapper<Voertuig>().mapArray(JSONArray: jsonArray ) else { print ("error with mapping")}
                    completion(voertuigen)
                //                    }
                default : completion(Array<Voertuig>())
                }
        }
    }
    
    func deleteVoertuig(_ voertuigId: String, completion: @escaping (Bool) -> Void) -> Void {
        let urlVoertuigVerwijder = urlVoer + "/" + voertuigId
        Alamofire.request(urlVoertuigVerwijder ,method: .delete, encoding: JSONEncoding.default, headers: self.Auth_header).validate()
            .responseJSON { response in
                switch response.result {
                case .success:
                    completion(true)
                case .failure : completion(false)
                }
        }
    }
    
    
    func editReview(review: Review, voertuigId: String, Completion: @escaping (Review) -> Void) -> Void {
        let parameters = [
            "_id": review._id!,
            "date": review.createdDateString!,
            "gebruiker": review.gebruiker!,
            "onderwerp": review.onderwerp!,
            "like": review.like!,
            "dislike": review.dislike!
            ] as [String : Any]
        
        let urlVoerReview = urlVoer + "/details/" + voertuigId + "/review"
        print(urlVoerReview)
        Alamofire.request(urlVoerReview , method: .put, parameters: parameters as? [String: Any], encoding: JSONEncoding.default, headers: self.Auth_header)
            .responseJSON { response in
                switch response.result {
                case .success:
                    guard let json = response.result.value as? [String: AnyObject] else { return }
                    
                    guard let rev:Voertuig = Mapper<Voertuig>().map(JSON: json) else {
                        print("error with mapping")
                        return
                    }
                    print(rev)
                    Completion((rev.reviews?.filter({ (r) -> Bool in
                        r._id == review._id})[0])!)
                case .failure(let error):
                    print(error)
                    Completion(Review())
                    
                }
        }
    }
    
    func addReview(omschrijving: String, voertuigId: String, Completion: @escaping (Review) -> Void) -> Void {
        let r = Review(onderwerp: omschrijving, gebruiker: username)
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let datum = formatter.string(from: r.date!)
        
        let parameters = [
            "date": datum,
            "gebruiker": r.gebruiker!,
            "onderwerp": r.onderwerp!,
            "like": r.like!,
            "dislike": r.dislike!
            ] as [String : Any]
        
        let urlVoerReview = urlVoer + "/details/" + voertuigId + "/review"
        print(urlVoerReview)
        Alamofire.request(urlVoerReview , method: .post, parameters: parameters as? [String: Any], encoding: JSONEncoding.default, headers: self.Auth_header)
            .responseJSON { response in
                switch response.result {
                case .success:
                    guard let json = response.result.value as? [String: AnyObject] else { return }
                    
                    guard let rev:Review = Mapper<Review>().map(JSON: json) else {
                        print("error with mapping")
                        return
                    }
                    print(rev)
                    Completion(rev)
                case .failure(let error):
                    print(error)
                    Completion(Review())
                    
                }
        }
    }
    
    
    func editVoertuig(voertuig: Voertuig, Completion: @escaping (Voertuig) -> Void) -> Void {

        let parameters = [
            "_id": voertuig._id!,
            "merk": voertuig.merk!,
            "type": voertuig.type!,
            "verhuurd": !voertuig.verhuurd!,
            "regio": voertuig.regio!,
            "omschrijving": voertuig.omschrijving!,
            "username" : voertuig.username!,
            "picture" : voertuig.picture!,
            "reviews" : voertuig.reviews!
            ] as [String : Any]
        
        let urlVoerEdit = urlVoer + "/" + voertuig._id!
        Alamofire.request(urlVoerEdit , method: .put, parameters: parameters as? [String: Any], encoding: JSONEncoding.default, headers: self.Auth_header)
            .responseJSON { response in
                switch response.result {
                case .success:
                    guard let json = response.result.value as? [String: AnyObject] else { return }
                    
                    guard let voer:Voertuig = Mapper<Voertuig>().map(JSON: json) else {
                        print("error with mapping")
                        return
                    }
                    print(voer)
                    Completion(voer)
                case .failure(let error):
                    print(error)
                    Completion(Voertuig())
                    
                }
        }
    }
    
    
    func addVoertuig(voertuig: Voertuig, Completion: @escaping (Voertuig) -> Void) -> Void {
        
        let parameters = [
            "merk": voertuig.merk!,
            "type": voertuig.type!,
            "verhuurd": !voertuig.verhuurd!,
            "regio": voertuig.regio!,
            "omschrijving": voertuig.omschrijving!,
            "username" : voertuig.username!,
            "picture" : voertuig.picture!,
            "reviews" : voertuig.reviews!
            ] as [String : Any]
        
        let urlVoerAdd = urlVoer + "/add"
        Alamofire.request(urlVoerAdd , method: .post, parameters: parameters as? [String: Any], encoding: JSONEncoding.default, headers: self.Auth_header)
            .responseJSON { response in
                switch response.result {
                case .success:
                    guard let json = response.result.value as? [String: AnyObject] else { return }
                    
                    guard let voer:Voertuig = Mapper<Voertuig>().map(JSON: json) else {
                        print("error with mapping")
                        return
                    }
                    print(voer)
                    Completion(voer)
                case .failure(let error):
                    print(error)
                    Completion(Voertuig())
                    
                }
        }
    }

}



