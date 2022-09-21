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
        view.addGestureRecognizer(tap)
    }
    
    @objc func hideUserDetail(_ sender: UITapGestureRecognizer) {
        dismiss(animated: true)
    }
}

extension ContestDetailViewController: ContestDetailViewProtocol {
    
    func setContest(contest: Contest?) {
        name.text = String().getTitledValue(title: nil, value: contest?.name)
        type.text = String().getTitledValue(title: "Система оценки", value: contest?.type.rawValue)
        phase.text = String().getTitledValue(title: "Этап соревнований", value: contest?.phase.rawValue)
        duration.text = String().getDurationValue(title: "Продолжительность", seconds: contest?.durationSeconds)
        start.text = String().getDateValue(title: "Начало соревнования", UNIX: contest?.startTimeSeconds)
        preparedBy.text = String().getTitledValue(title: "Содатель", value: contest?.preparedBy)
        website.text = String().getTitledValue(title: "Сайт", value: contest?.websiteUrl)
        contestDescription.text = String().getTitledValue(title: "Описание", value: contest?.description)
        difficulty.text = String().getTitledValue(title: "Сложность", value: contest?.difficulty)
        kind.text = String().getTitledValue(title: "Тип соревнования", value: contest?.kind)
        region.text = String().getTitledValue(title: "Регион", value: contest?.icpcRegion)
        country.text = String().getTitledValue(title: "Страна", value: contest?.country)
        city.text = String().getTitledValue(title: "Город", value: contest?.city)
        season.text = String().getTitledValue(title: "Сезон", value: contest?.season)
    }
    
}
