//
//  main.swift
//  SaveToJson
//
//  Created by Kirill Khudyakov on 12.02.18.
//  Copyright © 2018 adeveloper. All rights reserved.
//

import Foundation


print("Save to json")

let levels = ["item1", "item2", "item3"]


let documentsDirectoryPathString = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
let documentsDirectoryPath = NSURL(string: documentsDirectoryPathString)!


let str = "{ \"items\": { \"name\": \"item1\" }}"



struct Diagram: Codable {
    struct Item: Codable {
        let width: Int
        let height: Int
        let title: String
    }
    
    let title: String
    let items: [Item]
}

guard
    let urlToFile = documentsDirectoryPath.appendingPathComponent("output.json"),
    let data = str.data(using: String.Encoding.utf8 )
else {
        exit(0)
}

let item = Diagram.Item(width: 200, height: 100, title: "First")
let items = Diagram(title: "Dia1", items: [item, Diagram.Item(width: 100, height: 50, title: "Second")])

let encoder  = JSONEncoder()
let fm = FileManager()

do {
    print("path -> ", urlToFile.path)
    let jsonData = try encoder.encode(items)
    let file = fm.createFile(atPath: urlToFile.path, contents: jsonData, attributes: [:])
    print("data -> ", jsonData)
    print(file)
} catch {
    print(error.localizedDescription)
}

let url = URL(fileURLWithPath: urlToFile.path)
do {
    let data = try Data(contentsOf: url)
    let decoder = JSONDecoder()
    let diagram = try decoder.decode(Diagram.self, from: data)
    print(diagram)
    
} catch {
    print("error:\(error)")
}







