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

        // Save name, phone number, email, weight, and height to variables
        self.name = name
        self.phone = phone
        self.email = email
        // Proceed to BMIViewController
       performSegue(withIdentifier: "ToBMIViewController", sender: nil)
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
//

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
