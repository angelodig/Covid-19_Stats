//
//  History.swift
//  Covid-19_Stats
//
//  Created by Angelo Di Gianfilippo on 08/07/2020.
//  Copyright © 2020 Angelo Di Gianfilippo. All rights reserved.
//

import Foundation

struct History: Decodable {
    var response: [CasesAndDeaths]?
}

struct CasesAndDeaths: Decodable {
    var country: String
    var cases: Cases
    var deaths: Deaths
}

struct Cases: Decodable {
    var new: String?
    var active: Int
    var recovered: Int
    var total: Int
}

struct Deaths: Decodable {
    var new: String?
    var total: Int?
}
