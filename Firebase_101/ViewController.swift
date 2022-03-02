//
//  ViewController.swift
//  Firebase_101
//
//  Created by Jooeun Kim on 2022/03/02.
//

import UIKit
import Firebase

class ViewController: UIViewController {

    @IBOutlet weak var numberOfCustomer: UILabel!
    @IBOutlet weak var dbLabel: UILabel!
    
    @IBAction func createTItle(_ sender: UIButton) {
        db.child("firstData").setValue("hello_firebase")
        updateDBLabel()
    }
    
    @IBAction func updateTitle(_ sender: UIButton) {
        db.updateChildValues(["firstData":"change_firebase"])
        updateDBLabel()
    }
    
    @IBAction func deleteTitle(_ sender: UIButton) {
        db.child("firstData").removeValue()
        updateDBLabel()
    }
    
    @IBAction func createCustomer(_ sender: UIButton) {
        saveCustomer()
        fetchDate()
    }
    
    @IBAction func readCustomer(_ sender: UIButton) {
       //fetchDate()
    }
    
    @IBAction func updateCustomer(_ sender: UIButton) {
   // 첫번째 customer의 이름 수정
        updateCustomer()
    }
    @IBAction func deleteCustomer(_ sender: UIButton) {
        deleteCustomer()
    }
    
    
    var db =  Database.database().reference()
    var customers :[Customer] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateDBLabel()
        setDBData()
       // saveCustomer()
       // fetchDate()
        // Do any additional setup after loading the view.
    }
    
    func updateDBLabel() {
        db.child("firstData").observeSingleEvent(of: .value) { snapshot in print("-->\(snapshot)")
            let value =  snapshot.value as? String ??  "create_title 눌러주세요"
            DispatchQueue.main.async {
                self.dbLabel.text = value
            }
        }
    }
}

extension ViewController {
    func fetchDate(){
        let data =  db.child("customer").observeSingleEvent(of: .value) { snapshot in
          //  print("----> \(snapshot.value)")
            do{
                //  NSArray나 NSDictionary형식을 data 타입으로 바꿔줌
                let decoder =  JSONDecoder()
                let data =  try JSONSerialization.data(withJSONObject: snapshot.value, options: [])
                let customer:[Customer] =  try decoder.decode([Customer].self, from: data )
                self.customers = customer
                print("\(customer.count)")
                
                //네트워크 컴플리션에서 ui작업할때는 DispatchQueue.main.async {} 을 사용하자 (습관처럼)
                DispatchQueue.main.async {
                    self.numberOfCustomer.text = "\(customer.count) of Customer"
                    
                }
            }catch let error{
                print("error message : \(error.localizedDescription)")
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

extension ViewController{
    func updateCustomer(){
        guard customers.isEmpty  == false else{ return }
        customers[0].name = "Min"
        let dictionary = customers.map { customer in
            customer.toDictionary
        }
        db.updateChildValues(["customer":dictionary])
        
        
    }
    
    func deleteCustomer(){
        db.child("customer").removeValue()
    }
}

struct Customer:Codable {
    let id : Int
    var name : String
    let books : [Book]
    var toDictionary :[String:Any]{
        let bookArray  =  books.map{ book in book.toDictionary}
        let dict:[String:Any] = ["id" : id, "name" : name, "books": bookArray]
        return dict
    }
    static var id = 0
    
}

struct Book :Codable{
    let title: String
    let author : String
    
    var toDictionary:[String : Any] {
        let dict:[String : Any]  = ["title":title, "author" : author]
        return dict
    }
    
    
}
