//
//  TopUsersViewContoller.swift
//  Codeforces
//
//  Created by Madara2hor on 11.09.2020.
//  Copyright © 2020 Madara2hor. All rights reserved.
//

import UIKit

final class TopUsersViewController: UIViewController {
    
    var presenter: TopUsersViewPresenterProtocol?
    
    @IBOutlet private weak var searchBar: UISearchBar!
    @IBOutlet private weak var topUsersTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        topUsersTableView.register(TopUserCell.self)
        topUsersTableView.tableFooterView = UIView()
    }
}

extension TopUsersViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter?.topUsers?.count ?? .zero
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard
            let topUsers = presenter?.topUsers,
            indexPath.row < topUsers.count
        else {
            return UITableViewCell()
        }
        
        let cell: TopUserCell = tableView.dequeueReusableCell(for: indexPath)
        
        cell.update(with: topUsers[indexPath.row])
        
        return cell
    }
}

extension TopUsersViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let user = presenter?.topUsers?[indexPath.row]
        
        presenter?.showUserDetail(
            user: user,
            selectedIndex: tabBarController?.selectedIndex
        )
    }
}

extension TopUsersViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        presenter?.searchTopUser(searchText)
        
        topUsersTableView.reloadData()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        view.endEditing(true)
    }
}

extension TopUsersViewController: TopUsersViewProtocol {
    
    func success() {
        searchBar.text = .empty
        topUsersTableView.reloadData()
        
        topUsersTableView.scrollToRow(
            at: IndexPath(row: .zero, section: .zero),
            at: .top,
            animated: true
        )
    }
    
    func failure(error: String?) {
        // TODO: handle failure
    }
    
    func topUsersSortedByRating() {
        topUsersTableView.reloadData()
        topUsersTableView.scrollToRow(
            at: IndexPath(row: .zero, section: .zero),
            at: .top,
            animated: true
        )
    }
    
    func setLoadingView() {
        view.setLoadingSubview()
    }
    
    func removeLoadingView() {
        view.removeLoadingSubview()
    }
}
