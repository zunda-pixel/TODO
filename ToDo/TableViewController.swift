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
                let todo = ToDo(name: name, addDate: Date(), isDone: false)
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
    
    @IBAction func cellDetailTap(_ sender: NSCoder) {
        if let detailViewController = storyboard?.instantiateViewController(identifier: "todoDetail") as? ToDoDetailViewController {
            detailViewController.name = "hello" // 値渡し
            present(detailViewController, animated: true, completion: nil) // 画面遷移
        }
    }
    
    func saveToDoData(_ data: [ToDo]) {
        //シリアライズ(オブジェクトの内容をバイナリに変換)
        //カスタムクラス(MyData)はそのままUserDefaultsで保存できないためシリアライズしてData型に変換する
        do {
            let archiveData: Data = try NSKeyedArchiver.archivedData(withRootObject: data, requiringSecureCoding: true)
            UserDefaults.standard.setValue(archiveData, forKey: "todoData")
        } catch let error {
            print(error)
        }
    }
    
    func loadToDoData() -> [ToDo]? {
        // デシリアライズ(バイナリをオブジェクトに変換)
        guard let storedData: Data = UserDefaults.standard.object(forKey: "todoData") as? Data else { return nil
        }
        
        // デシリアライズ(バイナリをオブジェクトに変換)
        do {
            return try NSKeyedUnarchiver.unarchivedArrayOfObjects(ofClasses: [NSDate.self, ToDo.self], from: storedData) as? [ToDo]
        } catch let error{
            print(error)
            return nil
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let loadData = loadToDoData() {
            self.todoList.append(contentsOf: loadData)
            self.tableView.reloadData()
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.todoList.count
    }
    
    //セル自体を設定
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "todoCell") as? ToDoTableViewCell else {
            return ToDoTableViewCell()
        }
        
        cell.nameLabel.text = self.todoList[indexPath.row].name
        cell.nameLabel.sizeToFit()
        
        guard let isDone = self.todoList[indexPath.row].isDone else {
            return ToDoTableViewCell()
        }
        
        if isDone {
            cell.accessoryType = UITableViewCell.AccessoryType.checkmark
            if let text = cell.nameLabel.text {
                cell.nameLabel.text = "\u{2713} " + text
                cell.nameLabel.sizeToFit()
            }
        }
        
        return cell
    }
    
    //セルを選択された際のアクション
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let cell = tableView.cellForRow(at:indexPath) as? ToDoTableViewCell
        // チェックマークを入れる
        guard let isDone = self.todoList[indexPath.row].isDone else { return }
        cell?.accessoryType = isDone ? UITableViewCell.AccessoryType.none : UITableViewCell.AccessoryType.checkmark
        guard let text = cell?.nameLabel.text else { return }
        if isDone {
            let zero = text.startIndex
            let start = text.index(zero, offsetBy: 2)
            let end = text.index(zero, offsetBy: text.count-1)
            
            cell?.nameLabel.text = String(text[start...end])
        } else {
            cell?.nameLabel.text = "\u{2713} " + text
            cell?.nameLabel.sizeToFit()
        }
        self.todoList[indexPath.row].isDone = isDone ? false : true
        
        self.saveToDoData(self.todoList)
    }
    
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        // セルの削除
        let deleteAction = UIContextualAction(style: UIContextualAction.Style.destructive, title: "Delete") { (action, view, completionHandler) in
            self.todoList.remove(at: indexPath.row)
            self.saveToDoData(self.todoList)
            self.tableView.deleteRows(at: [indexPath], with: UITableView.RowAnimation.automatic)
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
