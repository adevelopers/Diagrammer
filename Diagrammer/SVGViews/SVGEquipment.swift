//
//  SVGEquipment.swift
//  Diagrammer
//
//  Created by Kirill Khudyakov on 07.02.18.
//  Copyright © 2018 adeveloper. All rights reserved.
//

import UIKit
import Macaw

class SVGEquipment: MacawView {
    
    convenience init(_ name: String) {
        let equipmentSvg  = try! SVGParser.parse(path: name)
        equipmentSvg.place = .scale(sx: 0.2, sy: 0.2)
        self.init(node: equipmentSvg, frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        backgroundColor = UIColor.orange
    }
    
}
