//
//  ModalViewController.swift
//  Diagrammer
//
//  Created by Kirill Khudyakov on 07.02.18.
//  Copyright © 2018 adeveloper. All rights reserved.
//

import UIKit

class ModalViewController: UIViewController {

    var buttonClose: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        buttonClose = UIButton(frame: CGRect(x: view.frame.width / 2, y: view.frame.height / 2, width: 50, height: 50))
        buttonClose.setTitle("X", for: .normal)
        buttonClose.backgroundColor = .red
        view.addSubview(buttonClose)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapOnPayload))
        buttonClose.addGestureRecognizer(tap)
    }
    
    override func viewDidLayoutSubviews() {
        buttonClose.center = CGPoint(x: view.frame.width / 2, y: view.frame.height / 2)
    }
    
    @objc func tapOnPayload() {
        print("tap on payload")
    }

}

extension ModalViewController: IPresent { }
