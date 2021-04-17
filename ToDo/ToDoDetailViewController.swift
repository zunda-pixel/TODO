//
//  ToDoDetailViewController.swift
//  ToDo
//
//  Created by 🍡 zunda 🍡 on 2021/04/07.
//

import UIKit

class ToDoDetailViewController: UIViewController {
    
    @IBOutlet weak var isDoneSwitch: UISwitch!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var datePicker: UIDatePicker!
    
    var resultHandler: (([ToDo]) -> Void)?
    var indexPath  = IndexPath()
    var todoList =  [ToDo]()
    
    @IBAction func tapAddButton(_ sender: Any) {
        todoList[indexPath.row].isDone = isDoneSwitch.isOn
        todoList[indexPath.row].name = textField.text
        todoList[indexPath.row].addDate = datePicker.date
        
        
        if let handler = self.resultHandler {
            // 入力値を引数として渡された処理の実行
            handler(todoList)
        }
        print(todoList.count)
        // 遷移元へ戻る
        //self.dismiss(animated: true, completion: nil)
        //self.navigationController?.popViewController(animated: true)
        self.dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        // Do any additional setup after loading the view.
        super.viewDidLoad()
        
        isDoneSwitch.isOn = todoList[indexPath.row].isDone!
        textField.text = todoList[indexPath.row].name
        datePicker.date = todoList[indexPath.row].addDate!
    }
    
    func loadData() {
        isDoneSwitch.isOn = todoList[indexPath.row].isDone!
        textField.text = todoList[indexPath.row].name
        datePicker.date = todoList[indexPath.row].addDate!
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
