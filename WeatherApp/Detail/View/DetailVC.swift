//
//  DetailVC.swift
//  WeatherApp
//
//  Created by Felix Changoo on 6/4/19.
//  Copyright © 2019 Felix Changoo. All rights reserved.
//

import UIKit

final class DetailVC: UIViewController {
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var windLbl: UILabel!
    @IBOutlet weak var cloudLbl: UILabel!
    
    private var weatherResult: WeatherResult?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configure()
    }
    
    func setWeatherResult(weatherResult: WeatherResult) {
        self.weatherResult = weatherResult
    }
    
    func configure() {
        guard let weatherResult = weatherResult else {
            return
        }
        
        nameLbl.text = weatherResult.name
        windLbl.text = "Wind: \(weatherResult.getWind())"
        cloudLbl.text = "\(weatherResult.getCloud())"
    }
}
