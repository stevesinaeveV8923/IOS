import UIKit
import SwiftKeychainWrapper

class AddVoertuigController: UITableViewController,UINavigationControllerDelegate,  UIImagePickerControllerDelegate {
    
    @IBOutlet weak var merkField :UITextField!
    @IBOutlet weak var typeField :UITextField!
    @IBOutlet weak var regioField : UITextField!
    @IBOutlet weak var omschrijvingField :UITextField!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    
    var imagePickerController : UIImagePickerController! = UIImagePickerController()
    
    var voertuig: Voertuig!
    var username: String = ""
    var userId: String = ""
    var foto: UIImage?
    
    override func viewDidLoad() {
        self.hideKeyboardWhenTappedAround()
        imagePickerController.delegate = self
        self.textFieldsIngevuld()
        self.username = KeychainWrapper.standard.string(forKey: "username")!
        self.userId = KeychainWrapper.standard.string(forKey: "userId")!
    }
    
    @IBAction func save() {
        voertuig = Voertuig(merk: merkField.text!, type: typeField.text!, regio: regioField.text!, omschrijving: omschrijvingField.text!, username: username, userId: userId )
        if self.foto === nil {
            voertuig.imageToString(UIImagePNGRepresentation(UIImage(named: "LOGO")!)!)
        } else {
            voertuig.imageToString(UIImagePNGRepresentation(self.foto!)!) // duurt zeer lang! --> kan het efficiënter?
        }
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

    
    @IBAction func onPhotoButton(_ sender: Any) {

        imagePickerController.sourceType = .camera
        present(imagePickerController, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        self.foto = (info[UIImagePickerControllerOriginalImage] as? UIImage)!
        imagePickerController.dismiss(animated: true, completion: nil)
    }
    
    func textFieldsIngevuld() {
        saveButton.isEnabled = false
        merkField.addTarget(self, action: #selector(textFieldsControle),
                                    for: .editingChanged)
        typeField.addTarget(self, action: #selector(textFieldsControle),
                                     for: .editingChanged)
        regioField.addTarget(self, action: #selector(textFieldsControle),
                                        for: .editingChanged)
        omschrijvingField.addTarget(self, action: #selector(textFieldsControle),
                                              for: .editingChanged)
    }
    
    @objc func textFieldsControle(_ tf: UITextField) {
        
        tf.text = tf.text?.trimmingCharacters(in: .whitespaces)
        
        guard
            let merk = merkField.text, !merk.isEmpty,
            let type = typeField.text, !type.isEmpty,
            let regio = regioField.text, !regio.isEmpty,
            let omschrijving = omschrijvingField.text, !omschrijving.isEmpty
            else
        {
            saveButton.isEnabled = false
            return
        }
        saveButton.isEnabled = true
    }
}

