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
        print(email!)
        apiCall()
    }
    

    func apiCalling(){
        let headers = [
            "x-rapidapi-key": "921527fb95msh93e9942a87b43a0p150366jsn7fba59d8b6fa",
            "x-rapidapi-host": "google-news1.p.rapidapi.com"
        ]

        let request = NSMutableURLRequest(url: NSURL(string: "https://google-news1.p.rapidapi.com/topic-headlines?topic=WORLD&country=US&lang=en")! as URL,
                                                cachePolicy: .useProtocolCachePolicy,
                                            timeoutInterval: 10.0)
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = headers

        let session = URLSession.shared
        let dataTask = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
            if (error != nil) {
                print(error)
            } else {
                let httpResponse = response as? HTTPURLResponse
                print(httpResponse)
            }
        })

        dataTask.resume()
    }
    
    func apiCall(){
        let url = URL(string: "https://hn.algolia.com/api/v1/search?tags=front_page")!
        let session = URLSession(configuration: .default)
        let task = session.dataTask(with: url) { (data, response, error) in
            print(response)
        }
        task.resume()
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
