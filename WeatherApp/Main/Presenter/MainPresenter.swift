//
//  MainPresenter.swift
//  WeatherApp
//
//  Created by Felix Changoo on 6/3/19.
//  Copyright © 2019 Felix Changoo. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import RxDataSources

struct WeatherSection {
    var header: String
    var items: [Item]
}

extension WeatherSection: SectionModelType {
    typealias Item = WeatherResult
    
    init(original: WeatherSection, items: [Item]) {
        self = original
        self.items = items
    }
}

final class MainPresenter {
    private let cities: [String]
    private let service: Networking
    
    init(cities: [String], service: Networking = MainService()) {
        self.cities = cities
        self.service = service
    }
    
    func loadCities() -> Observable<[WeatherSection]>? {
        guard let url = URL(string: API.endpoint) else {
            return .none
        }
        
        let resources = cities.map { createResource(url: url, with: $0) }

        return service.getWeatherResult(for: resources)
    }
    
    private func createResource(url: URL, with city: String) -> Resource {
        let params: [String: String] = [
            "appid": API.appID,
            "q" : city
        ]
        
        return Resource(url: url, parameters: params)
    }
}
