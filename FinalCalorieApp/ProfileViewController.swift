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
                self.fetchUserData()
            }
        }
    }

    func fetchUserData() {
        guard let currentUser = Auth.auth().currentUser else {
            print("User not authenticated")
            return
        }

        let userId = currentUser.uid
        
        db.collection("users").document(userId).getDocument { (document, error) in
            if let document = document, document.exists {
                let userData = document.data()
                self.nameLabel.text = userData?["name"] as? String ?? ""
                self.phoneLabel.text = userData?["phone"] as? String ?? ""
                self.emailLabel.text = userData?["email"] as? String ?? ""
                let weight = userData?["weight"] as? Double ?? 0.0
                let height = userData?["height"] as? Double ?? 0.0
                self.weightLabel.text = "\(weight) lbs"
                self.heightLabel.text = "\(height) in"
                self.calculateBMI(weight: weight, height: height)
                print("Name: \(self.nameLabel.text ?? "")")
                print("Phone: \(self.phoneLabel.text ?? "")")
                print("Email: \(self.emailLabel.text ?? "")")
                print("Weight: \(weight)")
                print("Height: \(height)")
            } else {
                print("User document does not exist")
            }
        }
    }
    
    func calculateBMI(weight: Double, height: Double) {
        // Calculate BMI using the provided formula: weight(lb) / [height(in)]^2 * 703
        let bmi = (weight / (height * height)) * 703
        
        self.bmiLabel.text = String(format: "%.1f", bmi)
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
