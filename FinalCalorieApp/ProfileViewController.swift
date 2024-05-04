//
//  ProfileViewController.swift
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

class ProfileViewController: UIViewController {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var phoneLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var bmiLabel: UILabel!
    @IBOutlet weak var weightLabel: UILabel!
    @IBOutlet weak var heightLabel: UILabel!
    
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
                    
                    let bmi = (weight / (height * height)) * 703
                    
                    self.nameLabel.text = name
                    self.phoneLabel.text = phone
                    self.emailLabel.text = email
                    self.weightLabel.text = String(weight)
                    self.heightLabel.text = String(height)
                    
                    self.nameLabel.text = name
                    self.phoneLabel.text = phone
                    self.emailLabel.text = email
                    self.bmiLabel.text = String(format: "%.1f", bmi)
                    self.heightLabel.text = String(height)
                    self.weightLabel.text = String(weight)
        
                } else {
                    print("Error: Missing or invalid data in document")
                }
            } else {
                print("User document does not exist or is empty")
            }
        }
    }
    
    func calculateBMI(weight: Double, height: Double) {
        // Calculate BMI using the provided formula: weight(lb) / [height(in)]^2 * 703
        let bmi = (weight / (height * height)) * 703
        
        print(bmi)
        
        self.bmiLabel.text = String(format: "%.1f", bmi)
    }

    @IBAction func editBtn(_ sender: Any) {
        let profileEditVC = ProfileEditViewController()
//        profileEditVC.currentUser = self.user
    }
        
    
    @IBAction func unwindToProfile(_ sender: UIStoryboardSegue) {}

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
