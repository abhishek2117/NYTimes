//
//  ViewController.swift
//  NYTimes
//
//  Created by Champ on 17/10/18.
//  Copyright © 2018 Champ. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet var tblArticle: UITableView!
    
    var arrArticle: [Article] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        title = "NY Times"
        
        tblArticle.rowHeight = UITableView.automaticDimension
        tblArticle.estimatedRowHeight = UITableView.automaticDimension
        
        tblArticle.tableFooterView = UIView()
        tblArticle.separatorInset = .zero
        tblArticle.register(UINib(nibName: ArticleTableViewCell.identifier, bundle: nil), forCellReuseIdentifier: ArticleTableViewCell.identifier)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        //Internet check
        if Reachability.isConnectedToNetwork() {
            
            if arrArticle.count <= 0 {
                
                let hud = UIViewController.displayHUD(self.view)
                
                
                let url = URL(string : ApiConstant.mainDomain + ApiConstant.apiKey)
                
                URLSession.shared.dataTask(with: url!) { (data, response, error) in
                    
                    if error != nil {
                        print(error!.localizedDescription)
                    }
                    
                    guard let data = data else {
                        UIViewController.removeHUD(hud)
                        return
                    }
                    guard let value = try? JSONSerialization.jsonObject(with: data, options: .mutableContainers) else {
                        UIViewController.removeHUD(hud)
                        return
                    }
                    
                    let json = JSON(value)
                    
                    if json["status"].stringValue == "OK" {
                        for article in json["results"].arrayValue {
                            
                            var mediaPath = ""
                            
                            if let media = article["media"].arrayValue.first {
                                if let mediaMetadata = media["media-metadata"].arrayValue.first {
                                    mediaPath = mediaMetadata["url"].stringValue
                                }
                            }
                            
                            //Decode retrived data with JSONDecoder and assing type of Article object
                            let articlesData = Article.init(title: article["title"].stringValue, description: article["abstract"].stringValue, byline: article["byline"].stringValue, publishedDate: article["published_date"].stringValue, articleURL: article["url"].stringValue, mediaPath: mediaPath)
                            self.arrArticle.append(articlesData)
                        }
                    }
                    
                    //Get back to the main queue
                    DispatchQueue.main.async {
                        self.tblArticle.reloadData()
                    }
                    
                    UIViewController.removeHUD(hud)
                    }.resume()
            }
        } else {
            let alert = UIAlertController.init(title: "No Internet Connection", message: "Make sure your device is connected to the internet.", preferredStyle: .alert)
            let ok = UIAlertAction(title: "Ok", style: .default) { (action:UIAlertAction) in
                
            }
            alert.addAction(ok)
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    // MARK: - UITableview Delegate and Datasource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrArticle.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let tblCell = tableView.dequeueReusableCell(withIdentifier: "ArticleTableViewCell") as! ArticleTableViewCell
        tblCell.article = arrArticle[indexPath.row]
        return tblCell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "detailVC", sender: arrArticle[indexPath.row])
    }
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if segue.identifier == "detailVC" {
            let targetVC = segue.destination as! DetailViewController
            targetVC.article = sender as? Article
        }
    }
    
}
