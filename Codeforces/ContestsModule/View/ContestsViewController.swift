//
//  HomeViewController.swift
//  Twitter
//
//  Created by Madara2hor on 04.08.2020.
//  Copyright © 2020 Madara2hor. All rights reserved.
//

import UIKit

class ContestsViewController: UIViewController {

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var contestTable: UITableView!
    @IBOutlet weak var reloadData: UIButton!
    @IBOutlet weak var gymFilter: UIButton!
    @IBOutlet weak var menu: UIButton!
    
    @IBOutlet weak var reloadRightAnchor: NSLayoutConstraint!
    @IBOutlet weak var gymRightAnchor: NSLayoutConstraint!
    
    var isMenuShow = false
    
    var presenter: ContestsViewPresenterProtocol!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupMenuItemStyle(item: reloadData)
        setupMenuItemStyle(item: gymFilter)
        setupMenuItemStyle(item: menu)
        
        contestTable.register(UINib(nibName: "ContestCellView", bundle: nil), forCellReuseIdentifier: "ContestCell")
        contestTable.tableFooterView = UIView()
    }
    
    func setupMenuItemStyle(item: UIView) {
        item.makeCircle()
        item.makeTransparentBlue()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        hideMenuItems()
    }
    
    @IBAction func gymFilterDidTapped(_ sender: UIButton) {
        if sender.tag == 0 {
            sender.setImage(UIImage(named: "outline_gym"), for: .normal)
            sender.tag = 1
            
            presenter?.gym = true
        } else {
            sender.setImage(UIImage(named: "outline_rating"), for: .normal)
            sender.tag = 0
            
            presenter?.gym = false
        }
        
        presenter?.getContests()
    }
    
    @IBAction func reloadDataDidTapped(_ sender: UIButton) {
        presenter?.getContests()
    }
    
    @IBAction func menuDidTapped(_ sender: Any) {
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
                                        anchor: gymRightAnchor,
                                        anchorConstant: 20,
                                        view: gymFilter)

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
                                        anchor: gymRightAnchor,
                                        anchorConstant: 20,
                                        view: gymFilter)

        self.menu.setImage(UIImage(systemName: "chevron.left"), for: .normal)
        self.menu.tag = 0
        
        isMenuShow = false
    }
    
}

extension ContestsViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        let lowerSearchText = searchText.lowercased()
        presenter.filtredContests = searchText.isEmpty ? presenter.contests : presenter.contests?.filter { contest -> Bool in
            return contest.name.lowercased().contains(lowerSearchText)
        }
        contestTable.reloadData()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        view.endEditing(true)
    }
}

extension ContestsViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter.filtredContests?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ContestCell", for: indexPath) as! ContestCell
        
        cell.setContestData(contest: presenter.filtredContests?[indexPath.row])
        
        return cell
    }
    
}

extension ContestsViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let contest = presenter?.filtredContests?[indexPath.row]
        
        presenter?.showContestDetail(contest: contest, selectedIndex: self.tabBarController?.selectedIndex)
    }
    
}

extension ContestsViewController: ContestsViewProtocol {
    func success() {
        contestTable.reloadData()
        contestTable.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: true)
    }
    
    func failure(error: String?) {
        self.contestTable.setEmptyTableView(title: "Упс...", message: error ?? "")
    }
    
    func setLoadingView() {
        self.view.setLoadingSubview()
    }
    
    func removeLoadingView() {
        self.view.removeLoadingSubview()
    }
    
    func removeMessageSubview() {
        if contestTable != nil {
            self.contestTable.restore()
        }
    }
}
