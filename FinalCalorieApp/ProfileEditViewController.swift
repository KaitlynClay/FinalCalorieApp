//
//  ProfileEditViewController.swift
//  FinalCalorieApp
//
//  Created by student on 3/23/24.
//

import UIKit
import Firebase
import FirebaseFirestore
import FirebaseCore
import FirebaseFirestore
import FirebaseAuth

class ProfileEditViewController: UIViewController {
    
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var phoneField: UITextField!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var heightField: UITextField!
    @IBOutlet weak var weightField: UITextField!
    
//    var currentUser: User?
    var db: Firestore!
    var currentUser = "vhmNgwxzjjW56I92gGfRxtEG7nC2"
    

    
//    Current User: <FIRUser: 0x600002c06000>
//    PEVC Current User: Optional("vhmNgwxzjjW56I92gGfRxtEG7nC2")


    override func viewDidLoad() {
        super.viewDidLoad()
        db = Firestore.firestore()
        print("PEVC Current User: \(currentUser)")

        fetchUserData(userId: currentUser)
        
    }

    func fetchUserData(userId: String) {
        db.collection("users").document(userId).getDocument { (document, error) in
            if let document = document, document.exists {
                let userData = document.data()
                self.nameField.text = userData?["name"] as? String ?? ""
                self.phoneField.text = userData?["phone"] as? String ?? ""
                self.emailField.text = userData?["email"] as? String ?? ""
                self.fetchHeightAndWeightFromFirestore(userData: userData)
            } else {
                print("Document does not exist")
            }
        }
    }

    func fetchHeightAndWeightFromFirestore(userData: [String: Any]?) {
        guard let userData = userData else { return }
        self.heightField.text = userData["height"] as? String ?? ""
        self.weightField.text = userData["weight"] as? String ?? ""
        
    }

        
        @IBAction func doneBtn(_ sender: Any) {
            let currentUser = self.currentUser

            db.collection("users").document(currentUser).updateData([
                "name": nameField.text ?? "",
                "phone": phoneField.text ?? "",
                "email": emailField.text ?? "",
                "height": heightField.text ?? "",
                "weight": weightField.text ?? ""
            ]) { error in
                if let error = error {
                    print("Error updating document: \(error)")
                } else {
                    print("Document successfully updated")
                    // Dismiss the edit view controller
                    self.dismiss(animated: true, completion: nil)
                }
            }
        }

    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
