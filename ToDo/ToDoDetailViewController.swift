//
//  ToDoDetailViewController.swift
//  ToDo
//
//  Created by 🍡 zunda 🍡 on 2021/04/07.
//

import UIKit

class ToDoDetailViewController: UIViewController {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var addDateLabel: UILabel!
    @IBOutlet weak var isDoneLabel: UILabel!
    
    var name: String?
    var addDate: Date?
    var isDone: Bool?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let name = self.name {
            nameLabel.text = name
        }
        if let addDate = self.addDate {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = DateFormatter.dateFormat(fromTemplate: "yyyy/MM/DD", options: 0, locale: Locale(identifier: "ja_JP"))
            
            addDateLabel.text = dateFormatter.string(from: addDate)
        }
        if let isDone = self.isDone {
            self.isDoneLabel.text = isDone ? "完了済み" : "未完了"
        }
        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
