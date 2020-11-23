//
//  UIImageView.swift
//  Twitter
//
//  Created by Madara2hor on 05.08.2020.
//  Copyright © 2020 Madara2hor. All rights reserved.
//

import Foundation
import UIKit
import Alamofire

let imageCache = NSCache<NSString, UIImage>()

extension UIImageView {
    
    func load(url: URL) {
        DispatchQueue.global().async { [weak self] in
            guard let cachedImage = imageCache.object(forKey: url.absoluteString as NSString) else {
                AF.download(url).responseData { response in
                    if let data = response.value, let image = UIImage(data: data) {
                        imageCache.setObject(image, forKey: url.absoluteString as NSString)
                        DispatchQueue.main.async {
                            self?.image = image
                        }
                    }
                }
                return
            }
            DispatchQueue.main.async {
                self?.image = cachedImage
            }
        }
    }
    
}
