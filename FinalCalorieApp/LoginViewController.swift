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
    
    @IBOutlet weak var userWeightEntry: UITextField!
    @IBOutlet weak var userHeightEntry: UITextField!
    
    
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
        guard let name = userNameEntry?.text,
              let phone = userPhoneNumEntry?.text,
              let email = userEmailEntry?.text else {
            print("One or more text fields are nil")
            return
        }

        // Save name, phone number, email, weight, and height to variables
        self.name = name
        self.phone = phone
        self.email = email
    }
//    
    
    @IBAction func loginBtn(_ sender: Any) {
        guard let name = self.name,
              let phone = self.phone,
              let email = self.email,
              let weightText = userWeightEntry?.text,
              let weight = Double(weightText),
              let heightText = userHeightEntry?.text,
              let height = Double(heightText) else {
            print("userNameEntry:", self.name)
            print("userPhoneNumEntry:", self.phone)
            print("userEmailEntry:", self.email)
            print("userWeightEntry:", userWeightEntry?.text)
            print("userHeightEntry:", userHeightEntry?.text)
    
            print("One or more text fields are nil or empty")
            return
        }

        // Proceed with adding data to Firestore
        let userData: [String: Any] = [
            "name": name,
            "phone": phone,
            "email": email,
            "weight": weight,
            "height": height
        ]

        db.collection("users").addDocument(data: userData) { error in
            if let error = error {
                print("Error adding document: \(error)")
            } else {
                print("Document added successfully!")
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
