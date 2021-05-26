//
//  JSONDecoderFile.swift
//  SignUpSignIn_Practise
//
//  Created by surya-zstk231 on 26/05/21.
//

import Foundation

class JSONDecoderFile {
    var authorName: String?
    var titleName: String?
    var publishedTime: String?
    var pageUrl: String?
    var imageUrl: String?
    
    
    func fetchData(JSON: Dictionary<String, Any>, rowNo: Int){
        var articles:[Any] = JSON["articles"] as! [Any]
        let myData = articles[rowNo] as! [String:Any]
        
        titleName = myData["title"] as? String
        authorName = myData["author"] as? String
        publishedTime = myData["publishedAt"] as? String
        imageUrl = myData["urlToImage"] as? String
        pageUrl = myData["url"]! as! String
    }
}

