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
    
    @IBOutlet weak var tableView: UITableView!
    
    var allDatas:[[String]] = []
    var json:[String:AnyObject] = [:]
    var articles:[Any] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.isHidden = false

//        apiCall()
        apiCallHashMapMethod()
        tableView.register(UINib(nibName: "NewsTableViewCell", bundle: nil), forCellReuseIdentifier: "newsTableCellID")
        tableView.dataSource = self
        tableView.delegate = self
        
    }
    
    
    func apiCall(){
        let url = URL(string: "https://newsapi.org/v2/everything?q=tesla&from=2021-04-25&sortBy=publishedAt&apiKey=8c1077210098486f97aefcebf54b36ac")!
        let session = URLSession(configuration: .ephemeral)
        let task = session.dataTask(with: url) { [self] (data, response, error) in
            if error == nil{
                if let resultData = data {
                    decodeDataFunc(data: resultData)
                }
            }else{
                print(error)
            }
        }
        task.resume()
    }
    
    func apiCallHashMapMethod(){
        let url = URL(string: "https://newsapi.org/v2/everything?q=tesla&from=2021-04-25&sortBy=publishedAt&apiKey=8c1077210098486f97aefcebf54b36ac")!
        let session = URLSession(configuration: .ephemeral)
        let task = session.dataTask(with: url) { [self] (data, response, error) in
            if error == nil{
                if let resultData = data {
                    json = try! JSONSerialization.jsonObject(with: resultData, options: .allowFragments) as! [String : AnyObject]
                    articles = json["articles"] as! [Any]
//                    let count = Int(json["articles"]!.count)-1
//
//                    for i in 0...count{
//                        let myData = articles[i] as! [String:Any]
//                        print(myData["author"]!)
//                        print(myData["title"]!)
//                        print(myData["url"]!)
//                        print(myData["urlToImage"]!)
//                        print(myData["publishedAt"]!)
//                    }
//                    DispatchQueue.main.async {
//                        tableView.reloadData()
//                    }
                    if articles.count > 0 {
                        DispatchQueue.main.async {
                            tableView.reloadData()
                        }
                    }
                    
                }
            }else{
                print(error)
            }
        }
        task.resume()
    }
    
    func decodeDataFunc(data: Data){
        let decoder = JSONDecoder()
        do{
            let stringifyData = try decoder.decode(DecodeFile.self, from: data)
            let strItems = stringifyData.articles
            
            for i in strItems {
                var arr:[String] = []
                arr.append((i?.title)!)
                arr.append((i?.publishedAt)!)
                arr.append((i?.url)!)
                arr.append((i?.author) ?? "-")
                arr.append((i?.urlToImage) ?? "nil")
                
                allDatas.append(arr)

            }
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
            
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
    @IBAction func signOutBtnTapped(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(title: "Alert", message: "Do you want sign out", preferredStyle: .alert)
        let action1 = UIAlertAction(title: "Sign out", style: .default) { (action) in
            UserDefaults.standard.removeObject(forKey: "email")
            
            self.performSegue(withIdentifier: "userSignOut", sender: self)
        }
        let action2 = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alert.addAction(action1)
        alert.addAction(action2)
        
        self.present(alert, animated: true, completion: nil)
    }
    
}


extension HomeVc:UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return allDatas.count
        return articles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "newsTableCellID", for: indexPath) as! NewsTableViewCell
        
        let myData = articles[indexPath.row] as! [String:Any]
//        cell.titleArea.text = allDatas[indexPath.row][0]
//        cell.timeArea.text = allDatas[indexPath.row][1]
//        cell.autherNameArea.text = allDatas[indexPath.row][3]
//        let img = allDatas[indexPath.row][4]
//        print(img)
//        if img != "nil" {
//            if let urlImg = URL(string: img){
//                if let dataOfImg = try? Data(contentsOf: urlImg){
//                cell.imageArea?.image = UIImage(data: dataOfImg)
//                }
//            }
//        }
        
        cell.titleArea.text = myData["title"] as? String
        cell.timeArea.text = myData["publishedAt"] as? String
        cell.autherNameArea.text = myData["author"] as? String
        let img = myData["urlToImage"] as! String
        print(img)
        if img != "null" {
            if let urlImg = URL(string: img){
                if let dataOfImg = try? Data(contentsOf: urlImg){
                cell.imageArea?.image = UIImage(data: dataOfImg)
                }
            }
        }
        
        return cell
    }
    
    
}

extension HomeVc: UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = (storyboard?.instantiateViewController(identifier: "webView"))! as WebViewVc
//        vc.urlStr = allDatas[indexPath.row][2]
        let myData = articles[indexPath.row] as! [String:Any]
        vc.urlStr = myData["url"]! as! String
        navigationController?.pushViewController(vc, animated: true)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
}
