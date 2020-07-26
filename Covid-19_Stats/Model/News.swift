//
//  News.swift
//  Covid-19_Stats
//
//  Created by Angelo Di Gianfilippo on 25/07/2020.
//  Copyright © 2020 Angelo Di Gianfilippo. All rights reserved.
//

import Foundation

struct News: Decodable {
    var articles: [ArticleInfo]
}

struct ArticleInfo: Decodable {
    var clean_url: String
    var link: String //TODO: oppure url??
    var title: String
    var summary: String
}
