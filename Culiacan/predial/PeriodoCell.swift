//
//  PeriodoCell.swift
//  Culiacan
//
//  Created by Armando Trujillo on 11/02/15.
//  Copyright (c) 2015 RedRabbit. All rights reserved.
//

import UIKit

class PeriodoCell: UITableViewCell {

    @IBOutlet weak var lblPeriodo: UILabel!
    @IBOutlet weak var lblTotal: UILabel!
    @IBOutlet weak var lblSocial: UILabel!
    @IBOutlet weak var lblMultas: UILabel!
    @IBOutlet weak var lblRecargos: UILabel!
    @IBOutlet weak var lblProntoPago: UILabel!
    @IBOutlet weak var lblDesct: UILabel!
    @IBOutlet weak var lblJubilados: UILabel!
    @IBOutlet weak var lblPrincipal: UILabel!
    @IBOutlet weak var viewPrincipal: UIView!
    @IBOutlet weak var imageCheck: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }

}
