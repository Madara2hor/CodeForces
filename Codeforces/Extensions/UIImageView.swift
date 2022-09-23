//
//  UIImageView.swift
//  Codeforces
//
//  Created by Madara2hor on 05.08.2020.
//  Copyright © 2020 Madara2hor. All rights reserved.
//

import UIKit
import Alamofire

let imageCache = NSCache<NSString, UIImage>()

extension UIImageView {
    
    func load(url: URL) {
        DispatchQueue.global().async {
            guard let cachedImage = imageCache.object(forKey: url.absoluteString as NSString) else {
                AF.download(url).responseData { response in
                    guard let data = response.value, let image = UIImage(data: data) else {
                        return
                    }
                    
                    imageCache.setObject(image, forKey: url.absoluteString as NSString)
                    
                    self.setImage(image)
                }
                
                return
            }
            
            self.setImage(cachedImage)
        }
    }
    
    private func setImage(_ image: UIImage) {
        DispatchQueue.main.async { [weak self] in
            self?.image = image
        }
    }
}
