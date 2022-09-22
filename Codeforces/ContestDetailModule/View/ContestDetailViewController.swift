//
//  ContestDetailViewController.swift
//  Codeforces
//
//  Created by Madara2hor on 10.08.2020.
//  Copyright © 2020 Madara2hor. All rights reserved.
//

import UIKit

class ContestDetailViewController: UIViewController {
    
    @IBOutlet private weak var detailTableView: UITableView!
    @IBOutlet private weak var scrollView: UIScrollView!
    
    var presenter: ContestDetailViewPresenterProtocol?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        detailTableView.register(ContestDetailCell.self)
        detailTableView.tableFooterView = UIView()
        
        scrollView.roundCorners([.topLeft, .topRight], radius: 20)
        presenter?.setContest()
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(hideUserDetail))
        view.addGestureRecognizer(tap)
    }
    
    @objc private func hideUserDetail(_ sender: UITapGestureRecognizer) {
        dismiss(animated: true)
    }
}

extension ContestDetailViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter?.getContenstInfo().count ?? .zero
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard
            let contestInfo = presenter?.getContenstInfo(),
            indexPath.row < contestInfo.count
        else {
            return UITableViewCell()
        }
        
        let cell: ContestDetailCell = detailTableView.dequeueReusableCell(for: indexPath)
        
        cell.setup(with: contestInfo[indexPath.row])
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return presenter?.getContestName()
    }
}

extension ContestDetailViewController: ContestDetailViewProtocol {
    
    func setContest() {
        detailTableView.reloadData()
    }
}
