//
//  SchoolDetailVC.swift
//  20190515-EdmundHolderbaum-NYCSchools
//
//  Created by Edmund Holderbaum on 5/16/19.
//  Copyright © 2019 Dawn Trigger Enterprises. All rights reserved.
//

import UIKit

class SchoolDetailVC: UIViewController {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var mathAvg: UILabel!
    @IBOutlet weak var readingAvg: UILabel!
    @IBOutlet weak var writingAvg: UILabel!
    @IBOutlet weak var schoolInfoTable: UITableView!
    
    let fieldTitleAttributes: [NSAttributedString.Key : Any] = [
        NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 18)
    ]
    let fieldTextAttributes: [NSAttributedString.Key : Any] = [
        NSAttributedString.Key.font : UIFont.systemFont(ofSize: 14)
    ]
    
    let spacer = NSAttributedString(string:"\n\n")
    
    var school: School?
    var schoolViewHelper: SchoolInfoTableViewHelper?

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        if school?.avgSATScores == nil,
            var school = self.school{
            SATsQueryClient.getScoreFor(school.id, completion: { scores in
                guard let first = scores.first else {return}
                school.avgSATScores = first
                self.mathAvg.text = first.avgMath
                self.readingAvg.text = first.avgReading
                self.writingAvg.text = first.avgWriting
            })
        }
        schoolInfoTable.rowHeight = UITableView.automaticDimension
    }
    
    func setup() {
        guard let school = school else { return }
        
        titleLabel.text = school.name
        addressLabel.text = school.address
        
        if let scores = school.avgSATScores {
            mathAvg.text = scores.avgMath
            readingAvg.text = scores.avgReading
            writingAvg.text = scores.avgWriting
        }
        
        schoolInfoTable.reloadData()
        schoolViewHelper = SchoolInfoTableViewHelper(school: school)
    }

}

extension SchoolDetailVC: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return schoolViewHelper?.sectionsDict.keys.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return schoolViewHelper?.infoFor(section).keys.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return schoolViewHelper?.titleFor(section: section)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = schoolInfoTable.dequeueReusableCell(withIdentifier: "infoCell") as! InfoCell
        if let info = schoolViewHelper?.infoFor(indexPath) {
            cell.attributeInfoLabel.text = info.info
            cell.attributeNameLabel.text = info.name
        }
        return cell
    }
    
}
