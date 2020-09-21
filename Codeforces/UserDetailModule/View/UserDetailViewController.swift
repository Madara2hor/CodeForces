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
    
    var presenter: UserDetailViewPresenterProtocol!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        presenter.setUser()
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(showFullScreenImage))
        profileImage.addGestureRecognizer(tap)
    }
    
    @objc func showFullScreenImage(_ sender: UITapGestureRecognizer) {
        let imageView = sender.view as! UIImageView
        let newImageView = UIImageView(image: imageView.image)
        newImageView.backgroundColor = UIColor.black
        newImageView.alpha = 0
        
        UIView.animate(withDuration: 0.3,
                       delay: 0,
                       options: .curveEaseInOut,
                       animations: {

                        newImageView.alpha += 1
                        newImageView.frame = UIScreen.main.bounds
                        newImageView.layoutIfNeeded()
        }, completion: nil)

        newImageView.contentMode = .scaleAspectFit
        newImageView.isUserInteractionEnabled = true
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissFullscreenImage))
        newImageView.addGestureRecognizer(tap)
        
        self.view.addSubview(newImageView)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2, execute: {
            self.navigationController?.isNavigationBarHidden = true
            self.tabBarController?.tabBar.isHidden = true
        })
        
    }

    @objc func dismissFullscreenImage(_ sender: UITapGestureRecognizer) {
        let fullScreenImage = sender.view as! UIImageView
        UIView.animate(withDuration: 0.3,
                       delay: 0,
                       options: .curveEaseInOut,
                       animations: {
                        
                        fullScreenImage.frame = self.profileImage.frame
                        fullScreenImage.alpha -= 1
                        fullScreenImage.layoutIfNeeded()
        }, completion: nil)

        self.navigationController?.isNavigationBarHidden = false
        self.tabBarController?.tabBar.isHidden = false
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2, execute: {
            fullScreenImage.removeFromSuperview()
        })
    }

}

extension UserDetailViewController: UserDetailViewProtocol {
    func setUser(user: User?) {
        if let url = user?.titlePhoto, let urlImage = URL(string: "http:\(url)" ) {
            self.profileImage.load(url: urlImage)
            self.profileImage.isHidden = false
        }
        self.profileImage.makeRounded()
        self.online.text = String().getDateValue(title: nil, UNIX: user?.lastOnlineTimeSeconds)
        self.contribution.text = String().getTitledValue(title: "Друзья", value: user?.contribution)
        self.rating.text = String().getTitledValue(title: "Рейтинг", value: user?.rating)
        self.handle.text = String().getTitledValue(title: nil, value: user?.handle)
        self.firstName.text = String().getTitledValue(title: "Имя", value: user?.firstName)
        self.lastName.text = String().getTitledValue(title: "Фамилия", value: user?.lastName)
        self.country.text = String().getTitledValue(title: "Страна", value: user?.country)
        self.city.text = String().getTitledValue(title: "Город", value: user?.city)
        self.organization.text = String().getTitledValue(title: "Организачия", value: user?.organization)
        self.rank.text = String().getTitledValue(title: "Ранг", value: user?.rank)
        self.email.text = String().getTitledValue(title: "E-mail", value: user?.email)
        self.vkId.text = String().getTitledValue(title: "ВКонтакте", value: user?.vkId)
    }
}
