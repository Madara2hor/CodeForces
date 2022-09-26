//
//  ContestsViewController.swift
//  Codeforces
//
//  Created by Madara2hor on 04.08.2020.
//  Copyright © 2020 Madara2hor. All rights reserved.
//

import UIKit

final class ContestsViewController: UIViewController {
    
    var presenter: ContestsViewPresenterProtocol?

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
        
        presenter?.requestContests()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        if isMenuShown {
            hideMenuItems()
        }
    }
    
    @IBAction private func gymFilterDidTapped(_ sender: UIButton) {
        guard let presenter = presenter else {
            return
        }
        
        if presenter.isFiltredByGym {
            gymFilter.setImage(UIImage(named: "outline_rating"), for: .normal)
        } else {
            gymFilter.setImage(UIImage(named: "outline_gym"), for: .normal)
        }
        
        presenter.filterByGym()
    }
    
    @IBAction private func reloadDataDidTapped(_ sender: UIButton) {
        presenter?.requestContests()
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
        presenter?.searchContest(by: searchText)
        
        contestTable.reloadData()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        view.endEditing(true)
    }
}

extension ContestsViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return presenter?.contestsSections.count ?? .zero
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter?.contestsSections[section].models.count ?? .zero
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return presenter?.contestsSections[section].title
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard
            let contests = presenter?.contestsSections[indexPath.section].models,
            indexPath.row < contests.count
        else {
            return UITableViewCell()
        }
        
        let cell: ContestCell = tableView.dequeueReusableCell(for: indexPath)
        
        cell.update(with: contests[indexPath.row])
        
        return cell
    }
}

extension ContestsViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let contest = presenter?.contestsSections[indexPath.section].models[indexPath.row]
        
        presenter?.showContestDetail(
            contest: contest,
            selectedIndex: tabBarController?.selectedIndex
        )
    }
}

extension ContestsViewController: ContestsViewProtocol {
    
    func success() {
        contestTable.reloadData()
        contestTable.scrollToRow(
            at: IndexPath(row: .zero, section: .zero),
            at: .top,
            animated: true
        )
    }
    
    func failure(error: String?) {
        // TODO: handle failure
    }
    
    func setLoadingView() {
        view.setLoadingSubview()
    }
    
    func removeLoadingView() {
        view.removeLoadingSubview()
    }
}
