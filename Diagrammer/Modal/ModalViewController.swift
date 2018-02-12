//
//  ModalViewController.swift
//  Diagrammer
//
//  Created by Kirill Khudyakov on 07.02.18.
//  Copyright © 2018 adeveloper. All rights reserved.
//

import UIKit

class ModalViewController: UIViewController {

    var labelTitle: UILabel!
    var buttonClose: UIButton!
    var collectionView: UICollectionView!
    var previousCell: EquipmentCell?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        labelTitle = UILabel(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 60))
        labelTitle.text = "Select equipment"
        labelTitle.textAlignment = .center
        view.addSubview(labelTitle)
        
        addCollectionView()
    }
    
    override func viewDidLayoutSubviews() {
        labelTitle.center = CGPoint(x: view.frame.width / 2, y: 40)
    }
    
    @objc func tapOnPayload() {
        print("tap on payload")
    }
    
}

extension ModalViewController {
    func addCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.estimatedItemSize = CGSize(width: 100, height: 100)
        layout.scrollDirection = .horizontal
        collectionView = UICollectionView(frame: CGRect(x: 0, y: 80, width: 300, height: 140), collectionViewLayout: layout)
        collectionView.contentInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        collectionView.contentSize = CGSize(width: 120*7, height: 120)
        collectionView.register(EquipmentCell.self, forCellWithReuseIdentifier: EquipmentCell.Id)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.isUserInteractionEnabled = true
        view.addSubview(collectionView)
    }
}

extension ModalViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 56
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: EquipmentCell.Id, for: indexPath) as! EquipmentCell
        cell.backgroundColor = .blue
        cell.configure(by: indexPath.row)
        
        return cell
    }
    
}

extension ModalViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        previousCell?.layer.borderWidth = 0
        
        if let cell = collectionView.cellForItem(at: indexPath) {
            cell.layer.borderColor = #colorLiteral(red: 0.4745098054, green: 0.8392156959, blue: 0.9764705896, alpha: 1).cgColor
            cell.layer.borderWidth = 2
            previousCell = cell as? EquipmentCell
        }
    }
}

extension ModalViewController: IPresent { }
