//
//  ItemView.swift
//  Diagrammer
//
//  Created by Kirill Khudyakov on 01.02.18.
//  Copyright © 2018 adeveloper. All rights reserved.
//

import UIKit

class ItemView: UIView {
    
    var label: UILabel!
    var title: String = "mew"
    
    convenience init(_ title: String) {
        self.init(frame: CGRect(x: 0, y: 0, width: 200, height: 100))
        self.title = title
        
        label = UILabel(frame: bounds)
        label.text = title
        label.textAlignment = .center
        addSubview(label)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

}



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

extension ItemView: INearestable {
    
    func getNearestPoint(_ view: UIView) -> CGPoint {
        
        let top = CGPoint(x: frame.left + (frame.width / 2), y: frame.top)
        let left = CGPoint(x: frame.left, y: frame.origin.y + (frame.height / 2))
        let right = CGPoint(x: frame.right, y: frame.origin.y + (frame.height / 2))
        let bottom = CGPoint(x: frame.left + (frame.width / 2), y: frame.bottom)
        let points = [ top, left, bottom, right ]
        let first = view.center
        
        var minDistanceIndex = 99999
        var nearest = Dictionary<Int, CGPoint>()  // Dictionary<double, CGPoint>()
        
        for point in points {
            let distance = Int(getDistance(first, point))
            nearest[distance] = point;
            if (distance < minDistanceIndex)
            {
                minDistanceIndex = Int(distance);
            }
        }
        
        return nearest[minDistanceIndex] ?? .zero;
    }
    
    private func getDistance(_ first: CGPoint, _ second: CGPoint) -> CGFloat
    {
        return sqrt(pow(second.x - first.x, 2) + pow(second.y - first.y, 2))
    }
    
}