//
//  SesionesCell.swift
//  Culiacan
//
//  Created by Armando Trujillo on 21/01/15.
//  Copyright (c) 2015 RedRabbit. All rights reserved.
//

import UIKit

class SesionesCell: UICollectionViewCell {
    
    @IBOutlet weak var lblSesion: UILabel!
    @IBOutlet weak var lblMes: UILabel!
    
    override var highlighted: Bool {
        willSet {
            if highlighted {
                self.lblSesion.textColor = UIColor.blackColor()
                self.lblMes.textColor = UIColor.blackColor()
            } else {
                var selectedView: UIView = self.selectedBackgroundView as UIView
                if newValue {
                    self.lblSesion.textColor = UIColor.whiteColor()
                    self.lblMes.textColor = UIColor.whiteColor()
                }
            }
            
        }
    }
    
    
}
    