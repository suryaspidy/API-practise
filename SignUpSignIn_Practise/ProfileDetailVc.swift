//
//  ProfileDetailVc.swift
//  SignUpSignIn_Practise
//
//  Created by surya-zstk231 on 22/05/21.
//

import UIKit
import CoreData

class ProfileDetailVc: UIViewController {
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    @IBOutlet weak var profileImageArea: UIImageView!
    @IBOutlet weak var userNameTextArea: UILabel!
    @IBOutlet weak var userEmailTextArea: UILabel!
    @IBOutlet weak var userMobileNoTextArea: UILabel!
    
    var email: String?
    var data = [UserDetails]()
    override func viewDidLoad() {
        super.viewDidLoad()
        data = loadDetails(emailValue: email!)

        profileImageArea.layer.cornerRadius = profileImageArea.frame.height/2
        profileImageArea.layer.borderColor = CGColor(red: 0, green: 0, blue: 0, alpha: 1)
        profileImageArea.layer.borderWidth = 1
        addDatasInTextFields()
        addTapGestureForProfile()
    }
    
    func addTapGestureForProfile(){
        let gesture = UITapGestureRecognizer(target: self, action: #selector(profileTapped))
        profileImageArea.isUserInteractionEnabled = true
        profileImageArea.addGestureRecognizer(gesture)
    }
    
    @objc func profileTapped(){
        print("Profile tapped")
        let vc = storyboard?.instantiateViewController(identifier: "profilePhotoViewPage") as! ProfilePhotoViewVc
        vc.image = UIImage(data: data[0].profilePhoto!)!
        vc.email = data[0].userEmail
        present(vc, animated: true, completion: nil)
    }
    
    func addDatasInTextFields(){
        userNameTextArea.text = data[0].userName
        userEmailTextArea.text = data[0].userEmail
        userMobileNoTextArea.text = String(data[0].userMobileNumber)
        profileImageArea.image = UIImage(data: data[0].profilePhoto!)
    }
    
    func loadDetails(emailValue: String) -> [UserDetails]{
        let request: NSFetchRequest<UserDetails> = UserDetails.fetchRequest()
        
        let predicate = NSPredicate(format: "userEmail == %@", emailValue)
        
        request.predicate = predicate
        
        do{
            let arr = try context.fetch(request)
            return arr
        }catch{
            print(error)
        }
        return []
    }

}
