//
//  ViewController.swift
//  Diagrammer
//
//  Created by Kirill Khudyakov on 01.02.18.
//  Copyright © 2018 adeveloper. All rights reserved.
//

import UIKit


class DiagramViewController: UIViewController {

    var mode: DiagramMode = .normal
    
    // adding element
    var lastTapPoint: CGPoint = .zero
    
    // adding link
    var isFromPointExist: Bool = false
    var fromItem: ItemView!
    var toItem: ItemView!
    var fromPoint: CGPoint = .zero
    var toPoint: CGPoint = .zero
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavigationBar()
        
        let redView = ItemView("Мяу")
            redView.backgroundColor = #colorLiteral(red: 1, green: 0.8951038415, blue: 0.7990858605, alpha: 1)
            redView.center = view.center
            view.addSubview(redView)
        
        let n = 6
        for i in 1...n {
            let blueView = ItemView("Тяф")
            blueView.backgroundColor = #colorLiteral(red: 0.4745098054, green: 0.8392156959, blue: 0.9764705896, alpha: 1)
            view.addSubview(blueView)
            let newPoint = positionOnOrbital(number: i, count: n, radius: 250)
            blueView.center = CGPoint(x: newPoint.x + redView.center.x, y: newPoint.y + redView.center.y)
            addLink(from: blueView, to: redView)
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        guard let touch = touches.first else {
            return
        }
        
        switch mode {
        case .normal:
            
            break
        case .addElement:
            lastTapPoint = touch.location(in: view)
            break
        case .addLink:
            if !isFromPointExist {
                fromPoint = touch.location(in: view)
                if let fromView = touch.view as? ItemView {
                    self.fromItem = fromView
                    isFromPointExist = true
                }
            } else {
                toPoint = touch.location(in: view)
                if let toView = touch.view as? ItemView {
                    self.toItem = toView
                    addLink(from: fromItem, to: toItem)
                    isFromPointExist = false
                }
            }
            break
        }
        
    }
    
    private func positionOnOrbital(number: Int, count: Int, radius: CGFloat = 150) -> CGPoint {
        let angle = 2 * Double.pi / Double(count) * Double(number)
        return CGPoint(x: radius * cos(CGFloat(angle)), y: radius * sin(CGFloat(angle)))
    }
    
    private func configureNavigationBar() {
        navigationItem.setRightBarButtonItems([
            UIBarButtonItem(title: "Add", style: .plain, target: self, action: #selector(addNewItem)),
            UIBarButtonItem(title: "Add Link", style: .plain, target: self, action: #selector(setModeAddLink)),
            ],
            animated: true)
    }
    
    @objc func setModeAddLink() {
        mode = .addLink
    }
    
    @objc func addNewItem() {
        mode = .addElement
        let itemView = ItemView("Итем")
        itemView.backgroundColor = #colorLiteral(red: 0.721568644, green: 0.8862745166, blue: 0.5921568871, alpha: 1)
        itemView.center = lastTapPoint
        view.addSubview(itemView)
        mode = .normal
    }
    
    func addLink(from first: ItemView, to second: ItemView ) {
        let linkView = LinkView(first.center, second.getNearestPoint(first), .black)
        view.insertSubview(linkView, at: 0)
    }
    
}
