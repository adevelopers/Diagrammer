//
//  EquipmentCell.swift
//  Diagrammer
//
//  Created by Kirill Khudyakov on 08.02.18.
//  Copyright © 2018 adeveloper. All rights reserved.
//

import UIKit

class EquipmentCell: UICollectionViewCell {

    static let Id = "defaultCell"
    
    var svgView: SVGEquipment!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    
    func configure(by number: Int) {
        addSvgView("eq\(number%5+1)")
    }
    
    fileprivate func addSvgView(_ name: String) {
        svgView = SVGEquipment(name)
        addSubview(svgView)
    }

}
