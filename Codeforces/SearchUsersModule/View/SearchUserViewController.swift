//
//  SearchViewController.swift
//  Twitter
//
//  Created by Madara2hor on 04.08.2020.
//  Copyright © 2020 Madara2hor. All rights reserved.
//

import UIKit

class SearchUserViewController: UIViewController {
    
    @IBOutlet private weak var searchBar: UISearchBar!
    @IBOutlet private weak var userTableView: UITableView!
    
    @IBOutlet private weak var contentView: UIView!
    
    @IBOutlet private weak var clearPage: UIButton!
    @IBOutlet private weak var reloadData: UIButton!
    @IBOutlet private weak var menu: UIButton!
    
    @IBOutlet private weak var clearRightAnchor: NSLayoutConstraint!
    @IBOutlet private weak var reloadRightAnchor: NSLayoutConstraint!
    
    var isMenuShown = false
    
    var presenter: SearchUserViewPresenterProtocol!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        userTableView.register(InfoCell.self)
        userTableView.tableFooterView = UIView()
        setupTableHeader()
        
        setupMenuItemStyle(item: clearPage)
        setupMenuItemStyle(item: reloadData)
        setupMenuItemStyle(item: menu)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        hideMenuItems()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        contentView.endEditing(true)
    }
    
    @IBAction private func clearPageDidTapped(_ sender: UIButton) {
        searchBar.text = .empty
        presenter?.searchedUser = nil
        
        view.removeMessageSubview()
        userTableView.tableHeaderView = UIView()
    }
    
    @IBAction private func reloadDataDidTapped(_ sender: UIButton) {
        guard presenter?.searchedUser != nil else {
            return
        }
        
        presenter?.getUser()
    }
    
    @IBAction private func menuDidTpped(_ sender: Any) {
        if isMenuShown {
            hideMenuItems()
        } else {
            showMenuItems()
        }
    }
    
    private func setupTableHeader() {
        let headerView = UserHeaderView()

        userTableView.tableHeaderView = headerView
    }
    
    private func setupMenuItemStyle(item: UIView) {
        item.makeCircle()
        item.makeTransparentBlue()
    }
    
    private func showMenuItems() {
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
        
        isMenuShown = true
    }
    
    private func hideMenuItems() {
        view.hideViewWithAnimation(
            duration: 0.5,
            delay: 0.3,
            anchor: reloadRightAnchor,
            anchorConstant: 20,
            view: reloadData
        )
        view.hideViewWithAnimation(
            duration: 0.5,
            delay: .zero,
            anchor: clearRightAnchor,
            anchorConstant: 20,
            view: clearPage
        )

        menu.setImage(UIImage(systemName: "chevron.left"), for: .normal)
        
        isMenuShown = false
    }
}

extension SearchUserViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return .zero
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
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
        setupTableHeader()
        
        userTableView.reloadData()
//        if let url = presenter.user?.titlePhoto, let urlImage = URL(string: "http:\(url)" ) {
//            profileImage.load(url: urlImage)
//            profileImage.isHidden = false
//        }
//
//        profileImage.makeRounded()
        
//        online.text = String.getDateValue(title: nil, UNIX: presenter.user?.lastOnlineTimeSeconds)
//        contribution.text = String.getTitledValue(title: "Друзья", value: presenter.user?.contribution)
//        rating.text = String.getTitledValue(title: "Рейтинг", value: presenter.user?.rating)
//        handle.text = String.getTitledValue(title: nil, value: presenter.user?.handle)
//        firstName.text = String.getTitledValue(title: "Имя", value: presenter.user?.firstName)
//        lastName.text = String.getTitledValue(title: "Фамилия", value: presenter.user?.lastName)
//        country.text = String.getTitledValue(title: "Страна", value: presenter.user?.country)
//        city.text = String.getTitledValue(title: "Город", value: presenter.user?.city)
//        organization.text = String.getTitledValue(title: "Организачия", value: presenter.user?.organization)
//        rank.text = String.getTitledValue(title: "Ранг", value: presenter.user?.rank)
//        email.text = String.getTitledValue(title: "E-mail", value: presenter.user?.email)
//        vkId.text = String.getTitledValue(title: "ВКонтакте", value: presenter.user?.vkId)
    }
    
    func failure(error: String?) {
        guard let error = error else {
            return
        }
        
        userTableView.tableHeaderView = UIView()
        
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
        
        if cleanText == .empty {
            presenter.searchedUser = nil
            removeMessageSubview()
            userTableView.tableHeaderView = UIView()
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
