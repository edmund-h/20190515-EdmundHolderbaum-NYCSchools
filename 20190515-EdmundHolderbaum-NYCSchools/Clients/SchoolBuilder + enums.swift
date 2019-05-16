//
//  SchoolBuilder.swift
//  20190515-EdmundHolderbaum-NYCSchools
//
//  Created by Edmund Holderbaum on 5/16/19.
//  Copyright © 2019 Dawn Trigger Enterprises. All rights reserved.
//

import Foundation

final class SchoolBuilder {
    
    // Factory object for building Schools
    
    static func make(from jsonArray: [JSON])-> [School] {
        var schools: [School] = []
        
        for json in jsonArray {
            guard var schoolInfo = School(json) else {continue }
            schoolInfo.academicOpportunities = getAcademicOpportunities(from: json)
            let schoolPrograms = makePrograms(for: schoolInfo, from: json)
            schools.append(contentsOf: schoolPrograms)
        }
        
        return schools
    }
    
    private static func makePrograms(for school: School, from json: JSON)-> [School] {
        var schools: [School] = []
        let names = getProgram(field: .name, from: json)
        let interests = getProgram(field: .interest, from: json)
        let methods = getProgram(field: .method, from: json)
        let descriptions = getProgram(field: .description, from: json)
        let seats, applicants: [Int:String]
        if school.specialized {
            seats = getProgram(field: .seatsSpecialized, from: json)
            applicants = getProgram(field: .applicantsSpecialized, from: json)
        } else {
            seats = getProgram(field: .seatsGE, from: json)
            applicants = getProgram(field: .applicantsGE, from: json)
        }
        names.forEach ({ (index, name) in
            var newSchool = school
            newSchool.programName = name
            newSchool.programInterest = interests[index]
            newSchool.programDescription = descriptions[index]
            newSchool.programApplicationMethod = methods[index]
            newSchool.programApplicants = applicants[index]
            newSchool.programSeats = seats[index]
            schools.append(newSchool)
        })
        return schools
    }
    
    private static func getAcademicOpportunities(from json: JSON)-> String? {
        var output: String = ""
        var oppKey = "academicopportunities"
        for oppNum in 1...5 {
            oppKey += String(oppNum)
            if let opportunities = json[oppKey] {
                output += opportunities + " \n"
            }
        }
        if output.isEmpty { return nil }
        return output
    }
    
    private static func getProgram(field: ProgramField, from json: JSON)->[Int:String] {
        var data: [Int:String] = [:]
        for programNumber in 1...10 {
            var fieldKey = field.rawValue
            fieldKey += String(programNumber)
            if field.isSpecialized {
                fieldKey += "specialized"
            }
            if let item = json[fieldKey] {
                data[programNumber] = item
            }
        }
        return data
    }
    
    static func getSATsFrom(data: Data)->[SATData] {
        do {
            let decoder = JSONDecoder()
            let sats = try decoder.decode([SATData].self, from: data)
            return sats
        } catch {
            return []
        }
    }
    
    static func sortByBorough(_ items: [School])-> [Borough:[School]] {
        var dict: [Borough: [School]] = [:]
        items.forEach({ item in
            let boro = item.borough
            if var schools = dict[boro] {
                schools.append(item)
                dict[boro] = schools
            } else {
                dict[boro] = [item]
            }
        })
        return dict
    }
}

enum ProgramField: String {
    case name = "program"
    case description = "prgdesc"
    case interest = "interest"
    case seatsGE = "seats9ge"
    case seatsSpecialized = "seats"
    case applicantsGE = "grade9geapplicants"
    case applicantsSpecialized = "applicants"
    case method = "method"
    
    var isSpecialized: Bool {
        return self == .seatsSpecialized || self == .applicantsSpecialized
    }
    
    static var standard = [
        name, description, interest, method
    ]
    
    static var ge = [
        seatsGE, applicantsGE
    ]
    
    static var specialized = [
        seatsSpecialized, applicantsSpecialized
    ]
}

enum Borough: String {
    case Brooklyn, Bronx, Manhattan, Queens, StatenIsland = "Staten Island", Other
    
    static func getFrom(json: JSON)-> Borough {
        if let letter = json["boro"] {
            switch letter{
            case "N": return .StatenIsland
            case "M": return .Manhattan
            case "K": return .Brooklyn
            case "Q": return .Queens
            case "X": return .Bronx
            default: return .Other
            }
        }
        return .Other
    }
}
