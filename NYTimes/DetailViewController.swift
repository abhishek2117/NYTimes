//
//  DetailViewController.swift
//  NYTimes
//
//  Created by Champ on 18/10/18.
//  Copyright © 2018 Champ. All rights reserved.
//

import UIKit
import WebKit


class DetailViewController: UIViewController, WKNavigationDelegate {

    var article: Article!
    @IBOutlet var webView: WKWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        debugPrint(article)
        // Do any additional setup after loading the view.
        
        let url = URL(string: article.articleURL)!
        webView.load(URLRequest(url: url))
        webView.navigationDelegate = self
    }
    
    //MARK:- WKNavigationDelegate

    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        print(error.localizedDescription)
    }

    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        print("Strat to load")
    }

    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        print("finish to load")
    }
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
