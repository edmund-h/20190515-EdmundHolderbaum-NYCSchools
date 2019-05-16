//
//  ViewController.swift
//  20190515-EdmundHolderbaum-NYCSchools
//
//  Created by Edmund Holderbaum on 5/16/19.
//  Copyright © 2019 Dawn Trigger Enterprises. All rights reserved.
//

import UIKit

class SchoolSearchVC: UIViewController {

    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var activityIndicatorArea: UIView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var selectMode: UISegmentedControl!
    @IBOutlet weak var tableView: UITableView!
    
    var schoolsByBorough: [Borough : [School]] = [:]
    var boroughs: [Borough] {
        return schoolsByBorough.keys.sorted(by: {$0.rawValue < $1.rawValue})
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        activityIndicatorArea.isHidden = true
        getSchools()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "schoolSegue" {
            let destVC = segue.destination as! SchoolDetailVC
            guard let indexPath = tableView.indexPathForSelectedRow else { return }
            let boro = boroughs[indexPath.section]
            guard let schools = schoolsByBorough[boro] else { return }
            let school = schools[indexPath.row]
            destVC.school = school
            tableView.deselectRow(at: indexPath, animated: false)
        }
    }
    
    func getSchools() {
        guard let text = searchBar.text else {return}
        toggleActivityIndicator()
        switch selectMode.selectedSegmentIndex {
        case 1:
            SchoolsQueryClient.querySchoolsBy(idNumber: text, completion: updateWithSchools)
        case 2:
            SchoolsQueryClient.querySchoolsBy(district: text, completion: updateWithSchools)
        case 3:
            SchoolsQueryClient.getSchoolsBy(score: text, completion: updateWithSchools)
        default:
            SchoolsQueryClient.querySchoolsBy(name: text, completion: updateWithSchools)
        }
    }
    
    func updateWithSchools(_ schools: [School]) {
        schoolsByBorough = SchoolBuilder.sortByBorough(schools)
        toggleActivityIndicator()
        tableView.reloadData()
    }

    func toggleActivityIndicator() {
        let unhide = activityIndicatorArea.isHidden
        if unhide {
            activityIndicatorArea.isHidden = false
            activityIndicator.startAnimating()
        } else {
            activityIndicatorArea.isHidden = true
            activityIndicator.stopAnimating()
        }
    }

}

extension SchoolSearchVC: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return schoolsByBorough.count
    }
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return boroughs.map({$0.rawValue})[section]
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let boro = boroughs[section]
        return schoolsByBorough[boro]?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "schoolCell", for: indexPath)
        let boro = boroughs[indexPath.section]
        guard let schools = schoolsByBorough[boro] else { return cell }
        let school = schools[indexPath.row]
        cell.textLabel?.text = school.name
        if school.name != school.programName {
            cell.detailTextLabel?.text = school.programName
        } else {
            cell.detailTextLabel?.text = nil
        }
        return cell
    }
    
}

extension SchoolSearchVC: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        getSchools()
    }
}
