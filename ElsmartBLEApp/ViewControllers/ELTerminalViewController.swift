//
//  ELTerminalViewController.swift
//  ElsmartBLEApp
//
//  Created by El-00349 on 06/12/2018.
//  Copyright © 2018 Mahak_Mobiloitte. All rights reserved.
//

import UIKit
import SQLite3
class ELTerminalViewController: UIViewController,UICollectionViewDataSource,UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    var TerDetail = [TerDetails]()
    var db: OpaquePointer?
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell",
                                                      for: indexPath) as! TerminalCollectionViewCell
        if indexPath.section % 2 != 0 {
            cell.backgroundColor = UIColor(white: 242/255.0, alpha: 1.0)
        } else {
            cell.backgroundColor = UIColor.white
        }
        let tervalue: TerDetails
        
        
        if indexPath.section == 0 {
            if indexPath.row == 0 {
                cell.CustomLabel.text = "ID"
            }
            if indexPath.row == 1{
                cell.CustomLabel.text = "Name"
            }
            if indexPath.row == 2{
                cell.CustomLabel.text = "Address"
            }
            
        } else {
            if TerDetail.count == 0
            {
                if indexPath.row == 0 {
                    cell.CustomLabel.text = "Pradeep"//String(indexPath.section)
                }
                if indexPath.row == 1 {
                    cell.CustomLabel.text = "Pradeep"//String(indexPath.section)
                }
                if indexPath.row == 2 {
                    cell.CustomLabel.text = "Pradeep"//String(indexPath.section)
                }
                
            }
                
            else
            {
                tervalue = TerDetail[indexPath.row]
                if indexPath.row == 0 {
                    cell.CustomLabel.text = String(tervalue.id)//String(indexPath.section)
                }
                if indexPath.row == 1 {
                    cell.CustomLabel.text = tervalue.Name//String(indexPath.section)
                }
                if indexPath.row == 2 {
                    cell.CustomLabel.text = tervalue.Address//String(indexPath.section)
                }
            }
        }
        
        return cell


    }
    
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 50
    }


    override func viewDidLoad() {
        super.viewDidLoad()

        let fileURL = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
            .appendingPathComponent("Elsmart.sqlite")
        
        if sqlite3_open(fileURL.path, &db) != SQLITE_OK {
            print("error opening database")
        }
        
        //creating table
        if sqlite3_exec(db, "CREATE TABLE IF NOT EXISTS tblTerminals (id INTEGER PRIMARY KEY AUTOINCREMENT,Name TEXT,Address TEXT)", nil, nil, nil) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("error creating table: \(errmsg)")
        }
        // Do any additional setup after loading the view.
       readValues()
    }
    

    @IBAction func Backbtn(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    func readValues(){
        
        //first empty the list of heroes
        TerDetail.removeAll()
        
        //this is our select query
        let queryString = "SELECT * FROM tblTerminals"
        
        //statement pointer
        var stmt:OpaquePointer?
        
        //preparing the query
        if sqlite3_prepare(self.db, queryString, -1, &stmt, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(self.db)!)
            print("error preparing insert: \(errmsg)")
            return
        }
        
        //traversing through all the records
        while(sqlite3_step(stmt) == SQLITE_ROW){
            let id = sqlite3_column_int(stmt, 0)
            let Name = String(cString: sqlite3_column_text(stmt, 1))
            let Address = String(cString: sqlite3_column_text(stmt, 2))
         
            
            
            //adding values to list
            TerDetail.append(TerDetails( id: Int(id),Name: String(describing: Name), Address: String(describing: Address)))
            
            
        }
        
        
        
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