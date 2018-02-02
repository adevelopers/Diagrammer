//
//  LinkView.swift
//  Diagrammer
//
//  Created by Kirill Khudyakov on 01.02.18.
//  Copyright © 2018 adeveloper. All rights reserved.
//

import UIKit

class ArrowHelper {
    
    func Arrow(_ start: CGPoint, _ end: CGPoint, _ tailWidth: CGFloat, _ headWidth: CGFloat, _ headLength: CGFloat) -> CGPath {
        let length = hypotenuse(end.x - start.x, end.y - start.y)
        let cosinus = (end.x - start.x) / length;
        let sinus = (end.y - start.y) / length;
        let transform = CGAffineTransform(a: cosinus, b: sinus, c: -sinus, d: cosinus, tx: start.x, ty: start.y)
        let tailLength = length - headLength;
        let points = [
            P(0, tailWidth / 2 ),
            P(tailLength, tailWidth / 2),
            P(tailLength, headWidth / 2),
            P(length, 0),
            P(tailLength, -headWidth / 2),
            P(tailLength, -tailWidth / 2),
            P(0, -tailWidth / 2)
        ]
        
        let path = CGMutablePath()
        path.addLines(between: points, transform: transform)
        return path
    }
    
    private func hypotenuse(_ first: CGFloat, _ second: CGFloat) -> CGFloat {
        return sqrt(first * first + second * second)
    }
    
    private func P(_ x: CGFloat, _ y: CGFloat) -> CGPoint {
        return CGPoint(x: x, y: y);
    }
    
}

class LinkView: UIView {

    private var _first: CGPoint = .zero
    private var _second: CGPoint = .zero
    private var _lineColor: UIColor = UIColor.black
    
    var first: ItemView!
    var second: ItemView!
    
    var withShadow: Bool = false
 
    convenience init(_ first: ItemView, _ second: ItemView,_ color: UIColor) {
        self.init(frame: UIScreen.main.bounds)
        self.first = first
        self.second = second
        _first = first.center
        
        _second = second.getNearestPoint(first);
        backgroundColor = UIColor.clear
        _lineColor = color
        ConfigureArrow()
        if withShadow {
            AddShadow()
        }
    }
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func ConfigureArrow() {
        layer.sublayers?.forEach {
            $0.removeFromSuperlayer()
        }
        let path = ArrowHelper().Arrow( _first, _second, 3, 13, 20)
        let arrowLayer = CAShapeLayer()
        arrowLayer.fillColor = _lineColor.cgColor
        arrowLayer.path = path
        layer.addSublayer(arrowLayer)
    }
    
    func AddShadow() {
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 1;
        layer.shadowOffset = CGSize(width: 1, height: 2)
        layer.shadowRadius = 2;
        layer.shouldRasterize = true;
    }
    
    func SetColor(_ color: UIColor) {
        _lineColor = color
    }

    func update() {
        _first = first.center
        _second = second.getNearestPoint(first);
        ConfigureArrow()
        self.setNeedsDisplay()
    }
    
}
