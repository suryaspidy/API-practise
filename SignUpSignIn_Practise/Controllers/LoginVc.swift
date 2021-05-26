//
//  LoginVc.swift
//  SignUpSignIn_Practise
//
//  Created by surya-zstk231 on 20/05/21.
//

import UIKit
import CoreData

enum LoginAlerts:String{
    case emptyMail = "Please enter your email"
    case emptyPwd = "Please enter your password"
    case wrongInformations = "Check your email or password"
}

class LoginVc: UIViewController {

    
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var loginBtn: UIButton!
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    @IBOutlet weak var loginEmailTextArea: UITextField!
    @IBOutlet weak var loginPasswordTextArea: UITextField!
    @IBOutlet weak var alertTextArea: UILabel!
    let userIsLogged = UserDefaults.standard.string(forKey: "email")
    override func viewDidLoad() {
        super.viewDidLoad()

        customDesigns()
        if userIsLogged != nil {
            performSegue(withIdentifier: "loginSuccessfully", sender: self)
            
            
        }
    }
    
    func customDesigns(){
        navigationController?.navigationBar.isHidden = true
        loginBtn.layer.cornerRadius = loginBtn.frame.height/2
        mainView.clipsToBounds = true
        mainView.layer.cornerRadius = view.frame.width/8
        mainView.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
        
    }
    
    
    

    @IBAction func loginDoneBtnPressed(_ sender: UIButton) {
        alertTextArea.text = ""
        if loginEmailTextArea.text!.isEmpty{
            alertTextArea.text = LoginAlerts.emptyMail.rawValue
        } else if loginPasswordTextArea.text!.isEmpty {
            alertTextArea.text = LoginAlerts.emptyPwd.rawValue
        } else if loginEmailTextArea.text?.isEmpty == false && loginPasswordTextArea.text?.isEmpty == false{
            let email = loginEmailTextArea.text!
            let password = loginPasswordTextArea.text!
            let isAllowed = fetchData(email: email, password: password)
            if isAllowed{
                UserDefaults.standard.set(email, forKey: "email")
                performSegue(withIdentifier: "loginSuccessfully", sender: self)
            }
            else{
                alertTextArea.text = LoginAlerts.wrongInformations.rawValue
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "loginSuccessfully" {
            let destination = segue.destination as! HomeVc
            if userIsLogged == nil {
                destination.email = loginEmailTextArea.text
            } else if userIsLogged != nil {
                destination.email = userIsLogged
            }
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
