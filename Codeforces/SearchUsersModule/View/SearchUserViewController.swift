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
        
        view.removeMessageSubview()
        hideProfileItems()
    }
    
    @IBAction func reloadDataDidTapped(_ sender: UIButton) {
        guard presenter?.searchedUser != nil else {
            return
        }
        
        presenter?.getUser()
    }
    
    @IBAction func menuDidTpped(_ sender: Any) {
        if menu.tag == .zero {
            showMenuItems()
        } else {
            hideMenuItems()
        }
    }
    
    func showMenuItems() {
        if isMenuShow {
            return
        }
        
        view.showViewWithAnimation(
            duration: 0.5,
            delay: .zero,
            anchor: reloadRightAnchor,
            anchorConstant: 20,
            view: reloadData
        )
        view.showViewWithAnimation(
            duration: 0.5,
            delay: 0.3,
            anchor: clearRightAnchor,
            anchorConstant: 20,
            view: clearPage
        )

        menu.setImage(UIImage(systemName: "chevron.right"), for: .normal)
        menu.tag = 1
        
        isMenuShow = true
    }
    
    func hideMenuItems() {
        if isMenuShow == false {
            return
        }
        
        view.hideViewWithAnimation(
            duration: 0.5,
            delay: 0.3,
            anchor: reloadRightAnchor,
            anchorConstant: 20,
            view: reloadData
        )
        view.hideViewWithAnimation(
            duration: 0.5,
            delay: 0,
            anchor: clearRightAnchor,
            anchorConstant: 20,
            view: clearPage
        )

        menu.setImage(UIImage(systemName: "chevron.left"), for: .normal)
        menu.tag = .zero
        
        isMenuShow = false
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
            profileImage.load(url: urlImage)
            profileImage.isHidden = false
        }
        
        profileImage.makeRounded()
        
        online.text = String().getDateValue(title: nil, UNIX: presenter.user?.lastOnlineTimeSeconds)
        contribution.text = String().getTitledValue(title: "Друзья", value: presenter.user?.contribution)
        rating.text = String().getTitledValue(title: "Рейтинг", value: presenter.user?.rating)
        handle.text = String().getTitledValue(title: nil, value: presenter.user?.handle)
        firstName.text = String().getTitledValue(title: "Имя", value: presenter.user?.firstName)
        lastName.text = String().getTitledValue(title: "Фамилия", value: presenter.user?.lastName)
        country.text = String().getTitledValue(title: "Страна", value: presenter.user?.country)
        city.text = String().getTitledValue(title: "Город", value: presenter.user?.city)
        organization.text = String().getTitledValue(title: "Организачия", value: presenter.user?.organization)
        rank.text = String().getTitledValue(title: "Ранг", value: presenter.user?.rank)
        email.text = String().getTitledValue(title: "E-mail", value: presenter.user?.email)
        vkId.text = String().getTitledValue(title: "ВКонтакте", value: presenter.user?.vkId)
    }
    
    func failure(error: String?) {
        guard let error = error else {
            return
        }
        
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
