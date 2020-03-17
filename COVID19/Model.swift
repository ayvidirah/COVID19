//
//  Model.swift
//  COVID19
//
//  Created by Hariharan Murugesan on 17/03/20.
//  Copyright © 2020 Hariharan Murugesan. All rights reserved.
//

import Foundation

#error("API Key Missing. Delete this line to compile.")
let apiKey = ""

struct CoronaStats: Codable {
    var error: Bool?
    var statusCode: Int?
    var message: String?
    var data: coronaModel
    
}

struct coronaModel: Codable {
    var lastChecked: String?
    var covid19Stats: [coronaData]
   
}


struct coronaData: Codable {

    var province, country, lastUpdate: String?
    var confirmed, deaths, recovered: Int?
}
