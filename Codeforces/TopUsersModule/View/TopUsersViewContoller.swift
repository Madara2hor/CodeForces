//
//  TopViewContoller.swift
//  Codeforces
//
//  Created by Madara2hor on 11.09.2020.
//  Copyright © 2020 Madara2hor. All rights reserved.
//

import UIKit

class TopUsersViewContoller: UIViewController {
    
    private enum Constants {
        
        static let itemsPerRow: CGFloat = 4
        static let sectionInsets = UIEdgeInsets(top: 10.0, left: 10.0, bottom: 10.0, right: 10.0)
    }

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var topUsersCollection: UICollectionView!
    
    @IBOutlet weak var ratingSort: UIButton!
    @IBOutlet weak var activeOnlyFilter: UIButton!
    @IBOutlet weak var reloadData: UIButton!
    @IBOutlet weak var menu: UIButton!
    
    @IBOutlet weak var reloadRightAnchor: NSLayoutConstraint!
    @IBOutlet weak var activeRightAnchor: NSLayoutConstraint!
    @IBOutlet weak var sortRightAnchor: NSLayoutConstraint!
    
    var isMenuShow = false
    var presenter: TopUsersViewPresenterProtocol!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        topUsersCollection.register(UserCell.nib(), forCellWithReuseIdentifier: "\(UserCell.reuseId)")
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        hideMenuItems()
    }
    
    @IBAction func ratingSortDidTapped(_ sender: UIButton) {
        presenter.sortTopUsers()
    }
    
    @IBAction func activeFilterDidTapped(_ sender: UIButton) {
        if sender.tag == .zero {
            sender.setImage(UIImage(systemName: "tortoise"), for: .normal)
            sender.tag = 1
            
            presenter.activeOnly = false
        } else {
            sender.setImage(UIImage(systemName: "hare"), for: .normal)
            sender.tag = .zero
            
            presenter.activeOnly = true
        }
        
        presenter.getTopUsers()
    }
    
    @IBAction func reloadDataDidTapped(_ sender: UIButton) {
        presenter.getTopUsers()
    }
    
    @IBAction func menuDidTapped(_ sender: Any) {
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
        menu.tag = 1
        
        isMenuShow = true
    }
    
    func hideMenuItems() {
        if isMenuShow == false {
            return
        }
        
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
        menu.tag = 0
        
        isMenuShow = false
    }

}

extension TopUsersViewContoller: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        let lowerSearchText = searchText.lowercased()
        presenter.filtredTopUsers = searchText.isEmpty
            ? presenter.topUsers
            : presenter.topUsers?.filter { user -> Bool in
                return user.handle.lowercased().contains(lowerSearchText)
            }
        
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
        return presenter.filtredTopUsers?.count ?? .zero
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        guard let userCell = topUsersCollection.dequeueReusableCell(withReuseIdentifier:  "\(UserCell.reuseId)", for: indexPath) as? UserCell else {
            return UICollectionViewCell()
        }
        
        userCell.setup(with: presenter.filtredTopUsers?[indexPath.row])
        
        return userCell
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        didSelectItemAt indexPath: IndexPath
    ) {
        let user = presenter.filtredTopUsers?[indexPath.row]
        
        presenter.showUserDetail(user: user, selectedIndex: self.tabBarController?.selectedIndex)
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
    
    func topUsersSorted() {
        if ratingSort.tag == .zero {
            ratingSort.setImage(UIImage(systemName: "arrow.up"), for: .normal)
            ratingSort.tag = 1
        } else {
            ratingSort.setImage(UIImage(systemName: "arrow.down"), for: .normal)
            ratingSort.tag = .zero
        }
        
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
