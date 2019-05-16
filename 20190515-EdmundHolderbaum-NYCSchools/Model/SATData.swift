//
//  SATData.swift
//  20190515-EdmundHolderbaum-NYCSchools
//
//  Created by Edmund Holderbaum on 5/16/19.
//  Copyright © 2019 Dawn Trigger Enterprises. All rights reserved.
//

import Foundation

struct SATData: Codable {
    
    let schoolID: String
    let schoolName: String
    let testTakers: String
    let avgReading: String
    let avgMath: String
    let avgWriting: String
    
    //on the other hand, the SAT data was much more straightforward and lent itself well to Codable
    
    enum CodingKeys: String, CodingKey {
        case schoolID = "dbn"
        case schoolName = "school_name"
        case testTakers = "num_of_sat_test_takers"
        case avgReading = "sat_critical_reading_avg_score"
        case avgMath = "sat_math_avg_score"
        case avgWriting = "sat_writing_avg_score"
    }
}
