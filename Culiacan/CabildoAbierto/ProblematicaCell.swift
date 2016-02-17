//
//  ProblematicaCell.swift
//  Culiacan
//
//  Created by Armando Trujillo on 09/12/14.
//  Copyright (c) 2014 RedRabbit. All rights reserved.
//

import UIKit

class ProblematicaCell: UITableViewCell {

    @IBOutlet weak var lblFolio: UILabel!
    @IBOutlet weak var lblResponsable: UILabel!
    @IBOutlet weak var lblProblema: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
