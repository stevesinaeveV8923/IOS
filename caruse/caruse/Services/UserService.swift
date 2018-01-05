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
            "username": u,
            "password": p
        ]
        Alamofire.request(url + "login", method: .post, parameters: parameters as? [String: Any], encoding: JSONEncoding.default, headers: [:])
            .responseJSON { response in
                let statusCode = response.response?.statusCode
                switch statusCode {
                case 200?:
                    if let value = response.result.value {
                        let post = JSON(value)
                        self.saveToken(post)
                        KeychainWrapper.standard.set(parameters["username"]!, forKey: "username")
                        completion(true)
                    }
                default : completion(false)
                }
        }
    }
    
    func logout(completion: @escaping (Bool) -> Void) -> Void {
        Alamofire.request(url + "logout", method: .post, parameters: [:], encoding: JSONEncoding.default, headers: [:])
            .responseJSON { response in
                switch response.result {
                case .success:
                        KeychainWrapper.standard.set("", forKey: "token")
                        KeychainWrapper.standard.set("", forKey: "userId")
                        KeychainWrapper.standard.set("", forKey: "username")
                        completion(true)
                case .failure(let error) :
                    print(error)
                    completion(false)
                }
        }
    }
    
    
    
    func registreer(username u: String, password p: String, completion: @escaping (Bool) -> Void) {
        let parameters = [
            "username": u,
            "password": p 
        ]
        Alamofire.request(url + "register", method: .post, parameters: parameters as? [String: Any], encoding: JSONEncoding.default, headers: [:])
            .responseJSON { response in
                let statusCode = response.response?.statusCode
                switch statusCode {
                case 200?:
                    if let value = response.result.value {
                        let post = JSON(value)
                        self.saveToken(post)
                        KeychainWrapper.standard.set(parameters["username"]!, forKey: "username")
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
        } else {
            print("error detected")
        }
    }

}
