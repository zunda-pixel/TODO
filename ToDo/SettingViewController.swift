//
//  SettingViewController.swift
//  ToDo
//
//  Created by zunda on 2021/04/11.
//

import UIKit

class SettingViewController: UIViewController {

    @IBAction func tapButtonLoginWithGoogle(_ sender: Any) {
        let alertController = UIAlertController(title: "hello", message: "hello message", preferredStyle: UIAlertController.Style.alert)
        let cancelAction  = UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler: nil)
        let defaultAction = UIAlertAction(title: "Default", style: UIAlertAction.Style.default, handler: nil)
        alertController.addAction(cancelAction)
        alertController.addAction(defaultAction)
        present(alertController, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

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
