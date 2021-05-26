//
//  ProfilePhotoViewVc.swift
//  SignUpSignIn_Practise
//
//  Created by surya-zstk231 on 22/05/21.
//

import UIKit
import CoreData

class ProfilePhotoViewVc: UIViewController, UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    
    var imageUpdate: ((_ isUpdate: Bool) -> Void)?
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var image:UIImage =  UIImage()
    var email: String?

    @IBOutlet weak var imageArea: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()

        imageArea.image = image
        
    }
    @IBAction func ProfilePhotoChangeBtnPressed(_ sender: UIButton) {
        imageViewPressed()
    }
    
    func imageViewPressed(){
        let imagePickerController = UIImagePickerController()
        imagePickerController.sourceType = .photoLibrary
        imagePickerController.allowsEditing = true
        imagePickerController.delegate = self
        present(imagePickerController, animated: true, completion: nil)
        
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let userPickedImage = info[.editedImage] as? UIImage else { return }
        imageArea.image = userPickedImage
        updateImage(image: imageArea.image!)
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    
    func updateImage(image: UIImage){
        let request:NSFetchRequest<UserDetails> = UserDetails.fetchRequest()
        let predicate = NSPredicate(format: "userEmail == %@", email as! CVarArg)
        
        request.predicate = predicate
        
        do{
            let arr = try context.fetch(request)
            arr[0].profilePhoto = image.pngData()
            saveItems()
            imageUpdate?(true)
            
        } catch{
            print(error)
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

}
