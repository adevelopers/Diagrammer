//
//  DiagramListViewController.swift
//  Diagrammer
//
//  Created by Kirill Khudyakov on 12.02.18.
//  Copyright © 2018 adeveloper. All rights reserved.
//

import UIKit

class DiagramListViewController: UIViewController {

    typealias Action = ((String) -> Void)
    var diagramNames: [String] = []
    var tableView: UITableView!
    var onSelected: Action?
    
    convenience init(names: [String], onAction: @escaping Action) {
        self.init(nibName: "DiagramListViewController", bundle: nil)
        diagramNames = names
        onSelected = onAction
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView = UITableView(frame: view.frame, style: .plain)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "defaultCell")
        tableView.dataSource = self
        tableView.delegate = self
        view.addSubview(tableView)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()

    }
    
}

extension DiagramListViewController: UITableViewDataSource {
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return diagramNames.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "defaultCell", for: indexPath)
        cell.textLabel?.text = diagramNames[indexPath.row]
        return cell
    }
}

extension DiagramListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let onSelected = onSelected {
            let cell =  tableView.cellForRow(at: indexPath)
            let name = String(describing: cell?.textLabel?.text?.split(separator: ".").first ?? "")
            onSelected(name)
            
        }
        dismiss(animated: true)
    }
}
