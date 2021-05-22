//
//  SignUpVc.swift
//  SignUpSignIn_Practise
//
//  Created by surya-zstk231 on 20/05/21.
//

import UIKit
import CoreData

class SignUpVc: UIViewController {

    @IBOutlet weak var signUpNameTextArea: UITextField!
    @IBOutlet weak var signUpMobileNoTextArea: UITextField!
    
    @IBOutlet weak var signUpEmailTextArea: UITextField!
    @IBOutlet weak var signUpPasswordTextArea: UITextField!
    @IBOutlet weak var signUpAlertLabel: UILabel!
    
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    override func viewDidLoad() {
        super.viewDidLoad()

        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
        // Do any additional setup after loading the view.
    }
    

    @IBAction func signUpDoneBtnTapped(_ sender: UIButton) {
        clearColour()
        if signUpNameTextArea.text!.isEmpty{
            signUpAlertLabel.text = "Please enter name"
        } else if signUpMobileNoTextArea.text!.isEmpty {
            signUpAlertLabel.text = "Please enter mobile number"
        } else if signUpEmailTextArea.text!.isEmpty {
            signUpAlertLabel.text = "Please enter valid email"
        } else if signUpPasswordTextArea.text!.isEmpty {
            signUpAlertLabel.text = "Please enter password"
        } else if (signUpNameTextArea.text!.isEmpty == false && signUpNameTextArea.text!.isEmpty == false && signUpEmailTextArea.text!.isEmpty == false && signUpPasswordTextArea.text!.isEmpty == false){
            
            let userName = signUpNameTextArea.text!
            let userMobileNo = signUpMobileNoTextArea.text!
            let userEmail = signUpEmailTextArea.text!
            let userPassword = signUpPasswordTextArea.text!
            
            let isEmailValidBool = userEmail.isValidEmail()
            let isMobileValidBool = userMobileNo.isMobileNumberValid()
            let isNameValidBool = userName.isNameValid()
            let isPasswordValidBool = userPassword.isPasswordValid()
            
            
            if isNameValidBool == false {
                signUpNameTextArea.textColor = .red
                signUpAlertLabel.text = "Enter valid name"
            }
            else if isMobileValidBool == false {
                signUpMobileNoTextArea.textColor = .red
                signUpAlertLabel.text = "Enter valid mobile no with 6 digit to 12 digit"
            }
            else if isEmailValidBool == false{
                signUpEmailTextArea.textColor = .red
                signUpAlertLabel.text = "Enter valid email ex(cc@ccc.com)"
            }
            else if isPasswordValidBool == false{
                signUpPasswordTextArea.textColor = .red
                signUpAlertLabel.text = "Enter valid password with minimum 6 digit"
            }
            else if isEmailValidBool && isMobileValidBool && isNameValidBool && isPasswordValidBool{
                print("\(userName)  \(userMobileNo)  \(userEmail)  \(userPassword)")
                
                let saveValues = UserDetails(context: context)
                
                saveValues.userName = userName
                saveValues.userMobileNumber = Int64(userMobileNo)!
                saveValues.userEmail = userEmail
                saveValues.userPassword = userPassword
                saveValues.profilePhoto = UIImage(named: "emptyUserImage")?.pngData()
                saveItems()
                
            }
            
            
        }
        
    }
    
    
    func saveItems(){
        do {
            try context.save()
            print("Save succesfuly")
        } catch {
            print("Error in saveItem func \(error)")
        }
    }
    
    
    func clearColour(){
        signUpNameTextArea.textColor = .black
        signUpMobileNoTextArea.textColor = .black
        signUpEmailTextArea.textColor = .black
        signUpPasswordTextArea.textColor = .black
    }
    
    
}
extension String{
    func isMobileNumberValid() -> Bool{
        let regEx = "[0-9]{6,16}"
        let predicate = NSPredicate(format: "SELF MATCHES %@", regEx)
        return predicate.evaluate(with: self)
    }
    
    func isValidEmail() -> Bool{
        let regEx = "[A-Z0-9a-z._%+-]{2,}+\\@[A-Za-z0-9]+\\.[A-Za-z]{2,}"
        let predicate = NSPredicate(format: "SELF MATCHES %@", regEx)
        return predicate.evaluate(with: self)
    }
    
    func isNameValid() -> Bool{
        let regEx = "[a-zA-Z\\s]{1,}"
        let predicate = NSPredicate(format: "SELF MATCHES %@", regEx)
        return predicate.evaluate(with: self)
    }
    func isPasswordValid() -> Bool{
        let regEx = "[a-zA-Z0-9]{6,}"
        let predicate = NSPredicate(format: "SELF MATCHES %@", regEx)
        return predicate.evaluate(with: self)
    }
}
