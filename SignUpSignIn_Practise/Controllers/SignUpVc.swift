//
//  SignUpVc.swift
//  SignUpSignIn_Practise
//
//  Created by surya-zstk231 on 20/05/21.
//

import UIKit
import CoreData

enum SignUpAlerts: String{
    case nameIsEmpty = "Please enter name"
    case emailIsEmpty = "Please enter valid email"
    case mobileNoIsEmpty = "Please enter mobile number"
    case pwdIsEmpty = "Please enter password"
    
    case wrongName = "Enter valid name"
    case wrongMobileNo = "Enter valid mobile no with 6 digit to 12 digit"
    case wrongEmail = "Enter valid email ex(cc@ccc.com)"
    case wrongPwd = "Enter valid password with minimum 6 digit"
    case emailExists = "Email already exists"
}

class SignUpVc: UIViewController {

    @IBOutlet weak var signUpBtn: UIButton!
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var signUpNameTextArea: UITextField!
    @IBOutlet weak var signUpMobileNoTextArea: UITextField!
    
    @IBOutlet weak var signUpEmailTextArea: UITextField!
    @IBOutlet weak var signUpPasswordTextArea: UITextField!
    @IBOutlet weak var signUpAlertLabel: UILabel!
    
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    override func viewDidLoad() {
        super.viewDidLoad()

        customDesigns()
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
        
    }
    
    func customDesigns(){
        navigationController?.navigationBar.isHidden = true
        signUpBtn.layer.cornerRadius = signUpBtn.frame.height/2
        mainView.clipsToBounds = true
        mainView.layer.cornerRadius = view.frame.width/8
        mainView.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
        
    }
    

    @IBAction func signUpDoneBtnTapped(_ sender: UIButton) {
        clearColour()
        if signUpNameTextArea.text!.isEmpty{
            signUpAlertLabel.text = SignUpAlerts.nameIsEmpty.rawValue
        } else if signUpMobileNoTextArea.text!.isEmpty {
            signUpAlertLabel.text = SignUpAlerts.mobileNoIsEmpty.rawValue
        } else if signUpEmailTextArea.text!.isEmpty {
            signUpAlertLabel.text = SignUpAlerts.emailIsEmpty.rawValue
        } else if signUpPasswordTextArea.text!.isEmpty {
            signUpAlertLabel.text = SignUpAlerts.pwdIsEmpty.rawValue
        } else if (signUpNameTextArea.text!.isEmpty == false && signUpNameTextArea.text!.isEmpty == false && signUpEmailTextArea.text!.isEmpty == false && signUpPasswordTextArea.text!.isEmpty == false){
            
            let userName = signUpNameTextArea.text!
            let userMobileNo = signUpMobileNoTextArea.text!
            let userEmail = signUpEmailTextArea.text!
            let userPassword = signUpPasswordTextArea.text!
            
            let isEmailValidBool = userEmail.isValidEmail()
            let isMobileValidBool = userMobileNo.isMobileNumberValid()
            let isNameValidBool = userName.isNameValid()
            let isPasswordValidBool = userPassword.isPasswordValid()
            let isEmailExists = emailAlreadyExists(email: userEmail)
            
            
            if isNameValidBool == false {
                signUpNameTextArea.textColor = .red
                signUpAlertLabel.text = SignUpAlerts.wrongName.rawValue
            }
            else if isMobileValidBool == false {
                signUpMobileNoTextArea.textColor = .red
                signUpAlertLabel.text = SignUpAlerts.wrongMobileNo.rawValue
            }
            else if isEmailValidBool == false{
                signUpEmailTextArea.textColor = .red
                signUpAlertLabel.text = SignUpAlerts.wrongEmail.rawValue
            }
            else if isPasswordValidBool == false{
                signUpPasswordTextArea.textColor = .red
                signUpAlertLabel.text = SignUpAlerts.wrongPwd.rawValue
            }
            else if isEmailExists == false{
                signUpAlertLabel.text = SignUpAlerts.emailExists.rawValue
            }
            else if isEmailValidBool && isMobileValidBool && isNameValidBool && isPasswordValidBool && isEmailExists{
                print("\(userName)  \(userMobileNo)  \(userEmail)  \(userPassword)")
                
                let saveValues = UserDetails(context: context)
                
                saveValues.userName = userName
                saveValues.userMobileNumber = Int64(userMobileNo)!
                saveValues.userEmail = userEmail
                saveValues.userPassword = userPassword
                saveValues.profilePhoto = UIImage(named: "emptyUserImage")?.pngData()
                saveItems()
                
                self.dismiss(animated: true, completion: nil)
                
            }
            
            
        }
        
    }
    
    func emailAlreadyExists(email: String) -> Bool{
        let request:NSFetchRequest<UserDetails> = UserDetails.fetchRequest()
        let predicate = NSPredicate(format: "userEmail == %@", email)
        
        request.predicate = predicate
        var ans = [UserDetails]()
        do{
            ans = try context.fetch(request)
        }
        catch{
            print(error.localizedDescription)
        }
        
        if ans.count > 0 {
            return false
        } else{
            return true
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
    
    @IBAction func goToLoginPage(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
        
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
