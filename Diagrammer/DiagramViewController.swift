//
//  ViewController.swift
//  Diagrammer
//
//  Created by Kirill Khudyakov on 01.02.18.
//  Copyright © 2018 adeveloper. All rights reserved.
//

import UIKit


class DiagramViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavigationBar()
        
        let redView = ItemView("Мяу")
            redView.backgroundColor = #colorLiteral(red: 1, green: 0.8951038415, blue: 0.7990858605, alpha: 1)
            redView.center = view.center
            view.addSubview(redView)
        
        let n = 6
        for i in 1...n {
            let blueView = ItemView("Мяу")
            blueView.backgroundColor =  #colorLiteral(red: 0.4745098054, green: 0.8392156959, blue: 0.9764705896, alpha: 1)
            view.addSubview(blueView)
          
            let newPoint = positionOnOrbital(number: i, count: n, radius: 250)
            blueView.center = CGPoint(x: newPoint.x + redView.center.x, y: newPoint.y + redView.center.y)
            
            let linkView = LinkView(blueView.center, redView.getNearestPoint(blueView), .black)
            view.insertSubview(linkView, at: 0)
        }
    }
    
    func configureNavigationBar() {
        navigationItem.setRightBarButton(
            UIBarButtonItem(title: "Add", style: .plain, target: self, action: #selector(addNewItem)),
            animated: true
        )
    }
    func positionOnOrbital(number: Int, count: Int, radius: CGFloat = 150) -> CGPoint {
        let angle = 2 * Double.pi / Double(count) * Double(number)
        return CGPoint(x: radius * cos(CGFloat(angle)), y: radius * sin(CGFloat(angle)))
    }

}

