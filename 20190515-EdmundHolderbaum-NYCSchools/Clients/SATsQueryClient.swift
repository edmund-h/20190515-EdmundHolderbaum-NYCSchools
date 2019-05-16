//
//  SATsQueryClient.swift
//  20190515-EdmundHolderbaum-NYCSchools
//
//  Created by Edmund Holderbaum on 5/16/19.
//  Copyright © 2019 Dawn Trigger Enterprises. All rights reserved.
//

import Foundation
import Alamofire

final class SATsQueryClient {
    
    typealias ScoreKey = SATData.CodingKeys
    typealias SATsCompletion = ([SATData])->()
    
    static var params = SchoolsQueryClient.parameters
    
    
    static let url =  URL(string: "https://data.cityofnewyork.us/resource/734v-jeq5.json")!
    
    static func queryBy(score: String, completion: @escaping SATsCompletion) {
        var parameters = params
        let keys = [ScoreKey.avgReading, ScoreKey.avgWriting, ScoreKey.avgMath]
        let query = keys.map({$0.rawValue}).map({"\($0) >= '\(score)'"}).joined(separator: " OR ")
        parameters["$where"] = query
        Alamofire.request(url, method: .get, parameters: parameters).responseData { response in
            responseHandler(response, completion: completion)
        }
    }
    
    static func getScoreFor(_ schoolID: String, completion: @escaping SATsCompletion) {
        var parameters = params
        parameters["dbn"] = schoolID
        Alamofire.request(url, method: .get, parameters: parameters).responseData { response in
            responseHandler(response, completion: completion)
        }
    }
    
    private static func responseHandler(_ response: DataResponse<Data>, completion: @escaping SATsCompletion) {
        guard let data = response.value else {
            completion ([])
            return
        }
        print(response.debugDescription)
        let satScores = SchoolBuilder.getSATsFrom(data: data)
        completion(satScores)
    }
}

