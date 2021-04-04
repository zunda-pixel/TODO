//
//  TableViewController.swift
//  ToDo
//
//  Created by 🍡 zunda 🍡 on 2021/03/31.
//

import UIKit

class ToDoTableViewCell : UITableViewCell {
    
    @IBOutlet weak var nameLabel: UILabel!
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        //super.setSelected(selected, animated: animated)
    }
}

class TableViewController: UITableViewController {
    
    var todoList = [ToDo]()
    
    @IBAction func tapAddToDoButton(_ sender: Any) {
        let alertController = UIAlertController(title: "ToDo追加", message: "なんのToDoを追加しますか？", preferredStyle: UIAlertController.Style.alert)
        let addToDoAction = UIAlertAction(title: "追加", style: UIAlertAction.Style.default, handler: {(action:UIAlertAction!) -> Void in
            if let name = alertController.textFields?.first?.text {
                let todo = ToDo(name: name, addDate: Date())
                self.todoList.append(todo)
                self.saveToDoData(self.todoList)
                self.tableView.reloadData()
            }
        })
        let cancelAction = UIAlertAction(title: "閉じる", style: UIAlertAction.Style.cancel, handler: {(action:UIAlertAction!) -> Void in })
        
        alertController.addAction(addToDoAction)
        alertController.addAction(cancelAction)
        
        alertController.addTextField(configurationHandler: {(text: UITextField!) -> Void in
        })
        
        present(alertController, animated: true, completion: nil)
        self.tableView.reloadData()
    }
    
    func saveToDoData(_ data: [ToDo]) {
        //シリアライズ(オブジェクトの内容をバイナリに変換)
        //カスタムクラス(MyData)はそのままUserDefaultsで保存できないためシリアライズしてData型に変換する
        if let archiveData = try? NSKeyedArchiver.archivedData(withRootObject: data, requiringSecureCoding: false) {
            UserDefaults.standard.setValue(archiveData, forKey: "todoData")
        } else {
            print("シリアライズ失敗")
        }
    }

       
    func loadToDoData() -> [ToDo]? {
        // デシリアライズ(バイナリをオブジェクトに変換)
        guard let storedData: Data = UserDefaults.standard.object(forKey: "todoData") as? Data else { return nil }
        
        do {
            //デシリアライズ(バイナリをオブジェクトに変換)
            return try NSKeyedUnarchiver.unarchivedArrayOfObjects(ofClasses: [ToDo.self, NSDate.self], from: storedData) as? [ToDo]
        } catch let error{
            print(error)
        }
        return nil
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(self.todoList)
        if let loadData = loadToDoData() {
            self.todoList.append(contentsOf: loadData)
            self.tableView.reloadData()
        }
        // Do any additional setup after loading the view.
    }
    
    /*override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }*/
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.todoList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "todoCell") as? ToDoTableViewCell else {
            return ToDoTableViewCell()
        }
        
        cell.nameLabel.text = self.todoList[indexPath.row].name
        cell.nameLabel.sizeToFit()
        
        if self.todoList[indexPath.row].isDone {
            cell.accessoryType = UITableViewCell.AccessoryType.checkmark
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at:indexPath)
        // チェックマークを入れる
        self.todoList[indexPath.row].isDone = true//self.todoList[indexPath.row].isDone ? false : true
        //print(self.todoList[indexPath.row].isDone)
        self.saveToDoData(self.todoList)
        print(self.todoList[0].isDone)
        cell?.accessoryType = .checkmark//self.todoList[indexPath.row].isDone ? UITableViewCell.AccessoryType.none : UITableViewCell.AccessoryType.checkmark
    }
    
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
       // セルの削除
        let deleteAction = UIContextualAction(style: UIContextualAction.Style.destructive, title: "Delete") { (action, view, completionHandler) in
            self.todoList.remove(at: indexPath.row)
            self.saveToDoData(self.todoList)
            self.tableView.deleteRows(at: [indexPath], with: UITableView.RowAnimation.automatic)
            //completionHandler(true)
        }
        // セルの編集
        let editAction = UIContextualAction(style: UIContextualAction.Style.normal, title: "Edit") { (action, view, completionHandler) in
            let alertController = UIAlertController(title: "ToDo編集", message: "名前を変更しますか？\n\(self.todoList[indexPath.row].name!)", preferredStyle: UIAlertController.Style.alert)
            let addToDoAction = UIAlertAction(title: "追加", style: UIAlertAction.Style.default, handler: {(action:UIAlertAction!) -> Void in
                if let name = alertController.textFields?.first?.text {
                    self.todoList[indexPath.row].name = name
                    self.saveToDoData(self.todoList)
                    self.tableView.reloadRows(at: [indexPath], with: UITableView.RowAnimation.automatic)
                }
            })
            let cancelAction = UIAlertAction(title: "閉じる", style: UIAlertAction.Style.cancel, handler: {(action:UIAlertAction!) -> Void in })
            
            alertController.addAction(addToDoAction)
            alertController.addAction(cancelAction)
            
            alertController.addTextField(configurationHandler: {(text: UITextField!) -> Void in
            })
            
            self.present(alertController, animated: true, completion: nil)
        }
        return UISwipeActionsConfiguration(actions: [deleteAction, editAction])
    }
}
