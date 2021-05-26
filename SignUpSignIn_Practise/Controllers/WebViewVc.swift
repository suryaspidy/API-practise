//
//  WebViewVc.swift
//  SignUpSignIn_Practise
//
//  Created by surya-zstk231 on 25/05/21.
//

import UIKit
import WebKit

class WebViewVc: UIViewController {

    @IBOutlet weak var webKit: WKWebView!
    
    var urlStr: String?
    override func viewDidLoad() {
        super.viewDidLoad()

        let url = URL(string: urlStr!)
        webKit.load(URLRequest(url: url!))
    }
    
}
