//
//  SchoolInfoTableViewHelper.swift
//  20190515-EdmundHolderbaum-NYCSchools
//
//  Created by Edmund Holderbaum on 5/16/19.
//  Copyright © 2019 Dawn Trigger Enterprises. All rights reserved.
//

import Foundation

struct SchoolInfoTableViewHelper {
    
    var overviewDict: [String : String] = [:]
    var demographicsDict: [String : String] = [:]
    var locationContactDict: [String : String] = [:]
    var extraCurricularDict: [String : String] = [:]
    var programInfoDict: [String : String] = [:]
    var sectionsDict: [Section : [String: String]] = [:]
    enum Section: String {
        case overview = "Overview", demographics = "Demographics", location =  "Location & Contact Info", program = "Curriculum/Program Info", extracurricular = "Extracurricular Activities"
        static var all: [Section] = [ .overview, .demographics, .location, .program, .extracurricular ]
    }
    
    init(school: School) {
        let overviewDict: [String: String?] = ["Overview:" : school.overview, "Academic Opportunities: " : school.academicOpportunities, "ELL Programs: " : school.ellPrograms, "Language Classes: " : school.languageClasses, "Start Time: " : school.startTime, "End Time: " : school.endTime,  "AP Courses: " : school.apCourses, "Additional Information: " : school.additionalInfo]
        self.overviewDict = overviewDict.compactMapValues({$0})
        sectionsDict[.overview] = self.overviewDict
        
        let demographicsDict: [String : String?] = ["Total Students: " : school.totalStudents, "Girls: " : school.girls, "Boys: " : school.boys,  "Graduation Rate: " : school.graduationRate]
        self.demographicsDict = demographicsDict.compactMapValues({$0})
        sectionsDict[.demographics] = self.demographicsDict
        
        let locationContactDict: [String : String?]  = [ "School Board District: " : school.councilDistrict, "Neighborhood: " : school.neighborhood, "Phone Number: " : school.phoneNumber, "School Email: " : school.email, "School Website: " : school.website, "Nearby Subways:" : school.subway, "Nearby Busses: " : school.bus ]
        locationContactDict.forEach({self.locationContactDict[$0] = $1})
        sectionsDict[.location] = self.locationContactDict
        
        let extraCurricularsDict: [String : String?]  = [ "Extracurricular Activities:" : school.extracurricularActivities, "Boys' PSAL Sports: " : school.sportsBoys, "Girls' PSAL Sports: " : school.sportsGirls,  "Coed PSAL Sports: " : school.sportsCoed ]
        self.extraCurricularDict = extraCurricularsDict.compactMapValues({$0})
        sectionsDict[.extracurricular] = self.extraCurricularDict
        
        let programInfoDict: [String : String?] = ["Program Name: " :  school.programName, "Program Description:" : school.programDescription, "Number of Seats: " : school.programSeats, "Number of Applicants: " : school.programApplicants, "How to Apply: " : school.programApplicationMethod]
        self.programInfoDict = programInfoDict.compactMapValues({$0})
        sectionsDict[.program] = self.programInfoDict
    }
    
    func infoFor(_ number: Int)-> [String:String] {
        let section = Section.all[number]
        return sectionsDict[section] ?? [:]
    }
    
    func infoFor(_ indexPath: IndexPath)-> (name: String, info: String) {
        let section = infoFor(indexPath.section)
        //reverse alpha order seems to be the closest way to make this info make sense without MORE GODDAMN DICTIONARIES fuck this API
        //by the way, the function below separates the dictionaries into arrays of Key,Value pairs then orders them reverse alpha by key
        let reverseOrder = section.map({return($0,$1)}).sorted(by: {$0.0 > $1.0})
        return reverseOrder[indexPath.row]
    }
    
    func titleFor(section: Int)-> String {
        let sectionTitle = Section.all[section].rawValue
        return sectionTitle
    }
    
}
