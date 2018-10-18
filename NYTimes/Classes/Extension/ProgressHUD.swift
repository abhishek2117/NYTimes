//
//  ProgressHUD.swift
//  NYTimes
//
//  Created by Champ on 17/10/18.
//  Copyright © 2018 Champ. All rights reserved.
//

import UIKit
import Foundation

extension UIViewController {
    
    class func displayHUD(_ onView : UIView) -> UIView {
        let hudView = UIView.init(frame: onView.bounds)
        hudView.backgroundColor = UIColor.init(red: 0.5, green: 0.5, blue: 0.5, alpha: 0.5)
        let aIndicatorView = UIActivityIndicatorView.init(style: .whiteLarge)
        aIndicatorView.startAnimating()
        aIndicatorView.center = hudView.center
        
        DispatchQueue.main.async {
            hudView.addSubview(aIndicatorView)
            onView.addSubview(hudView)
        }
        
        return hudView
    }
    
    class func removeHUD(_ hud :UIView) {
        DispatchQueue.main.async {
            hud.removeFromSuperview()
        }
    }
}
