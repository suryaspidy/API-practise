//
//  DecodeFile.swift
//  SignUpSignIn_Practise
//
//  Created by surya-zstk231 on 23/05/21.
//

import Foundation

struct DecodeFile: Codable{
//    var items: [Items?]
//    var status: String?
//    var feed: Feed?
    var articles: [Article?]
}


struct Article: Codable{
    var author: String?
    var title: String?
    var url: String?
    var publishedAt: String?
    var urlToImage: String?
}
//struct Items: Codable {
//    var title: String?
//    var pubDate: String?
//    var link: String?
//    var author: String?
//    var thumbnail: String?
//    
//}
//
//struct Feed: Codable {
//    var title: String?
//    var description: String?
//}
