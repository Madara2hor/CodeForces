//
//  HomeViewController.swift
//  Twitter
//
//  Created by Madara2hor on 04.08.2020.
//  Copyright © 2020 Madara2hor. All rights reserved.
//

import UIKit

class ContestsViewController: UIViewController {

    @IBOutlet weak var contestTable: UITableView!
    @IBOutlet weak var reloadData: UIButton!
    @IBOutlet weak var gymFilter: UIButton!
    
    var presenter: ContestsViewPresenterProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        reloadData.makeCircle()
        reloadData.makeTransparentBlue()
        
        gymFilter.makeCircle()
        gymFilter.makeTransparentBlue()
        
        contestTable.register(UINib(nibName: "ContestCellView", bundle: nil), forCellReuseIdentifier: "ContestCell")
        contestTable.tableFooterView = UIView()
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
    
}

extension ContestsViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter?.contests?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ContestCell", for: indexPath) as! ContestCell
        
        cell.setContestData(contest: presenter?.contests?[indexPath.row])
        
        return cell
    }
    
}

extension ContestsViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let contest = presenter?.contests?[indexPath.row]
        
        presenter?.showContestDetail(contest: contest, selectedIndex: self.tabBarController?.selectedIndex)
    }
    
}

extension ContestsViewController: ContestsViewProtocol {
    func success() {
        contestTable.reloadData()
        contestTable.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: true)
    }
    
    func failure(error: String?) {
        if presenter?.contests?.count == 0 {
            self.contestTable.setEmptyTableView(title: "Упс...", message: "Произошла ошибка загрузки данных")
        }
    }
    
    func removeEmptySubview() {
        if contestTable != nil {
            self.contestTable.restore()
        }
    }
    
    func setLoadingView() {
        view.setLoadingSubview()
    }
    
    func removeLoadingView() {
        view.removeLoadingSubview()
    }
}
