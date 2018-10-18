//
//  ArticleTableViewCell.swift
//  NYTimes
//
//  Created by Champ on 17/10/18.
//  Copyright © 2018 Champ. All rights reserved.
//

import UIKit

class ArticleTableViewCell: UITableViewCell {

    static let identifier = "ArticleTableViewCell"
    
    @IBOutlet var lblTitle: UILabel!
    @IBOutlet var lblBy: UILabel!
    @IBOutlet var lblDate: UILabel!
    @IBOutlet var imgMedia: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    var article: Article? {
        didSet {
            if let obj = article {
                lblTitle.text = obj.title
                lblBy.text = obj.byline
                lblDate.text = obj.publishedDate
                imgMedia.loadImage(urlString: obj.mediaPath)
            }
        }
    }
    
}
