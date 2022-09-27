//
//  ImageChaceUtil.swift
//  Codeforces
//
//  Created by Madara2hor on 05.08.2020.
//  Copyright © 2020 Madara2hor. All rights reserved.
//

import UIKit
import Alamofire

class ImageChaceUtil: NSCache<NSURL, UIImage> {
    
    static let shared = ImageChaceUtil()

    init(limit: Int = 200) {
        super.init()
        
        countLimit = limit
    }

    func image(for url: URL, completion: @escaping ((UIImage?) -> Void)) {
        if let image = object(forKey: url as NSURL) {
            completion(image)
        } else {
            AF.download(url).responseData { response in
                DispatchQueue.main.async {
                    guard let data = response.value, let image = UIImage(data: data) else {
                        completion(nil)
                        return
                    }
                    
                    self.setObject(image, forKey: url as NSURL)
                    
                    completion(UIImage(data: data))
                }
            }
        }
    }
}
