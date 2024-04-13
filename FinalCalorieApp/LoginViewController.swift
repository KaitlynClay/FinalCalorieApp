//
//  LoginViewController.swift
//  FinalCalorieApp
//
//  Created by student on 3/23/24.
//

import UIKit
import Firebase
import FirebaseFirestore

class LoginViewController: UIViewController {
    
    @IBOutlet weak var userNameEntry: UITextField!
    @IBOutlet weak var userPhoneNumEntry: UITextField!
    @IBOutlet weak var userEmailEntry: UITextField!
    
    var name: String?
    var phone: String?
    var email: String?
    
    var db: Firestore!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        db = Firestore.firestore()
        // Do any additional setup after loading the view.
    }
    

    @IBAction func nexttoBMIBtn(_ sender: Any) {
        guard let name = userNameEntry.text,
              let phone = userPhoneNumEntry.text,
              let email = userEmailEntry.text else {
            print("One or more text fields are nil")
            return
        }
        
        // Save name, phone number, email to variables
        self.name = name
        self.phone = phone
        self.email = email
        
        // Perform signup with Firebase Authentication
        Auth.auth().createUser(withEmail: email, password: phone) { authResult, error in
            if let error = error {
                print("Error signing up: \(error.localizedDescription)")
                // Handle signup failure (e.g., display error message to the user)
            } else {
                // Signup successful
                if let user = authResult?.user {
                    // Additional signup steps (e.g., save username to database)
                    self.saveUserToDatabase(user: user, username: name)
                    print("User: \(user)")
                    
                    // Proceed to BMIViewController
                    self.performSegue(withIdentifier: "ToBMIViewController", sender: nil)
                }
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ToBMIViewController" {
            if let bmiVC = segue.destination as? BMIViewController {
                bmiVC.name = self.name
                bmiVC.phone = self.phone
                bmiVC.email = self.email
            }
        }
    }
    
    func saveUserToDatabase(user: User, username: String) {
        // Save the username to the database (you can use Firestore or Realtime Database)
        // Example: Firestore
        let db = Firestore.firestore()
        db.collection("users").document(user.uid).setData(["username": username])
        print("Username: \(username)")
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
