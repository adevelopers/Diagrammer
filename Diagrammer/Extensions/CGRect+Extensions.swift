//
//  CGRect+Extensions.swift
//  Diagrammer
//
//  Created by Kirill Khudyakov on 02.02.18.
//  Copyright © 2018 adeveloper. All rights reserved.
//

import UIKit

extension CGRect {
    
    var left: CGFloat {
        return origin.x
    }
    
    var top: CGFloat {
        return origin.y
    }
    
    var right: CGFloat {
        return origin.x + width
    }
    
    var bottom: CGFloat {
        return origin.y + height
    }
}
