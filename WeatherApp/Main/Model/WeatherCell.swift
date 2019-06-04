//
//  WeatherCell.swift
//  WeatherApp
//
//  Created by Felix Changoo on 6/3/19.
//  Copyright © 2019 Felix Changoo. All rights reserved.
//

import UIKit
import Kingfisher

class WeatherCell: UITableViewCell {
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var tempLbl: UILabel!
    @IBOutlet weak var imgView: UIImageView!
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        nameLbl.text = ""
        tempLbl.text = ""
        imgView.image = .none
    }
    
    func configure(with weatherResult: WeatherResult) {
        nameLbl.text = weatherResult.name
        tempLbl.text = weatherResult.getTemp()
        
        if let imgUrl = weatherResult.getWeatherIconURL() {
            imgView.kf.setImage(with: imgUrl)
        }
    }
}
