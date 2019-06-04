//
//  Resource.swift
//  WeatherApp
//
//  Created by Felix Changoo on 6/3/19.
//  Copyright © 2019 Felix Changoo. All rights reserved.
//

import Foundation

struct Resource {
    let url: URL
    let httpMethod: String
    let parameters: [String: String]
    
    init(url: URL, httpMethod: String = "GET", parameters: [String: String] = [:]) {
        self.url = url
        self.httpMethod = httpMethod
        self.parameters = parameters
    }
}
