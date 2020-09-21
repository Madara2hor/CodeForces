//
//  SearchViewController.swift
//  Twitter
//
//  Created by Madara2hor on 04.08.2020.
//  Copyright © 2020 Madara2hor. All rights reserved.
//

import UIKit

class SearchUserViewController: UIViewController {
    
    @IBOutlet weak var searchBar: UISearchBar!
    
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
    
    @IBOutlet weak var clearPage: UIButton!
    @IBOutlet weak var reloadData: UIButton!
    @IBOutlet weak var menu: UIButton!
    
    @IBOutlet weak var clearRightAnchor: NSLayoutConstraint!
    @IBOutlet weak var reloadRightAnchor: NSLayoutConstraint!
    
    var isMenuShow = false
    
    var presenter: SearchUserViewPresenterProtocol!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupMenuItemStyle(item: clearPage)
        setupMenuItemStyle(item: reloadData)
        setupMenuItemStyle(item: menu)
        
        hideProfileItems()
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(showFullScreenImage))
        profileImage.addGestureRecognizer(tap)
    }
    
    func setupMenuItemStyle(item: UIView) {
        item.makeCircle()
        item.makeTransparentBlue()
    }
    
    func hideProfileItems() {
        profileImage.isHidden = true
        handle.text = ""
        online.text = ""
        firstName.text = ""
        lastName.text = ""
        country.text = ""
        city.text = ""
        organization.text = ""
        contribution.text = ""
        rank.text = ""
        rating.text = ""
        email.text = ""
        vkId.text = ""
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        hideMenuItems()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        contentView.endEditing(true)
    }
    
    @IBAction func clearPageDidTapped(_ sender: UIButton) {
        searchBar.text = ""
        presenter?.searchedUser = nil
        self.view.removeMessageSubview()
        hideProfileItems()
    }
    
    @IBAction func reloadDataDidTapped(_ sender: UIButton) {
        if presenter?.searchedUser != nil {
            presenter?.getUser()
        }
    }
    
    @IBAction func menuDidTpped(_ sender: Any) {
        if self.menu.tag == 0 {
            self.showMenuItems()
        } else {
            self.hideMenuItems()
        }
    }
    
    func showMenuItems() {
        if isMenuShow { return }
        self.view.showViewWithAnimation(duration: 0.5,
                                        delay: 0,
                                        anchor: reloadRightAnchor,
                                        anchorConstant: 20,
                                        view: reloadData)
        self.view.showViewWithAnimation(duration: 0.5,
                                        delay: 0.3,
                                        anchor: clearRightAnchor,
                                        anchorConstant: 20,
                                        view: clearPage)

        self.menu.setImage(UIImage(systemName: "chevron.right"), for: .normal)
        self.menu.tag = 1
        
        isMenuShow = true
    }
    
    func hideMenuItems() {
        if !isMenuShow { return }
        self.view.hideViewWithAnimation(duration: 0.5,
                                        delay: 0.3,
                                        anchor: reloadRightAnchor,
                                        anchorConstant: 20,
                                        view: reloadData)
        self.view.hideViewWithAnimation(duration: 0.5,
                                        delay: 0,
                                        anchor: clearRightAnchor,
                                        anchorConstant: 20,
                                        view: clearPage)

        self.menu.setImage(UIImage(systemName: "chevron.left"), for: .normal)
        self.menu.tag = 0
        
        isMenuShow = false
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

extension SearchUserViewController: SearchUserViewProtocol {
    
    func setLoadingView() {
        view.setLoadingSubview()
    }
    
    func removeLoadingView() {
        view.removeLoadingSubview()
    }
    
    func removeMessageSubview() {
        view.removeMessageSubview()
    }
    
    func success() {
        if let url = presenter.user?.titlePhoto, let urlImage = URL(string: "http:\(url)" ) {
            self.profileImage.load(url: urlImage)
            self.profileImage.isHidden = false
        }
        self.profileImage.makeRounded()
        self.online.text = String().getDateValue(title: nil, UNIX: presenter.user?.lastOnlineTimeSeconds)
        self.contribution.text = String().getTitledValue(title: "Друзья", value: presenter.user?.contribution)
        self.rating.text = String().getTitledValue(title: "Рейтинг", value: presenter.user?.rating)
        self.handle.text = String().getTitledValue(title: nil, value: presenter.user?.handle)
        self.firstName.text = String().getTitledValue(title: "Имя", value: presenter.user?.firstName)
        self.lastName.text = String().getTitledValue(title: "Фамилия", value: presenter.user?.lastName)
        self.country.text = String().getTitledValue(title: "Страна", value: presenter.user?.country)
        self.city.text = String().getTitledValue(title: "Город", value: presenter.user?.city)
        self.organization.text = String().getTitledValue(title: "Организачия", value: presenter.user?.organization)
        self.rank.text = String().getTitledValue(title: "Ранг", value: presenter.user?.rank)
        self.email.text = String().getTitledValue(title: "E-mail", value: presenter.user?.email)
        self.vkId.text = String().getTitledValue(title: "ВКонтакте", value: presenter.user?.vkId)
    }
    
    func failure(error: String?) {
        guard let error = error else { return }
        
        hideProfileItems()
        if error != "handles: Field should not be empty" {
            self.view.setMessageSubview(title: "Эх...", message: "Пользователь не найден")
        } else {
            self.view.setMessageSubview(title: "Вау!", message: "Произошла непредвиденная ошибка")
        }
    }
    
}

extension SearchUserViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        let cleanText = searchText.replacingOccurrences(of: " ", with: "")
        searchBar.text = cleanText
        if cleanText == "" {
            presenter.searchedUser = nil
            removeMessageSubview()
            hideProfileItems()
        } else {
            presenter.searchedUser = cleanText.lowercased()
        }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if presenter.searchedUser != nil {
            presenter.getUser()
        }
        view.endEditing(true)
    }

}
