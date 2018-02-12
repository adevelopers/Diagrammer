//
//  Diagram.swift
//  Diagrammer
//
//  Created by Kirill Khudyakov on 12.02.18.
//  Copyright © 2018 adeveloper. All rights reserved.
//

import Foundation
import UIKit

struct Diagram: Codable {
   
    struct Item: Codable {
        let title: String
        let rect: CGRect
    }
    
    struct Link: Codable {
        let first: Int
        let second: Int
    }
    
    let title: String
    let items: [Item]
    let links: [Link]
    
    static func getFilePath(by name: String) -> String? {
        let documentsDirectoryPathString = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
        let documentsDirectoryPath = NSURL(string: documentsDirectoryPathString)!
        
        guard
            let urlToFile = documentsDirectoryPath.appendingPathComponent(name + ".json")
            //  let data = str.data(using: String.Encoding.utf8 )
            else {
                return nil
        }
        
        return urlToFile.path
    }
    
    func save(diagram name: String) {
        
        let encoder  = JSONEncoder()
        let fm = FileManager()
        let path = Diagram.getFilePath(by: name)
        
        do {
            print("path -> ", path ?? "")
            let jsonData = try encoder.encode(self)
            let file = fm.createFile(atPath: path ?? "", contents: jsonData, attributes: [:])
            print("data -> ", jsonData)
            print(file)
        } catch {
            print(error.localizedDescription)
        }

    }
    
    static func load(from name: String) -> Diagram? {
        
        
        let path = Diagram.getFilePath(by: name)
        let url = URL(fileURLWithPath: path ?? "")
        do {
            let data = try Data(contentsOf: url)
            let decoder = JSONDecoder()
            let diagram = try decoder.decode(Diagram.self, from: data)
            return diagram
            
        } catch {
            print("error:\(error)")
            return nil
        }
    }
}

