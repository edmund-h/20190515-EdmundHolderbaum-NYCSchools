//
//  SchoolsQueryClient.swift
//  20190515-EdmundHolderbaum-NYCSchools
//
//  Created by Edmund Holderbaum on 5/16/19.
//  Copyright © 2019 Dawn Trigger Enterprises. All rights reserved.
//

import Foundation
import Alamofire

final class SchoolsQueryClient {
    
    typealias SQCCompletion = ([School])->()
    typealias SchoolKey = School.CodingKeys
    
    static var parameters: [String:String] = [
        "$$app_token" : "Mr13x3vLqtYekLHIuQX314dWH"
    ]
    
    static let url = URL(string: "https://data.cityofnewyork.us/resource/97mf-9njv.json")!
    
    static func getAllSchools(completion: @escaping SQCCompletion) {
        Alamofire.request(url, method: .get, parameters:[:]).responseJSON { response in
            handleSchoolsResponse(for: response, with: completion)
        }
    }
    
    static func querySchoolsBy(name: String, completion: @escaping SQCCompletion) {
        let locale = Locale(identifier: "en_US")
        let nameCapitalized = name.capitalized(with: locale)
        let nameURLEncoded = "%\(nameCapitalized)%"
        var params = parameters
        let nameKey = SchoolKey.name.rawValue
        params["$where"] = "\(nameKey) like '\(nameURLEncoded)'"
        Alamofire.request(url, method: .get, parameters: params).responseJSON { response in
            handleSchoolsResponse(for: response, with: completion)
        }
        
    }
    
    static func querySchoolsBy(idNumber: String, completion: @escaping SQCCompletion) {
        let idURLEncoded = "%\(idNumber)%"
        var params = parameters
        let idKey = SchoolKey.id.rawValue
        params["$where"] = "\(idKey) like '\(idURLEncoded)'"
        Alamofire.request(url, method: .get, parameters: params).responseJSON { response in
            handleSchoolsResponse(for: response, with: completion)
        }
        
    }
    
    static func querySchoolsBy(district: String, completion: @escaping SQCCompletion) {
        var params = parameters
        let districtKey = SchoolKey.councilDistrict.rawValue
        params["$where"] = "\(districtKey) = \(district)"
        Alamofire.request(url, method: .get, parameters: params).responseJSON { response in
            handleSchoolsResponse(for: response, with: completion)
        }
        
    }
    
    static func getSchoolBy(id: String, completion: @escaping SQCCompletion) {
        var params = parameters
        params["dbn"] = id
        Alamofire.request(url, method: .get, parameters: params).responseJSON { response in
            handleSchoolsResponse(for: response, with: completion)
        }
    }
    
    static func getSchoolsBy(score: String, completion: @escaping SQCCompletion) {
        SATsQueryClient.queryBy(score: score, completion: { satData in
            let queryGroup = DispatchGroup()
            var schools: [School] = []
            satData.forEach({ schoolSATData in
                queryGroup.enter()
                getSchoolBy(id: schoolSATData.schoolID, completion: { results in
                    var newSchools: [School] = []
                    results.forEach({
                        var school = $0
                        school.avgSATScores = schoolSATData
                        newSchools.append(school)
                    })
                    schools.append(contentsOf: newSchools)
                    queryGroup.leave()
                })
            })
            queryGroup.notify(queue: .main, execute: {
                completion(schools)
            })
        })
    }
    
    private static func handleSchoolsResponse(for response: DataResponse<Any>, with completion: @escaping SQCCompletion) {
        guard let jsonArray = response.value as? [JSON] else {
            completion([])
            return
        }
        let schools = SchoolBuilder.make(from: jsonArray)
        completion(schools)
    }
}
