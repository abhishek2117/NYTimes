//
//  UIImage.swift
//  NYTimes
//
//  Created by Champ on 18/10/18.
//  Copyright © 2018 Champ. All rights reserved.
//

import UIKit
import Foundation

private var activityIndicatorAssociationKey: UInt8 = 0

extension UIImageView {
    
    @IBInspectable var activityIndicator : UIActivityIndicatorView! {
        
        get {
            return objc_getAssociatedObject(self, &activityIndicatorAssociationKey) as? UIActivityIndicatorView
        }
        
        set(newValue) {
            objc_setAssociatedObject(self, &activityIndicatorAssociationKey, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN)
        }
        
    }
    
    func showActivityIndicator() {
        
        if self.activityIndicator == nil {
            self.activityIndicator = UIActivityIndicatorView.init(style: UIActivityIndicatorView.Style.gray)
            self.activityIndicator.frame = CGRect.init(x: 0.0, y: 0.0, width: self.frame.size.width, height: self.frame.size.height)
            self.activityIndicator.hidesWhenStopped = true
            //self.activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.whiteLarge
            self.activityIndicator.center = CGPoint.init(x: self.frame.size.width / 2, y: self.frame.size.height / 2)
            
            self.activityIndicator.isUserInteractionEnabled = false
            
            OperationQueue.main.addOperation {
                self.addSubview(self.activityIndicator)
                self.bringSubviewToFront(self.activityIndicator)
                self.activityIndicator.startAnimating()
            }
        }
    }
    
    func hideActivityIndicator() {
        OperationQueue.main.addOperation {
            self.activityIndicator.stopAnimating()
        }
    }
    
    func loadImage(urlString: String){
        
        showActivityIndicator()
        let urlStr :String = urlString
        if !urlStr.isEmpty {
            
            // check cache
            
            if let cachedImage = ImageCache.shared.image(forKey: urlString) {
                self.hideActivityIndicator()
                DispatchQueue.main.async {
                    self.image = cachedImage
                }
                return
            }
            
            let timeOut: TimeInterval = 30
            
            let request = URLRequest.init(url: URL.init(string: urlStr)!, cachePolicy: .returnCacheDataElseLoad
                , timeoutInterval: timeOut)
            let task = URLSession.shared.dataTask(with: request){ data, response, error in
                self.hideActivityIndicator()
                if (error == nil){
                    if let image = UIImage(data:data!) {
                        ImageCache.shared.save(image: image, forKey: (response?.url?.absoluteString)!)
                        DispatchQueue.main.async {
                            self.image = image
                        }
                    }
                }
            }
            task.resume()
        }
    }
}

class ImageCache {
    private let cache = NSCache<AnyObject, UIImage>()
    private var observer: NSObjectProtocol!
    
    static let shared = ImageCache()
    
    private init() {
        // make sure to purge cache on memory pressure
        observer = NotificationCenter.default.addObserver(forName: UIApplication.didReceiveMemoryWarningNotification, object: nil, queue: nil) { [weak self] notification in
            self?.cache.removeAllObjects()
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(observer)
    }
    
    func image(forKey key: String) -> UIImage? {
        return cache.object(forKey: key as AnyObject)
    }
    
    func save(image: UIImage, forKey key: String) {
        cache.setObject(image, forKey: key as AnyObject)
    }
    
    func remove(forKey key: String) {
        cache.removeObject(forKey: key as AnyObject)
    }
}
