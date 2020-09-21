//
//  AlertPresentableProtocol.swift
//  Codeforces
//
//  Created by Madara2hor on 11.09.2020.
//  Copyright © 2020 Madara2hor. All rights reserved.
//

import Foundation
import UIKit

protocol AlertPresentableProtocol {
    func showRequestDataAlert(title: String,
                              message: String,
                              placeholder: String?,
                              actionTitle: String,
                              completion: @escaping (_ userData: String?) -> ())
    func showWarningAlert(title: String, message: String)
}

extension AlertPresentableProtocol where Self: UIViewController {
    
    func showRequestDataAlert(title: String,
                              message: String,
                              placeholder: String?,
                              actionTitle: String,
                              completion: @escaping (_ userData: String?) -> ()) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.view.tintColor = .systemIndigo
        
        alert.addTextField { (textField) in
            textField.placeholder = placeholder ?? ""
        }
        
        alert.addAction(UIAlertAction(title: actionTitle, style: .default, handler: { [unowned alert] _ in
        let textField = alert.textFields![0]
            completion(textField.text)
        }))
        
        self.present(alert, animated: true, completion: nil)
    }

    func showWarningAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.view.tintColor = .systemIndigo
        
        alert.addAction(UIAlertAction(title: "Закрыть", style: .cancel))
        
        self.present(alert, animated: true, completion: nil)
    }
}
