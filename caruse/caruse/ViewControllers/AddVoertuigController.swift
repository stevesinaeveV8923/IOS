import UIKit
import SwiftKeychainWrapper

class AddVoertuigController: UIViewController,UINavigationControllerDelegate,  UIImagePickerControllerDelegate {
    
    @IBOutlet weak var merkField :UITextField!
    @IBOutlet weak var typeField :UITextField!
    @IBOutlet weak var regioField : UITextField!
    @IBOutlet weak var omschrijvingField :UITextField!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    
    var imagePickerController : UIImagePickerController! = UIImagePickerController()
    
    var voertuig: Voertuig!
    var username: String = ""
    var foto: UIImage = UIImage()
    
    override func viewDidLoad() {
        imagePickerController.delegate = self
        self.username = KeychainWrapper.standard.string(forKey: "username")!
    }
    
    @IBAction func save() {
        voertuig = Voertuig(merk: merkField.text!, type: typeField.text!, regio: regioField.text!, omschrijving: omschrijvingField.text!, username: username)
        voertuig.imageToString(UIImagePNGRepresentation(self.foto)!)
        print(voertuig.picture ?? "we shall see")
        if voertuig != nil {
            performSegue(withIdentifier: "didAddVoertuig", sender: self)
        }
    }
    
    @IBAction func hideKeyboard(_ sender: UITextField) {
        sender.resignFirstResponder()
    }
    
    @IBAction func moveFocus() {
        if merkField.resignFirstResponder() {
            typeField.becomeFirstResponder()
        } else if typeField.resignFirstResponder() {
            regioField.becomeFirstResponder()
        } else if regioField.resignFirstResponder() {
            omschrijvingField.becomeFirstResponder()
        }
    }


    
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        switch segue.identifier {
//        case "didAddVoertuig"?:
//            voertuig = Voertuig(merk: merkField.text!, type: typeField.text!, regio: regioField.text!, omschrijving: omschrijvingField.text!, username: username)
//            voertuig.imageToString(UIImagePNGRepresentation(self.foto)!)
//            print(voertuig.picture ?? "we shall see")
//        default:
//            fatalError("Unknown segue")
//        }
//    }
    
    @IBAction func onPhotoButton(_ sender: Any) {

        imagePickerController.sourceType = .camera
        present(imagePickerController, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        imagePickerController.dismiss(animated: true, completion: nil)
        self.foto = (info[UIImagePickerControllerOriginalImage] as? UIImage)!
        
    }
}

extension AddVoertuigController: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if let text = merkField.text {
            let oldText = text as NSString
            let newText = oldText.replacingCharacters(in: range, with: string)
            saveButton.isEnabled = newText.count > 0
        } else {
            saveButton.isEnabled = string.count > 0 
        }
        return true
    }
}

