//
//  HomeVc.swift
//  SignUpSignIn_Practise
//
//  Created by surya-zstk231 on 20/05/21.
//

import UIKit
import CoreData

class HomeVc: UIViewController {

    var email: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        print(email)
        apiCall()
    }
    
    
    func apiCall(){
        let url = URL(string: "https://hubblesite.org/api/v3/news?page=all")!
        let session = URLSession(configuration: .default)
        let task = session.dataTask(with: url) { [self] (data, response, error) in
            if error == nil{
                if let resultData = data {
                    decodeDataFunc(data: resultData)
                }
            }
        }
        task.resume()
    }
    
    func decodeDataFunc(data: Data){
        let decode = JSONDecoder()
        do{
            let stringifyData = try decode.decode(DecodeFile.self, from: data)
            
            //let name = stringifyData.name
            //let id = stringifyData.news_id
            //let url = stringifyData.url
            
            //print("\(name) ")
            //print(stringifyData)
        }catch{
            print(error.localizedDescription)
        }
        
    }

    @IBAction func profileBtnPressed(_ sender: UIBarButtonItem) {
        performSegue(withIdentifier: "goToProfilePage", sender: self)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToProfilePage" {
            let destination = segue.destination as! ProfileDetailVc
            destination.email = email
        }
    }
}
