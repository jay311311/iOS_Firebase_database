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
        setDBData()
        saveCustomer()
        // Do any additional setup after loading the view.
    }
    
    func updateDBLabel() {
        db.child("firstData").observeSingleEvent(of: .value) { snapshot in print("-->\(snapshot)")
            let value =  snapshot.value as? String ??  "찾을수 없음"
            DispatchQueue.main.async {
                self.dbLabel.text = value
            }
        }
    }
}


extension ViewController{
    func setDBData(){
        let user = db.child("user")
        user.child("userName").setValue(["firstName" : "Jooeun","lastName" : "kim" ])
        user.child("age").setValue(26)
    }
    
    func saveCustomer(){
        
        let books = [Book(title: "harry potter", author: "J.K.Rolling"),
                     Book(title: "Art Of Parents", author: "Dennis")]
        let customer1 =  Customer(id: Customer.id, name: "Som", books: books)
        Customer.id += 1
        let customer2 =  Customer(id: Customer.id, name: "Kim", books: books)
        Customer.id += 1
        let customer3 =  Customer(id: Customer.id, name: "Mike", books: books)
        Customer.id += 1

        db.child("customer").child("\(customer1.id)").setValue(customer1.toDictionary)
        db.child("customer").child("\(customer2.id)").setValue(customer2.toDictionary)
        db.child("customer").child("\(customer3.id)").setValue(customer3.toDictionary)

    
        
    }
}

struct Customer{
    let id : Int
    let name : String
    let books : [Book]
    
    var toDictionary :[String:Any]{
        let bookArray  =  books.map{ book in book.toDictionary}
        let dict:[String:Any] = ["id" : id, "name" : name, "books": bookArray]
        return dict
    }
    static var id = 0
    
}

struct Book{
    let title: String
    let author : String
    
    var toDictionary:[String : Any] {
        let dict:[String : Any]  = ["title":title, "author" : author]
        return dict
    }
    
    
}
