//
//  ExtentionFile.swift
//  GameOfChat
//
//  Created by Sabbir on 17/6/19.
//  Copyright © 2019 Sabbir. All rights reserved.
//
import UIKit
import Foundation

let imageCache = NSCache<AnyObject, AnyObject>()

extension UIImageView {

    func loadImageUsingCacheWithUrlString(urlString: String){
        
        
        self.image  =  nil
        //check cache for image
        if let cachedImage = imageCache.object(forKey: urlString as AnyObject) as? UIImage{
            self.image = cachedImage
            return
        }
 
        //otherwise fire off a new download
        
        let url = URL(string: urlString)
        URLSession.shared.dataTask(with: url!) { (data, response, error) in
            if error != nil {
                print(error!)
                return
 
            }
 
            DispatchQueue.main.async {
                
                if let downloadedImage = UIImage(data: data!) {
                    imageCache.setObject(downloadedImage, forKey: urlString as AnyObject)
                    self.image = downloadedImage
                }
 
            }
            
            }.resume()
    }
    
    
    
}




















