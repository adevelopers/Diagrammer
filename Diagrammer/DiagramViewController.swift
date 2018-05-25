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
    
    // storeage diagram
    var links: [LinkView] = []
    var items: [ItemView] = []
    
    // save & load diagram
    var diagramName: String = "Dia1" {
        didSet {
            title = diagramName
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavigationBar()
        loadDiagram()
        diagramName = "defaultDia"
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else {
            return
        }
        
        switch mode {
        case .normal:
            
            break
        case .delete:
            let delay = 2.0
            if
                let viewForDelete = touch.view as? ItemView,
                let index = items.index(of: viewForDelete)
            {
                
                viewForDelete.backgroundColor = .red
                UIView.animate(withDuration: delay,
                               animations: { viewForDelete.alpha = 0 }, completion: {[weak self] isOK in

                viewForDelete.removeFromSuperview()
                
                let filtredLinks =  self?.links.filter {
                    $0.first == viewForDelete ||
                    $0.second == viewForDelete
                }
                                
                guard let linksForDelete = filtredLinks else {
                    return
                }
                                
                linksForDelete.forEach {
                        if let indexLink = self?.links.index(of: $0) {
                            self?.links.remove(at: indexLink)
                        }
                        $0.removeFromSuperview()
                }
                self?.items.remove(at: index)
                })
                
            }
                
            if
                let linkView = touch.view as? LinkView,
                let indexLink = links.index(of: linkView)
            {
                linkView.SetColor(.red)
                UIView.animate(withDuration: 2.0, animations: {
                    linkView.alpha = 0
                }, completion: { [weak self] isOK in
                    self?.links.remove(at: indexLink)
                    linkView.removeFromSuperview()
                    
                })
                mode = .normal
            }
            
        case .edit:
            
            if let editView = touch.view as? ItemView {
                
                let alertController = UIAlertController(title: "edit title", message: "title", preferredStyle: .alert)
                alertController.addTextField(configurationHandler: { field in
                    field.text = editView.title
                })
                
                alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak self] action in
                    if let textField = alertController.textFields?[0] {
                        editView.title = textField.text ?? ""
                    }
                    self?.mode = .normal
                }))
                
                alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { [weak self] action in
                    self?.mode = .normal
                }))
                
                present(alertController, animated: true)
            }
            
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
            UIBarButtonItem(title: "Delete", style: .plain, target: self, action: #selector(setModeDelete)),
            ],
            animated: true)
        
        navigationItem.setLeftBarButtonItems([
            UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(saveDiagram)),
            UIBarButtonItem(title: "Load", style: .plain, target: self, action: #selector(loadDiagram)),
            UIBarButtonItem(title: "Change name", style: .plain, target: self, action: #selector(changeDiagramName)),
            ], animated: true)
    }
    
    @objc func changeDiagramName() {
        
            let alertController = UIAlertController(title: "edit title", message: "title", preferredStyle: .alert)
            alertController.addTextField(configurationHandler: { [weak self] field in
                field.text = self?.diagramName
            })
            
            alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak self] action in
                if let textField = alertController.textFields?[0] {
                    self?.diagramName = textField.text ?? ""
                }
                self?.mode = .normal
            }))
            
            alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { [weak self] action in
                self?.mode = .normal
            }))
            
            present(alertController, animated: true)
        
    }
    
    @objc func loadDiagram() {
        
        let fileManager = FileManager.default
        var names: [String] = []
        let documentsURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first!
        do {
            let files = try fileManager.contentsOfDirectory(at: documentsURL, includingPropertiesForKeys: nil)
            let jsonFiles = files.filter { $0.pathExtension == "json" }
            print(jsonFiles)
            jsonFiles.forEach {
                let name =  $0.pathComponents.last ?? ""
                names.append(name)
            }
            
        } catch {
            print("Error while enumerating files : \(error.localizedDescription)")
        }
        
        let diagramListViewController = DiagramListViewController(names: names) { [weak self] name in
            self?.diagramName = name
            if let diagram = Diagram.load(from: name) {
                print(diagram.title)
                print(diagram.links.count)
                for item in diagram.items {
                    let itemView = ItemView(item.title, frame: item.rect)
                    itemView.backgroundColor = .orange
                    self?.view.addSubview(itemView)
                    self?.items.append(itemView)
                }
                
                guard let items = self?.items else {
                    return
                }
                
                for link in diagram.links {
                    let first = items[link.first]
                    let second = items[link.second]
                    self?.addLink(from: first, to: second)
                }
                
            }
        }
        
        present(diagramListViewController, animated: true)
        clear()
    }
    
    
    @objc func saveDiagram() {
        
        var linksToSave: [Diagram.Link] = []
        
        links.forEach {
            guard
                let index1 = items.index(of: $0.first),
                let index2 = items.index(of: $0.second)
            else {
                return
            }
            
            let link = Diagram.Link(first: index1, second: index2)
            linksToSave.append(link)
        }
        
        let diagram = Diagram(title: diagramName, items: items.map { $0.asItem() } , links: linksToSave)
        diagram.save(diagram: diagramName)
    }
    
    @objc func setModeDelete() {
        mode = .delete
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
        items.removeAll()
        links.removeAll()
        
    }
    
    func addLink(from first: ItemView, to second: ItemView ) {
        let linkView = LinkView(first, second, .black)
        view.insertSubview(linkView, at: 0)
        links.append(linkView)
    }

}

extension DiagramViewController: IPresent {}
