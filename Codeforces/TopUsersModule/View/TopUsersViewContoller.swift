//
//  TopViewContoller.swift
//  Codeforces
//
//  Created by Madara2hor on 11.09.2020.
//  Copyright © 2020 Madara2hor. All rights reserved.
//

import UIKit

final class TopUsersViewContoller: UIViewController {
    
    private enum Constants {
        
        static let itemsPerRow: CGFloat = 4
        static let sectionInsets = UIEdgeInsets(top: 10.0, left: 10.0, bottom: 10.0, right: 10.0)
    }
    
    var presenter: TopUsersViewPresenterProtocol?
    
    @IBOutlet private weak var searchBar: UISearchBar!
    @IBOutlet private weak var topUsersCollection: UICollectionView!
    
    @IBOutlet private weak var ratingSort: UIButton!
    @IBOutlet private weak var activeOnlyFilter: UIButton!
    @IBOutlet private weak var reloadData: UIButton!
    @IBOutlet private weak var menu: UIButton!
    
    @IBOutlet private weak var reloadRightAnchor: NSLayoutConstraint!
    @IBOutlet private weak var activeRightAnchor: NSLayoutConstraint!
    @IBOutlet private weak var sortRightAnchor: NSLayoutConstraint!
    
    private var isMenuShown = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        topUsersCollection.register(UserCell.self)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        if isMenuShown {
            hideMenuItems()
        }
    }
    
    @IBAction private func ratingSortDidTapped(_ sender: UIButton) {
        guard let presenter = presenter else {
            return
        }
        
        if presenter.isHighToLow {
            ratingSort.setImage(UIImage(systemName: "arrow.down"), for: .normal)
        } else {
            ratingSort.setImage(UIImage(systemName: "arrow.up"), for: .normal)
        }
        
        presenter.sortTopUsersByRating()
    }
    
    @IBAction private func activeFilterDidTapped(_ sender: UIButton) {
        guard let presenter = presenter else {
            return
        }
        
        if presenter.isActiveOnly {
            activeOnlyFilter.setImage(UIImage(systemName: "tortoise"), for: .normal)
        } else {
            activeOnlyFilter.setImage(UIImage(systemName: "hare"), for: .normal)
        }
        
        presenter.requestTopUsers(isActiveOnly: !presenter.isActiveOnly)
    }
    
    @IBAction private func reloadDataDidTapped(_ sender: UIButton) {
        presenter?.requestTopUsers(isActiveOnly: nil)
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
            anchor: activeRightAnchor,
            anchorConstant: 20,
            view: activeOnlyFilter
        )
        view.showViewWithAnimation(
            duration: 0.5,
            delay: 0.6,
            anchor: sortRightAnchor,
            anchorConstant: 20,
            view: ratingSort
        )

        menu.setImage(UIImage(systemName: "chevron.right"), for: .normal)
        
        isMenuShown = true
    }
    
    private func hideMenuItems() {
        view.hideViewWithAnimation(
            duration: 0.5,
            delay: 0.6,
            anchor: reloadRightAnchor,
            anchorConstant: 20,
            view: reloadData
        )
        view.hideViewWithAnimation(
            duration: 0.5,
            delay: 0.3,
            anchor: activeRightAnchor,
            anchorConstant: 20,
            view: activeOnlyFilter
        )
        view.hideViewWithAnimation(
            duration: 0.5,
            delay: .zero,
            anchor: sortRightAnchor,
            anchorConstant: 20,
            view: ratingSort
        )
        
        menu.setImage(UIImage(systemName: "chevron.left"), for: .normal)
        
        isMenuShown = false
    }
}

extension TopUsersViewContoller: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        presenter?.searchTopUser(searchText)
        
        topUsersCollection.reloadData()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        view.endEditing(true)
    }
}

extension TopUsersViewContoller: UICollectionViewDelegateFlowLayout {

    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        let paddingSpace = Constants.sectionInsets.left * (Constants.itemsPerRow + .one)
        let availableWidth = view.frame.width - paddingSpace
        let widthPerItem = availableWidth / Constants.itemsPerRow
      
        return CGSize(width: widthPerItem, height: widthPerItem)
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        insetForSectionAt section: Int
    ) -> UIEdgeInsets {
        return Constants.sectionInsets
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        minimumLineSpacingForSectionAt section: Int
    ) -> CGFloat {
        return Constants.sectionInsets.left
    }
}

extension TopUsersViewContoller: UICollectionViewDataSource {
    
    func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int
    ) -> Int {
        return presenter?.topUsers?.count ?? .zero
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        guard
            let topUsers = presenter?.topUsers,
            indexPath.row < topUsers.count
        else {
            return UICollectionViewCell()
        }
        
        let userCell: UserCell = topUsersCollection.dequeueReusableCell(for: indexPath)
        
        userCell.setup(with: topUsers[indexPath.row])
        
        return userCell
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        didSelectItemAt indexPath: IndexPath
    ) {
        guard
            let topUsers = presenter?.topUsers,
            indexPath.row < topUsers.count
        else {
            return
        }
        
        let user = topUsers[indexPath.row]
        
        presenter?.showUserDetail(user: user, selectedIndex: tabBarController?.selectedIndex)
    }
}

extension TopUsersViewContoller: TopUsersViewProtocol {
    
    func success() {
        searchBar.text = .empty
        topUsersCollection.reloadData()
        
        if topUsersCollection.cellForItem(at: IndexPath(row: .zero, section: .zero)) != nil {
            topUsersCollection.scrollToItem(
                at: IndexPath(row: .zero, section: .zero),
                at: .top,
                animated: true
            )
        }
    }
    
    func failure(error: String?) {
        topUsersCollection.setMessageBackgroundView(title: "Упс...", message: error ?? .empty)
    }
    
    func topUsersSortedByRating() {
        topUsersCollection.reloadData()
        topUsersCollection.scrollToItem(at: IndexPath(row: .zero, section: .zero), at: .top, animated: true)
    }
    
    func setLoadingView() {
        view.setLoadingSubview()
    }
    
    func removeLoadingView() {
        view.removeLoadingSubview()
    }
    
    func removeMessageSubview() {
        if topUsersCollection != nil {
            topUsersCollection.restore()
        }
    }
}

final class NewTopUsersViewController: UIViewController {
    
    var presenter: TopUsersViewPresenterProtocol?
    
    @IBOutlet private weak var searchBar: UISearchBar!
    @IBOutlet private weak var topUsersTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        topUsersTableView.register(NewTopUserCell.self)
    }
}

extension NewTopUsersViewController: UITableViewDataSource {
    
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
        
        let cell: NewTopUserCell = tableView.dequeueReusableCell(for: indexPath)
        
        cell.update(with: topUsers[indexPath.row])
        
        return cell
    }
}

extension NewTopUsersViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let user = presenter?.topUsers?[indexPath.row]
        
        presenter?.showUserDetail(
            user: user,
            selectedIndex: tabBarController?.selectedIndex
        )
    }
}

extension NewTopUsersViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        presenter?.searchTopUser(searchText)
        
        topUsersTableView.reloadData()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        view.endEditing(true)
    }
}

extension NewTopUsersViewController: TopUsersViewProtocol {
    
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
        topUsersTableView.setMessageBackgroundView(title: "Упс...", message: error ?? .empty)
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
    
    func removeMessageSubview() {
        if topUsersTableView != nil {
            topUsersTableView.restore()
        }
    }
}
