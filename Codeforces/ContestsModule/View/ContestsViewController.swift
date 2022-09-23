//
//  HomeViewController.swift
//  Twitter
//
//  Created by Madara2hor on 04.08.2020.
//  Copyright © 2020 Madara2hor. All rights reserved.
//

import UIKit

class ContestsViewController: UIViewController {
    
    private enum Constants {
        
        
    }
    
    var presenter: ContestsViewPresenterProtocol!

    @IBOutlet private weak var searchBar: UISearchBar!
    @IBOutlet private weak var contestTable: UITableView!
    @IBOutlet private weak var reloadData: UIButton!
    @IBOutlet private weak var gymFilter: UIButton!
    @IBOutlet private weak var menu: UIButton!
    
    @IBOutlet private weak var reloadRightAnchor: NSLayoutConstraint!
    @IBOutlet private weak var gymRightAnchor: NSLayoutConstraint!
    
    private var isMenuShown = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        contestTable.register(ContestCell.self)
        contestTable.tableFooterView = UIView()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        hideMenuItems()
    }
    
    @IBAction private func gymFilterDidTapped(_ sender: UIButton) {
        presenter.filterByGym()
    }
    
    @IBAction private func reloadDataDidTapped(_ sender: UIButton) {
        presenter.requestContests()
    }
    
    @IBAction private func menuDidTapped(_ sender: Any) {
        if isMenuShown {
            hideMenuItems()
        } else {
            showMenuItems()
        }
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
            anchor: gymRightAnchor,
            anchorConstant: 20,
            view: gymFilter
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
            anchor: gymRightAnchor,
            anchorConstant: 20,
            view: gymFilter
        )

        menu.setImage(UIImage(systemName: "chevron.left"), for: .normal)
        
        isMenuShown = false
    }
}

extension ContestsViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        presenter.searchContest(by: searchText)
        
        contestTable.reloadData()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        view.endEditing(true)
    }
}

extension ContestsViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter.contests?.count ?? .zero
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: ContestCell = tableView.dequeueReusableCell(for: indexPath)
        
        cell.update(with: presenter.contests?[indexPath.row])
        
        return cell
    }
}

extension ContestsViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let contest = presenter?.contests?[indexPath.row]
        
        presenter?.showContestDetail(
            contest: contest,
            selectedIndex: tabBarController?.selectedIndex
        )
    }
}

extension ContestsViewController: ContestsViewProtocol {
    
    func updateGymFilterButton(isFiltred: Bool) {
        if isFiltred {
            gymFilter.setImage(UIImage(named: "outline_gym"), for: .normal)
        } else {
            gymFilter.setImage(UIImage(named: "outline_rating"), for: .normal)
        }
    }
    
    func success() {
        contestTable.reloadData()
        contestTable.scrollToRow(
            at: IndexPath(row: .zero, section: .zero),
            at: .top,
            animated: true
        )
    }
    
    func failure(error: String?) {
        contestTable.setMessageBackgroundView(title: "Упс...", message: error ?? .empty)
    }
    
    func setLoadingView() {
        view.setLoadingSubview()
    }
    
    func removeLoadingView() {
        view.removeLoadingSubview()
    }
    
    func removeMessageSubview() {
        contestTable.restore()
    }
}
