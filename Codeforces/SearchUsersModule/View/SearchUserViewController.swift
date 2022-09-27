//
//  SearchUserViewController.swift
//  Codeforces
//
//  Created by Madara2hor on 04.08.2020.
//  Copyright © 2020 Madara2hor. All rights reserved.
//

import UIKit

final class SearchUserViewController: UIViewController {
    
    var presenter: SearchUserViewPresenterProtocol?
    
    @IBOutlet private weak var searchBar: UISearchBar!
    @IBOutlet private weak var userTableView: UITableView!
    
    @IBOutlet private weak var clearPage: UIButton!
    @IBOutlet private weak var reloadData: UIButton!
    @IBOutlet private weak var menu: UIButton!
    
    @IBOutlet private weak var clearRightAnchor: NSLayoutConstraint!
    @IBOutlet private weak var reloadRightAnchor: NSLayoutConstraint!
    
    private var isMenuShown = false

    override func viewDidLoad() {
        super.viewDidLoad()
        
        userTableView.register(InfoCell.self)
        userTableView.register(UserHeaderView.self)
        userTableView.tableFooterView = UIView()
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(tableViewDidTap))
        userTableView.addGestureRecognizer(tap)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        if isMenuShown {
            hideMenuItems()
        }
    }
    
    @IBAction private func clearPageDidTapped(_ sender: UIButton) {
        searchBar.text = .empty
        presenter?.clearUserTapped()
        
        view.removeMessageSubview()
        
        userTableView.tableHeaderView = nil
        userTableView.reloadData()
    }
    
    @IBAction private func reloadDataDidTapped(_ sender: UIButton) {
        presenter?.searchUserTapped()
    }
    
    @IBAction private func menuDidTpped(_ sender: Any) {
        if isMenuShown {
            hideMenuItems()
        } else {
            showMenuItems()
        }
    }
    
    @objc private func tableViewDidTap() {
        view.endEditing(true)
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
        return presenter?.userInfo.count ?? .zero
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard
            let userInfo = presenter?.userInfo,
            indexPath.row < userInfo.count
        else {
            return UITableViewCell()
        }
        
        let cell: InfoCell = userTableView.dequeueReusableCell(for: indexPath)
        
        let infoModel = userInfo[indexPath.row]
        let reoundDelimeterInfo = RoundCornersService.getRoundDelimeterInfo(
            for: infoModel,
            allItems: userInfo
        )
        let cellModel = InfoCellViewModel(
            info: infoModel,
            roundDelimeterInfo: reoundDelimeterInfo
        )
        
        cell.update(with: cellModel)
        
        return cell
    }
}

extension SearchUserViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return presenter?.userHeaderModel == nil ? .zero : UserHeaderView.height
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let model = presenter?.userHeaderModel else {
            userTableView.tableHeaderView = nil
            return nil
        }
        
        let headerView = userTableView.dequeueReusableHeaderFooterView(UserHeaderView.self)
        headerView.setup(with: model)
        
        let containerView: UIView = UIView()
        containerView.layoutSubview(headerView)
        containerView.backgroundColor = .detailBackground
        
        return containerView
    }
}

extension SearchUserViewController: SearchUserViewProtocol {
    
    func setLoadingView() {
        view.setLoadingSubview()
    }
    
    func removeLoadingView() {
        view.removeLoadingSubview()
    }
    
    func success() {
        userTableView.reloadData()
    }
    
    func failure(error: String?) {
        userTableView.tableHeaderView = UIView()
        
        // TODO: handle failure
    }
}

extension SearchUserViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        let cleanText = searchText.replacingOccurrences(of: " ", with: "")
        searchBar.text = cleanText
        
        if cleanText == .empty {
            presenter?.clearUserTapped()
            
            userTableView.tableHeaderView = nil
        } else {
            presenter?.searchedUserUpdated(with: cleanText.lowercased())
        }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        presenter?.searchUserTapped()
        
        view.endEditing(true)
    }
}
