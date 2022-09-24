//
//  ContestDetailViewController.swift
//  Codeforces
//
//  Created by Madara2hor on 10.08.2020.
//  Copyright © 2020 Madara2hor. All rights reserved.
//

import UIKit

final class ContestDetailViewController: UIViewController {
    
    private enum Constants {
        
        static let containerViewCornerRadius: CGFloat = 20
    }
    
    var presenter: ContestDetailViewPresenterProtocol?
    
    @IBOutlet private weak var contestDetailTableView: UITableView!
    @IBOutlet private weak var containerView: UIView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        contestDetailTableView.register(InfoCell.self)
        contestDetailTableView.tableFooterView = UIView()
        
        containerView.roundCorners([.topLeft, .topRight], radius: Constants.containerViewCornerRadius)
        presenter?.requestContest()
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(hideUserDetail))
        view.addGestureRecognizer(tap)
    }
    
    @objc private func hideUserDetail(_ sender: UITapGestureRecognizer) {
        dismiss(animated: true)
    }
}

extension ContestDetailViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter?.contestInfo.count ?? .zero
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard
            let contestInfo = presenter?.contestInfo,
            indexPath.row < contestInfo.count
        else {
            return UITableViewCell()
        }
        
        let cell: InfoCell = contestDetailTableView.dequeueReusableCell(for: indexPath)
        
        cell.update(with: contestInfo[indexPath.row])
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return presenter?.contestName
    }
}

extension ContestDetailViewController: ContestDetailViewProtocol {
    
    func updateContest() {
        contestDetailTableView.reloadData()
    }
}
