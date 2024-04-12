//
//  BMIViewController.swift
//  FinalCalorieApp
//
//  Created by student on 4/11/24.
//

import UIKit
import Firebase
import FirebaseFirestore

class BMIViewController: UIViewController {
    
    @IBOutlet weak var userWeightEntry: UITextField!
    @IBOutlet weak var userHeightEntry: UITextField!
    
    var name: String?
    var phone: String?
    var email: String?
    var weight: Double?
    var height: Double?

    var db: Firestore!

    override func viewDidLoad() {
        super.viewDidLoad()
        db = Firestore.firestore()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func loginBtn(_ sender: Any) {
        guard let weightText = userWeightEntry.text,
              let weight = Double(weightText),
              let heightText = userHeightEntry.text,
              let height = Double(heightText),
              let name = self.name,
              let phone = self.phone,
              let email = self.email else {
            print("One or more text fields are nil")
            return
        }

        // Save weight and height to variables
        self.weight = weight
        self.height = height

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
