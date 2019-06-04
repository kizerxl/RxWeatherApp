//
//  MainService.swift
//  WeatherApp
//
//  Created by Felix Changoo on 6/3/19.
//  Copyright © 2019 Felix Changoo. All rights reserved.
//

import Foundation
import RxSwift

final class MainService: Networking {
    //multiple requests
    func getWeatherResult(for resources: [Resource]) -> Observable<[WeatherSection]> {
        let networkObservables = resources.compactMap { resource -> Observable<WeatherResult?> in
            let observable = buildGetInfoNetworkCall(for: resource)
            return observable
        }
        
        return Observable.zip(networkObservables) { list in
            let weatherSection = WeatherSection(header: "", items: list.compactMap { $0 })
            return [weatherSection]
        }
    }
    
    //a single request
    func getWeatherResult(for resource: Resource, with completion: @escaping (Result<WeatherResult?, APIServiceError>) -> ()) {
        guard let request = buildRequest(from: resource) else {
            completion(.failure(.invalidEndpoint))
            return
        }
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode, 200..<299 ~= statusCode else {
                DispatchQueue.main.async {
                    completion(.failure(.apiError))
                }
                return
            }
            
            guard let data = data else {
                DispatchQueue.main.async {
                    completion(.failure(.noData))
                }
                return
            }
            
            do {
                let result = try JSONDecoder().decode(WeatherResult.self, from: data)
                
                DispatchQueue.main.async {
                    completion(.success(result))
                }
            } catch {
                DispatchQueue.main.async {
                    completion(.failure(.decodeError))
                }
            }
        }.resume()
    }
    
    private func buildRequest(from resource: Resource)-> URLRequest? {
        let url = resource.url
        
        guard var component = URLComponents(url: url, resolvingAgainstBaseURL: true) else {
            return nil
        }
        
        component.queryItems = resource.parameters.map({
            return URLQueryItem(name: $0, value: $1)
        })
        
        guard let resolvedUrl = component.url else {
            return nil
        }
        
        var request = URLRequest(url: resolvedUrl)
        request.httpMethod = resource.httpMethod
        
        return request
    }
    
    private func buildGetInfoNetworkCall(for resource: Resource) -> Observable<WeatherResult?> {
        return Observable.create { [weak self] observer in
            guard let strongSelf = self else { observer.onNext(nil) ; observer.onCompleted() ; return Disposables.create() }
            
            strongSelf.getWeatherResult(for: resource, with: { result in
                
                switch result {
                    case .success(let info):
                        
                        observer.onNext(info)
                        observer.onCompleted()
                    case .failure(let error):
                        
                        observer.onError(error)
                }
            })

            return Disposables.create {
                //perform additional clean up here
            }
        }
    }
}
