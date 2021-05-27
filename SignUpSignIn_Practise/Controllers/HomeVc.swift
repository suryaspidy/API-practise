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
    var storedData:[JSONDecoderFile] = []
    
    var fetchedData:[String:Any] = [:]
    
    var hardCodeTitle = ["A paragraph is a series of related sentences developing a central idea, called the topic. Try to think about paragraphs in terms of thematic unity: a paragraph is a sentence or a group of sentences that supports one central, unified idea. Paragraphs add one idea at a time to your broader argument.","In academic writing,","This topic sentence forecasts the central idea or main point of the paragraph: “politicians” and “journalists” rely on Twitter. The rest of the paragraph will focus on these two Twitter-user groups, thereby fulfilling the promise made","he definition paragraph does exactly what you would expect: it defines a term, often by drawing distinctions between the term and other related ones. The definition that you provide will","In Harry’s world fate works not only through powers and objects such as prophecies","In Harry’s world fate works not only through powers and objects such as prophecies","he definition paragraph does exactly what you would expect: it defines a term, often by drawing distinctions between the term and other related ones. The definition that you provide will","This topic sentence forecasts the central idea or main point of the paragraph: “politicians” and “journalists” rely on Twitter. The rest of the paragraph will focus on these two Twitter-user groups, thereby fulfilling the promise made","In academic writing,","A paragraph is a series of related sentences developing a central idea, called the topic. Try to think about paragraphs in terms of thematic unity: a paragraph is a sentence or a group of sentences that supports one central, unified idea. Paragraphs add one idea at a time to your broader argument."]
    
    var hardCodeName = ["sakgks","sdfghjkjhgfd","iugouwgf","wertyuiophgszxdcfvgbhnjexrctvyb",nil,"vbun",nil,"fkfsaf","finf","egug"]
    
    var hardCodeDateArr = ["2021-05-25T11:10:43Z","2021-05-25T11:10:43Z","2021-05-25T11:10:43Z","2021-05-25T11:10:43Z","2021-05-25T11:10:43Z","2021-05-25T11:10:43Z","2021-05-25T11:10:43Z",nil,"2021-05-25T11:10:43Z","2021-05-25T11:10:43Z"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.isHidden = false

//        apiCall()
        apiCallHashMapMethod()
        tableView.register(UINib(nibName: Constants.tableViewCellNibName, bundle: nil), forCellReuseIdentifier: Constants.tableViewCellID)
        tableView.dataSource = self
        tableView.delegate = self
        
    }
    
    
    func apiCall(){
        let url = URL(string: "https://newsapi.org/v2/everything?q=apple&from=2021-05-25&to=2021-05-25&sortBy=popularity&apiKey=8c1077210098486f97aefcebf54b36ac")!
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
        let url = URL(string: "https://newsapi.org/v2/everything?q=apple&from=2021-05-25&to=2021-05-25&sortBy=popularity&apiKey=8c1077210098486f97aefcebf54b36ac")!
//        https://newsapi.org/v2/everything?q=tesla&from=2021-04-25&sortBy=publishedAt&apiKey=8c1077210098486f97aefcebf54b36ac
        let session = URLSession(configuration: .ephemeral)
        let task = session.dataTask(with: url) { [self] (data, response, error) in
            if error == nil{
                if let resultData = data {
                    json = try! JSONSerialization.jsonObject(with: resultData, options: .allowFragments) as! [String : AnyObject]
                    
                    let articleData = json["articles"] as! [JSONDecoderFile]
                    
                    
                    for i in 0...articleData.count-1{
                        let instance = JSONDecoderFile()
                        instance.getData(JSON: json, rowNo: i)
                        let ans:JSONDecoderFile = instance
                        storedData.append(ans)
                    }
                    
                    DispatchQueue.main.async {
                        tableView.reloadData()
                    }
                    
                }
            }else{
                print(error!)
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
        performSegue(withIdentifier: Constants.goToProfilePageSegueID, sender: self)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Constants.goToProfilePageSegueID {
            let destination = segue.destination as! ProfileDetailVc
            destination.email = email
        }
    }
    @IBAction func signOutBtnTapped(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(title: "Alert", message: "Do you want sign out", preferredStyle: .alert)
        let action1 = UIAlertAction(title: "Sign out", style: .default) { (action) in
            UserDefaults.standard.removeObject(forKey: "email")
            
            self.performSegue(withIdentifier: Constants.userIsSignOutSegueID, sender: self)
        }
        let action2 = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alert.addAction(action1)
        alert.addAction(action2)
        
        self.present(alert, animated: true, completion: nil)
    }
    
    func fetchImage(url: String)-> UIImage?{
        if let urlImg = URL(string: url){
            if let dataOfImg = try? Data(contentsOf: urlImg){
                let image = UIImage(data: dataOfImg)!
                return image
            }
        }
        return nil
    }
    
}


extension HomeVc:UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return allDatas.count
        return storedData.count
//        return hardCodeTitle.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.tableViewCellID, for: indexPath) as! NewsTableViewCell
        
        cell.titleArea.text = storedData[indexPath.row].titleName
        cell.timeArea.text = storedData[indexPath.row].publishedTime
        cell.autherNameArea.text = storedData[indexPath.row].authorName
        let imgUrl = storedData[indexPath.row].imageUrl ?? "https://i.vimeocdn.com/portrait/1274237_300x300.jpg"
        let image = fetchImage(url: imgUrl)
        cell.imageArea.image = image
        
        
//        cell.titleArea.text = allDatas[indexPath.row][0]
//        cell.timeArea.text = allDatas[indexPath.row][1]
//        cell.autherNameArea.text = allDatas[indexPath.row][3]
//        let imgUrl = allDatas[indexPath.row][4] ?? "https://i.vimeocdn.com/portrait/1274237_300x300.jpg"
//        let image = fetchImage(url: imgUrl)
//        cell.imageArea.image = image
        
//        cell.titleArea.text = hardCodeTitle[indexPath.row]
//        cell.autherNameArea.text = hardCodeName[indexPath.row]
//        cell.timeArea.text = hardCodeDateArr[indexPath.row]
        return cell
    }
    
    
}

extension HomeVc: UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = (storyboard?.instantiateViewController(identifier: Constants.webViewVcID))! as WebViewVc
        
//        vc.urlStr = allDatas[indexPath.row][2]
        
        vc.urlStr = storedData[indexPath.row].pageUrl
        navigationController?.pushViewController(vc, animated: true)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
}
