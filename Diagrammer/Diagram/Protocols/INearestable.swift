//
//  INearestable.swift
//  Diagrammer
//
//  Created by Kirill Khudyakov on 01.02.18.
//  Copyright © 2018 adeveloper. All rights reserved.
//

import UIKit

protocol INearestable  {
    func getNearestPoint(_ view: UIView) -> CGPoint
}
