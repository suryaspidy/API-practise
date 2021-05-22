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
    override func viewDidLoad() {
        super.viewDidLoad()
        let data = loadDetails(emailValue: email!)

        profileImageArea.layer.cornerRadius = profileImageArea.frame.height/2
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
