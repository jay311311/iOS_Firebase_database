//
//  ViewController.swift
//  Firebase_101
//
//  Created by Jooeun Kim on 2022/03/02.
//

import UIKit
import Firebase

class ViewController: UIViewController {

    var db =  Database.database().reference()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        db.child("firstData").observeSingleEvent(of: .value, with: { snapshot in print("-->\(snapshot)")})
        // Do any additional setup after loading the view.
    }


}

