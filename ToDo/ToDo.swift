//
//  ToDo.swift
//  ToDo
//
//  Created by 🍡 zunda 🍡 on 2021/03/31.
//

import Foundation

class ToDo: NSObject, NSSecureCoding {
    
    static var supportsSecureCoding: Bool = true

    var name: String?
    var addDate: Date?
    var isDone: Bool?
    
    init (name: String, addDate: Date, isDone: Bool) {
        self.name = name
        self.addDate = addDate
        self.isDone = isDone
    }

    // load
    required init?(coder: NSCoder) {
        super.init()
        if let name = coder.decodeObject(forKey: "name") as? String {
            self.name = name
        } else { print("nameが見つかりません") }
        if let addDate = coder.decodeObject(forKey: "addDate") as? Date {
            self.addDate = addDate
        } else { print("addDateが見つかりません") }
        if let isDone = coder.decodeObject(forKey: "isDone") as? Bool {
            self.isDone = isDone
        } else { print("isDoneが見つかりません") }
    }

    // save
    func encode(with coder: NSCoder) {
        coder.encode(self.name, forKey: "name")
        coder.encode(self.addDate, forKey: "addDate")
        coder.encode(self.isDone, forKey: "isDone")
    }
}

