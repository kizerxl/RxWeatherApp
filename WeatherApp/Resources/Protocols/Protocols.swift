//
//  Protocols.swift
//  WeatherApp
//
//  Created by Felix Changoo on 6/3/19.
//  Copyright © 2019 Felix Changoo. All rights reserved.
//

import Foundation
import RxSwift

protocol Networking {
    func getWeatherResult(for resource: Resource, with completion: @escaping (Result<WeatherResult?, APIServiceError>) -> ())
    func getWeatherResult(for resources: [Resource]) -> Observable<[WeatherSection]>
}
