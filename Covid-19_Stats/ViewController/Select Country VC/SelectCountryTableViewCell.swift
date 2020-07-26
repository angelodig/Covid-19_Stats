//
//  CountryCellTableViewCell.swift
//  Covid-19_Stats
//
//  Created by Angelo Di Gianfilippo on 01/07/2020.
//  Copyright © 2020 Angelo Di Gianfilippo. All rights reserved.
//

import UIKit

class SelectCountryTableViewCell: UITableViewCell {

    @IBOutlet weak var countryNameLbl: UILabel!
    
    var country: String? {
        didSet {
            self.countryNameLbl.text = country
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

}
