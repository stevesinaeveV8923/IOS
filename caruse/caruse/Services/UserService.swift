import Foundation
import ObjectMapper
import Alamofire
import SwiftyJSON
import SwiftKeychainWrapper

class UserService {
    static let sharedInstance = UserService()
    private let url : String =  "https://backendheroku.herokuapp.com/"
    
    private init() {}
    
    
    func logIn(username u: String, password p: String, completion: @escaping (Bool) -> Void) -> Void {
        let parameters = [
            "username": u, //email
            "password": p //password
        ]
        Alamofire.request(url + "login", method: .post, parameters: parameters as? [String: Any], encoding: JSONEncoding.default, headers: [:])
            .responseJSON { response in
                let statusCode = response.response?.statusCode
                switch statusCode {
                case 200?:
                    if let value = response.result.value {
                        let post = JSON(value)
                        self.saveToken(post)
                        completion(true)
                    }
                default : completion(false)
                }
        }
    }
    
    
    
    func registreer(username u: String, password p: String, completion: @escaping (Bool) -> Void) {
        let parameters = [
            "username": u, //email
            "password": p //password
        ]
        Alamofire.request(url + "register", method: .post, parameters: parameters as? [String: Any], encoding: JSONEncoding.default, headers: [:])
            .responseJSON { response in
                let statusCode = response.response?.statusCode
                switch statusCode {
                case 200?:
                    if let value = response.result.value {
                        let post = JSON(value)
                        self.saveToken(post)
                        completion(true)
                    }
                default : completion(false)
                }
        }
    }
    
    
    
    private func saveToken(_ post: JSON) {
        if let key = post["token"].string, let userid = post["userId"].string {
            KeychainWrapper.standard.set(key, forKey: "token")
            KeychainWrapper.standard.set(userid, forKey: "userId")
            print(KeychainWrapper.standard.string(forKey: "token")!)
        } else {
            print("error detected")
        }
    }

}
