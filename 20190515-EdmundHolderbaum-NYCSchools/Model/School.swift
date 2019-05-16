//
//  School.swift
//  20190515-EdmundHolderbaum-NYCSchools
//
//  Created by Edmund Holderbaum on 5/16/19.
//  Copyright © 2019 Dawn Trigger Enterprises. All rights reserved.
//

import Foundation

typealias JSON = [String:String]

struct School {
    
    var id: String
    var name: String
    var borough: Borough
    var overview: String
    var academicOpportunities: String?
    var ellPrograms: String?
    var languageClasses: String?
    var apCourses: String?
    var diplomaEndorsements: String?
    var neighborhood: String
    var location: String
    var phoneNumber: String?
    var email: String?
    var specialized: Bool
    var website: String?
    var subway: String?
    var bus: String?
    var totalStudents: String
    var startTime: String?
    var endTime: String?
    var additionalInfo: String?
    var extracurricularActivities: String?
    var sportsBoys: String?
    var sportsGirls: String?
    var sportsCoed: String?
    var graduationRate: String
    var girls: String?
    var boys: String?
    var councilDistrict: String
    
    var programName: String?
    var programDescription: String?
    var programInterest: String?
    var programSeats: String?
    var programApplicants: String?
    var programApplicationMethod: String?
    
    var avgSATScores: SATData?
    
    var address: String {
        let locationComponents = location.components(separatedBy: "(")
        return locationComponents.first ?? location
    }
    
    init? (_ json: JSON) {
        // I originally wanted to use Codable to unwrap these, but I realized that there were too many keys and several ways I wanted to present information to the user that Codable is not designed to enable.
        
        if let id = json[CodingKeys.id.rawValue],
            let name = json[CodingKeys.name.rawValue],
            let overview = json[CodingKeys.overview.rawValue],
            let neighborhood = json[CodingKeys.neighborhood.rawValue],
            let location = json[CodingKeys.location.rawValue],
            let totalStudents = json[CodingKeys.totalStudents.rawValue],
            let graduation = json[CodingKeys.graduationRate.rawValue],
            let district = json[CodingKeys.councilDistrict.rawValue] {
            
            //non-optionals
            self.id = id
            self.name = name
            self.overview = overview
            self.neighborhood = neighborhood
            self.borough = Borough.getFrom(json: json)
            self.location = location
            self.totalStudents = totalStudents
            self.graduationRate = graduation
            self.girls = json[CodingKeys.girls.rawValue]
            self.boys = json[CodingKeys.boys.rawValue]
            self.councilDistrict = district
            self.specialized = json[CodingKeys.specialized.rawValue] != nil
            
            //optionals
            self.ellPrograms = json[CodingKeys.ellPrograms.rawValue]
            self.languageClasses = json[CodingKeys.languageClasses.rawValue]
            self.apCourses = json[CodingKeys.apCourses.rawValue]
            self.diplomaEndorsements = json[CodingKeys.diplomaEndorsements.rawValue]
            self.phoneNumber = json[CodingKeys.phoneNumber.rawValue]
            self.email = json[CodingKeys.email.rawValue]
            self.website = json[CodingKeys.website.rawValue]
            self.subway = json[CodingKeys.subway.rawValue]
            self.bus = json[CodingKeys.bus.rawValue]
            self.startTime = json[CodingKeys.startTime.rawValue]
            self.endTime = json[CodingKeys.endTime.rawValue]
            self.additionalInfo = json[CodingKeys.additionalInfo.rawValue]
            self.extracurricularActivities = json[CodingKeys.extracurricularActivities.rawValue]
            self.sportsBoys = json[CodingKeys.sportsBoys.rawValue]
            self.sportsGirls = json[CodingKeys.sportsGirls.rawValue]
            self.sportsCoed = json[CodingKeys.sportsCoed.rawValue]
        } else {
            return nil
        }
    }
    
    enum CodingKeys: String, CodingKey {
        case id = "dbn",
        name = "school_name",
        borough = "boro",
        overview = "overview_paragraph",
        academicOpportunities,
        ellPrograms = "ell_programs",
        languageClasses = "language_classes",
        apCourses = "advancedplacement_coursed",
        diplomaEndorsements = "diplomaendorsements",
        neighborhood,
        address,
        location,
        phoneNumber = "phone_number",
        email = "school_email",
        website,
        subway,
        bus,
        totalStudents = "total_students",
        startTime = "start_time",
        endTime = "end_time",
        additionalInfo = "addtl_info1",
        extracurricularActivities = "extracurricular_activities",
        sportsBoys = "psal_sports_boys",
        sportsGirls = "psal_sports_girls",
        sportsCoed = "psal_sports_coed",
        graduationRate = "graduation_rate",
        girls,
        boys,
        specialized,
        councilDistrict = "council_district",
        programName,
        programDescription,
        programInterest,
        programSeats,
        programApplicants,
        programApplicationMethod
    }
}
