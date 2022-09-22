//
//  MessagesViewController.swift
//  Twitter
//
//  Created by Madara2hor on 04.08.2020.
//  Copyright © 2020 Madara2hor. All rights reserved.
//

import UIKit

class UserDetailViewController: UIViewController {
    
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var handle: UILabel!
    @IBOutlet weak var online: UILabel!
    @IBOutlet weak var firstName: UILabel!
    @IBOutlet weak var lastName: UILabel!
    @IBOutlet weak var country: UILabel!
    @IBOutlet weak var city: UILabel!
    @IBOutlet weak var organization: UILabel!
    @IBOutlet weak var contribution: UILabel!
    @IBOutlet weak var rank: UILabel!
    @IBOutlet weak var rating: UILabel!
    @IBOutlet weak var email: UILabel!
    @IBOutlet weak var vkId: UILabel!
    
    @IBOutlet weak var contentView: UIView!
    
    var presenter: UserDetailViewPresenterProtocol!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        contentView.roundCorners([.topLeft, .topRight], radius: 20)
        presenter.setUser()
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(hideUserDetail))
        view.addGestureRecognizer(tap)
    }
    
    @objc func hideUserDetail(_ sender: UITapGestureRecognizer) {
        dismiss(animated: true)
    }
}

extension UserDetailViewController: UserDetailViewProtocol {
    func setUser(user: User?) {
        if let url = user?.titlePhoto, let urlImage = URL(string: "http:\(url)" ) {
            profileImage.load(url: urlImage)
            profileImage.isHidden = false
        }
        
        profileImage.makeRounded()
//        online.text = String.getDateValue(title: nil, UNIX: user?.lastOnlineTimeSeconds)
//        contribution.text = String.getTitledValue(title: "Друзья", value: user?.contribution)
//        rating.text = String.getTitledValue(title: "Рейтинг", value: user?.rating)
//        handle.text = String.getTitledValue(title: nil, value: user?.handle)
//        firstName.text = String.getTitledValue(title: "Имя", value: user?.firstName)
//        lastName.text = String.getTitledValue(title: "Фамилия", value: user?.lastName)
//        country.text = String.getTitledValue(title: "Страна", value: user?.country)
//        city.text = String.getTitledValue(title: "Город", value: user?.city)
//        organization.text = String.getTitledValue(title: "Организачия", value: user?.organization)
//        rank.text = String.getTitledValue(title: "Ранг", value: user?.rank)
//        email.text = String.getTitledValue(title: "E-mail", value: user?.email)
//        vkId.text = String.getTitledValue(title: "ВКонтакте", value: user?.vkId)
    }
}
