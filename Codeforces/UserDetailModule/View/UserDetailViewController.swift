//
//  UserDetailViewController.swift
//  Codeforces
//
//  Created by Madara2hor on 04.08.2020.
//  Copyright © 2020 Madara2hor. All rights reserved.
//

import UIKit

final class UserDetailViewController: UIViewController {
    
    private enum Constants {
        
        static let containerViewCornerRadius: CGFloat = 20
    }
    
    var presenter: UserDetailViewPresenterProtocol!
    
    @IBOutlet private weak var userDetailTableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        userDetailTableView.register(InfoCell.self)
        userDetailTableView.register(UserHeaderView.self)
        userDetailTableView.tableFooterView = UIView()
        
        presenter.requestUser()
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(hideUserDetail))
        view.addGestureRecognizer(tap)
    }
    
    @objc func hideUserDetail(_ sender: UITapGestureRecognizer) {
        dismiss(animated: true)
    }
}

extension UserDetailViewController: UITableViewDataSource {
    
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
        
        let cell: InfoCell = userDetailTableView.dequeueReusableCell(for: indexPath)
        
        cell.update(with: userInfo[indexPath.row])
        
        return cell
    }
}

extension UserDetailViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return presenter?.userHeaderModel == nil ? .zero : UserHeaderView.height
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let model = presenter?.userHeaderModel else {
            userDetailTableView.tableHeaderView = nil
            return nil
        }
        
        let headerView = userDetailTableView.dequeueReusableHeaderFooterView(UserHeaderView.self)
        headerView.setup(with: model)
        
        let containerView: UIView = UIView()
        containerView.layoutSubview(headerView)
        containerView.backgroundColor = .systemBackground
        
        return containerView
    }
}

extension UserDetailViewController: UserDetailViewProtocol {
    
    func updateUser() {
        userDetailTableView.reloadData()
    }
}
