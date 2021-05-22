//
//  LoginVc.swift
//  SignUpSignIn_Practise
//
//  Created by surya-zstk231 on 20/05/21.
//

import UIKit
import CoreData

class LoginVc: UIViewController {

    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    @IBOutlet weak var loginEmailTextArea: UITextField!
    @IBOutlet weak var loginPasswordTextArea: UITextField!
    @IBOutlet weak var alertTextArea: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    

    @IBAction func loginDoneBtnPressed(_ sender: UIButton) {
        alertTextArea.text = ""
        if loginEmailTextArea.text!.isEmpty{
            alertTextArea.text = "Please enter your email"
        } else if loginPasswordTextArea.text!.isEmpty {
            alertTextArea.text = "Please enter your password"
        } else if loginEmailTextArea.text?.isEmpty == false && loginPasswordTextArea.text?.isEmpty == false{
            let email = loginEmailTextArea.text!
            let password = loginPasswordTextArea.text!
            let isAllowed = fetchData(email: email, password: password)
            if isAllowed{
                performSegue(withIdentifier: "loginSuccessfully", sender: self)
            }
            else{
                alertTextArea.text = "Check your email or password"
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "loginSuccessfully" {
            let destination = segue.destination as! HomeVc
            destination.email = loginEmailTextArea.text
        }
    }
    
    func fetchData(email: String, password: String) -> Bool{
        let request: NSFetchRequest<UserDetails> = UserDetails.fetchRequest()
        let condition1 = NSPredicate(format: "userEmail == %@", email)
        let condition2 = NSPredicate(format: "userPassword == %@", password)
        
        let predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [condition1,condition2])
        request.predicate = predicate
        
        do{
            let arr = try context.fetch(request)
            if arr.count == 1{
                return true
            }
        }catch{
            print(error)
        }
        return false
    }
    
    
}
