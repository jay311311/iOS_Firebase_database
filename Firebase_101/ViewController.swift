//
//  ViewController.swift
//  Firebase_101
//
//  Created by Jooeun Kim on 2022/03/02.
//

import UIKit
import Firebase

class ViewController: UIViewController {

    @IBOutlet weak var dbLabel: UILabel!
    var db =  Database.database().reference()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateDBLabel()
        // Do any additional setup after loading the view.
    }
    
    func updateDBLabel() {
        db.child("firstData").observeSingleEvent(of: .value) { snapshot in print("-->\(snapshot)")
            let value =  snapshot.value as? String ??  "찾을수 없음"
            DispatchQueue.main.async {
                self.dbLabel.text = value            }
            
        }
        
       
     
    }


}

