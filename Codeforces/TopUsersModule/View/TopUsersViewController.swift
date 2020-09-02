//
//  ViewController.swift
//  Twitter
//
//  Created by Madara2hor on 04.08.2020.
//  Copyright © 2020 Madara2hor. All rights reserved.
//

import UIKit

class TopUsersViewController: UIViewController {
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var topUsersTable: UITableView!
    @IBOutlet weak var ratingSort: UIButton!
    @IBOutlet weak var activeOnlyFilter: UIButton!
    @IBOutlet weak var reloadData: UIButton!
    
    var presenter: TopUsersViewPresenterProtocol!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        ratingSort.makeCircle()
        ratingSort.makeTransparentBlue()
        
        activeOnlyFilter.makeCircle()
        activeOnlyFilter.makeTransparentBlue()
        
        reloadData.makeCircle()
        reloadData.makeTransparentBlue()
        
        topUsersTable.register(UINib(nibName: "UserRatingCellView", bundle: nil), forCellReuseIdentifier: "UserRatingCell")
        topUsersTable.tableFooterView = UIView()
    }

    @IBAction func ratingSortDidTapped(_ sender: UIButton) {
        if sender.tag == 0 {
            sender.setImage(UIImage(systemName: "arrow.up"), for: .normal)
            sender.tag = 1
        } else {
            sender.setImage(UIImage(systemName: "arrow.down"), for: .normal)
            sender.tag = 0
        }
        presenter.sortTopUsers()
    }
    
    @IBAction func activeFilterDidTapped(_ sender: UIButton) {
        if sender.tag == 0 {
            sender.setImage(UIImage(systemName: "hare"), for: .normal)
            sender.tag = 1
            
            presenter.activeOnly = true
        } else {
            sender.setImage(UIImage(systemName: "tortoise"), for: .normal)
            sender.tag = 0
            
            presenter.activeOnly = false
        }
        
        presenter.getTopUsers()
    }
    
    @IBAction func reloadDataDidTapped(_ sender: UIButton) {
        presenter.getTopUsers()
    }
}

extension TopUsersViewController: TopUsersViewProtocol {
    func setLoadingView() {
        self.view.setLoadingSubview()
    }
    
    func removeLoadingView() {
        self.view.removeLoadingSubview()
    }
    
    func removeEmptySubview() {
        if topUsersTable != nil {
            topUsersTable.restore()
        }
    }
    
    func success() {
        searchBar.text = ""
        topUsersTable.reloadData()
        topUsersTable.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: true)
    }
    
    func failure(error: String?) {
        if presenter?.topUsers?.count == 0 {
            self.topUsersTable.setEmptyTableView(title: "Упс...", message: "Произошла ошибка загрузки данных")
        }
    }
    
    func topUsersSorted() {
        topUsersTable.reloadData()
        topUsersTable.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: true)
    }
}

extension TopUsersViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        let lowerSearchText = searchText.lowercased()
        presenter.filtredTopUsers = searchText.isEmpty ? presenter.topUsers : presenter.topUsers?.filter { user -> Bool in
            return user.handle.lowercased().contains(lowerSearchText)
        }
        topUsersTable.reloadData()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        view.endEditing(true)
    }

}

extension TopUsersViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter?.filtredTopUsers?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = topUsersTable.dequeueReusableCell(withIdentifier: "UserRatingCell", for: indexPath) as! UserRatingCell
        
        cell.setRatingData(user: presenter?.filtredTopUsers?[indexPath.row])
        return cell
    }
    
}

extension TopUsersViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let user = presenter.filtredTopUsers?[indexPath.row]
        
        presenter.showUserDetail(user: user, selectedIndex: self.tabBarController?.selectedIndex)
    }
    
}
