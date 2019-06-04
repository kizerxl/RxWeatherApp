//
//  Endpoints.swift
//  WeatherApp
//
//  Created by Felix Changoo on 6/3/19.
//  Copyright © 2019 Felix Changoo. All rights reserved.
//

import Foundation

public enum APIServiceError: Error {
    case apiError
    case invalidEndpoint
    case invalidResponse
    case noData
    case decodeError
}

struct API {
    static let endpoint = "https://api.openweathermap.org/data/2.5/weather"
    static let appID = "ed05868c6c7f3c3689df1d4864c3887e"
}
