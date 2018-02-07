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
    
    // move element
    var moveItem: ItemView!
    
    var links: [LinkView] = []
    var items: [ItemView] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavigationBar()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else {
            return
        }
        
        switch mode {
        case .normal:
            
            break
        case .edit:
            if let editView = touch.view as? ItemView {
                let alertController = UIAlertController(title: "edit title", message: "title", preferredStyle: .alert)
                alertController.addTextField(configurationHandler: { text in
                    
                })
                
                alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak self] action in
                    if let textField = alertController.textFields?[0] {
                        editView.label.text = textField.text
                    }
                    self?.mode = .normal
                }))
                
                alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { [weak self] action in
                    self?.mode = .normal
                }))
                
                present(alertController, animated: true)
            }
            break
        case .addElement:
            lastTapPoint = touch.location(in: view)
            let itemView = ItemView("Итем")
            itemView.backgroundColor = #colorLiteral(red: 0.721568644, green: 0.8862745166, blue: 0.5921568871, alpha: 1)
            itemView.center = lastTapPoint
            itemView.controller = self
            view.addSubview(itemView)
            items.append(itemView)
            mode = .normal
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
                    mode = .normal
                }
            }
            break
        case .moveElement:
            if let moveView = touch.view as? ItemView {
                moveItem = moveView
            }
            break
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else {
            return
        }

        if (mode == .moveElement) {
            moveItem.center = touch.location(in: view)
            updateLinks()
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        if mode == .moveElement {
            updateLinks()
            mode = .normal
        }
    }
    
    private func updateLinks() {
        links.forEach {
            $0.update()
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
            UIBarButtonItem(title: "Clear", style: .plain, target: self, action: #selector(clear)),
            UIBarButtonItem(title: "Move", style: .plain, target: self, action: #selector(setModeMove)),
            UIBarButtonItem(title: "Edit", style: .plain, target: self, action: #selector(setModeEdit)),
            UIBarButtonItem(title: "Modal", style: .plain, target: self, action: #selector(setModeModal)),
            ],
            animated: true)
    }
    
    @objc func setModeModal() {
        
        items.forEach { item in
            item.canTap = true
        }
        
    }
    
    @objc func setModeEdit() {
        mode = .edit
    }
    
    @objc func setModeMove() {
        mode = .moveElement
    }
    
    @objc func setModeAddLink() {
        mode = .addLink
    }
    
    @objc func addNewItem() {
        mode = .addElement
    }
    
    @objc func clear() {
        mode = .normal
        view.subviews.forEach {
            $0.removeFromSuperview()
        }
    }
    
    func addLink(from first: ItemView, to second: ItemView ) {
        let linkView = LinkView(first, second, .black)
        view.insertSubview(linkView, at: 0)
        links.append(linkView)
    }
    
}

extension DiagramViewController: IPresent {}
