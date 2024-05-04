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
    
    
    var db: Firestore!
    var user: User? // Keep a reference to the current user

    override func viewDidLoad() {
        super.viewDidLoad()
        db = Firestore.firestore()
        // Do any additional setup after loading the view.
        
        // Ensure anonymous authentication
        authenticateAnonymously()
    }
    
    func authenticateAnonymously() {
        Auth.auth().signInAnonymously { (authResult, error) in
            if let error = error {
                print("Error authenticating anonymously: \(error.localizedDescription)")
            } else {
                // Anonymous authentication successful
                self.user = authResult?.user
                
                // Fetch user data
                self.fetchnSetUserData()
            }
        }
    }

    func fetchnSetUserData() {
        guard let currentUser = Auth.auth().currentUser else {
            print("User not authenticated")
            return
        }

        let userId = currentUser.uid
        print("Current User: \(currentUser)")
        
        db.collection("users").getDocuments { (document, error) in
            if let document = document, !document.isEmpty {
                let userData = document.documents[0].data()
                if let name = userData["name"] as? String,
                   let phone = userData["phone"] as? String,
                   let email = userData["email"] as? String,
                   let weight = userData["weight"] as? Double,
                   let height = userData["height"] as? Double {
                                        
                    print("Name: \(name)")
                    print("Phone: \(phone)")
                    print("Email: \(email)")
                    print("Weight: \(weight)")
                    print("Height: \(height)")
                    
                    self.nameField.text = name
                    self.phoneField.text = phone
                    self.emailField.text = email
                    self.weightField.text = String(weight)
                    self.heightField.text = String(height)
        
                } else {
                    print("Error: Missing or invalid data in document")
                }
            } else {
                print("User document does not exist or is empty")
            }
        }
    }
    
    
    
    
    
    
    

        
        @IBAction func doneBtn(_ sender: Any) {
            guard let currentUser = Auth.auth().currentUser else {
                print("User not authenticated")
                return
            }

            let userId = currentUser.uid

            let userData: [String: Any] = [
                "name": nameField.text ?? "",
                "phone": phoneField.text ?? "",
                "email": emailField.text ?? "",
                "height": heightField.text ?? "",
                "weight": weightField.text ?? ""
            ]

            print("NameField: \(nameField.text)")
            print("PhoneField: \(phoneField.text)")
            print("EmailField: \(emailField.text)")
            print("HeightField: \(heightField.text)")
            print("WeightField: \(weightField.text)")

            let userDocRef = db.collection("users").document(userId)
                userDocRef.updateData(userData) { error in
                    if let error = error {
                        print("Error updating document: \(error)")
                    } else {
                        print("Document successfully updated")
                        // Dismiss the edit view controller
                        self.dismiss(animated: true, completion: nil)
                    }
                }
            
//            guard let currentUser = self.currentUser else {
//                print("User not authenticated")
//                return
//            }
//            
//            let userId = currentUser.uid
//
//            db.collection("users").document(userId).updateData([
//                "name": nameField.text ?? "",
//                "phone": phoneField.text ?? "",
//                "email": emailField.text ?? "",
//                "height": heightField.text ?? "",
//                "weight": weightField.text ?? ""
//            ]) { error in
//                if let error = error {
//                    print("Error updating document: \(error)")
//                } else {
//                    print("Document successfully updated")
//                    // Dismiss the edit view controller
//                    self.dismiss(animated: true, completion: nil)
//                }
//            }
            
            
        
            
//            let currentUser = self.currentUser
//
//            db.collection("users").document(currentUser).updateData([
//                "name": nameField.text ?? "",
//                "phone": phoneField.text ?? "",
//                "email": emailField.text ?? "",
//                "height": heightField.text ?? "",
//                "weight": weightField.text ?? ""
//            ]) { error in
//                if let error = error {
//                    print("Error updating document: \(error)")
//                } else {
//                    print("Document successfully updated")
//                    // Dismiss the edit view controller
//                    self.dismiss(animated: true, completion: nil)
//                }
//            }
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
