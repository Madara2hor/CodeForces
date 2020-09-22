//
//  ContestDetailViewController.swift
//  Codeforces
//
//  Created by Madara2hor on 10.08.2020.
//  Copyright © 2020 Madara2hor. All rights reserved.
//

import UIKit

class ContestDetailViewController: UIViewController {
    
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var type: UILabel!
    @IBOutlet weak var phase: UILabel!
    @IBOutlet weak var duration: UILabel!
    @IBOutlet weak var start: UILabel!
    @IBOutlet weak var preparedBy: UILabel!
    @IBOutlet weak var website: UILabel!
    @IBOutlet weak var difficulty: UILabel!
    @IBOutlet weak var kind: UILabel!
    @IBOutlet weak var region: UILabel!
    @IBOutlet weak var country: UILabel!
    @IBOutlet weak var city: UILabel!
    @IBOutlet weak var season: UILabel!
    @IBOutlet weak var contestDescription: UILabel!
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var contentView: UIView!
    
    var presenter: ContestDetailViewPresenterProtocol?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        scrollView.roundCorners([.topLeft, .topRight], radius: 20)
        contentView.roundCorners([.topLeft, .topRight], radius: 20)
        presenter?.setContest()
        let tap = UITapGestureRecognizer(target: self, action: #selector(hideUserDetail))
        self.view.addGestureRecognizer(tap)
    }
    
    @objc func hideUserDetail(_ sender: UITapGestureRecognizer) {
        self.dismiss(animated: true)
    }
    
}

extension ContestDetailViewController: ContestDetailViewProtocol {
    
    func setContest(contest: Contest?) {
        self.name.text = String().getTitledValue(title: nil, value: contest?.name)
        self.type.text = String().getTitledValue(title: "Система оценки", value: contest?.type.rawValue)
        self.phase.text = String().getTitledValue(title: "Этап соревнований", value: contest?.phase.rawValue)
        self.duration.text = String().getDurationValue(title: "Продолжительность", seconds: contest?.durationSeconds)
        self.start.text = String().getDateValue(title: "Начало соревнования", UNIX: contest?.startTimeSeconds)
        self.preparedBy.text = String().getTitledValue(title: "Содатель", value: contest?.preparedBy)
        self.website.text = String().getTitledValue(title: "Сайт", value: contest?.websiteUrl)
        self.contestDescription.text = String().getTitledValue(title: "Описание", value: contest?.description)
        self.difficulty.text = String().getTitledValue(title: "Сложность", value: contest?.difficulty)
        self.kind.text = String().getTitledValue(title: "Тип соревнования", value: contest?.kind)
        self.region.text = String().getTitledValue(title: "Регион", value: contest?.icpcRegion)
        self.country.text = String().getTitledValue(title: "Страна", value: contest?.country)
        self.city.text = String().getTitledValue(title: "Город", value: contest?.city)
        self.season.text = String().getTitledValue(title: "Сезон", value: contest?.season)
    }
    
}
