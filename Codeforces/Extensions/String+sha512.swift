//
//  String+sha512.swift
//  Codeforces
//
//  Created by Madara2hor on 05.08.2020.
//  Copyright © 2020 Madara2hor. All rights reserved.
//

import Foundation
import CommonCrypto

extension String {
   
    var sha512: String {
        let data = data(using: .utf8) ?? Data()
        var digest = [UInt8](repeating: .zero, count: Int(CC_SHA512_DIGEST_LENGTH))
        
        data.withUnsafeBytes{
            _ = CC_SHA512($0.baseAddress, CC_LONG(data.count), &digest)
        }
        
        return digest.map({ String(format: "%02hhx", $0) }).joined(separator: .empty)
    }
}
