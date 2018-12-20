//
//  ELLogsViewController.swift
//  ElsmartBLEApp
//
//  Created by El-00349 on 06/12/2018.
//  Copyright © 2018 Mahak_Mobiloitte. All rights reserved.
//

import UIKit
import SQLite3

class ELLogsViewController: UIViewController,UICollectionViewDataSource,UICollectionViewDelegate {
   
    @IBOutlet weak var collectionView: UICollectionView!
     var log = [logs]()
     var db: OpaquePointer?
    let contentCellIdentifier = "ContentCellIdentifier"

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
      return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell",
                                                      for: indexPath) as! ContentCollectionViewCell
        
        if indexPath.section % 2 != 0 {
            cell.backgroundColor = UIColor(white: 242/255.0, alpha: 1.0)
        } else {
            cell.backgroundColor = UIColor.white
        }
        let logvalue: logs
        if indexPath.section == 0 {
            if indexPath.row == 0 {
                cell.CustomLabel.text = "Date"
            }
            if indexPath.row == 1{
                cell.CustomLabel.text = "Time"
            }
            if indexPath.row == 2{
                cell.CustomLabel.text = "Ter"
            }
            if indexPath.row == 3{
                cell.CustomLabel.text = "Dir"
            }
            if indexPath.row == 4{
                cell.CustomLabel.text = "Name"
            }
        } else {
           if log.count == 0
           {
            if indexPath.row == 0 {
                cell.CustomLabel.text = ""//String(indexPath.section)
            }
            if indexPath.row == 1 {
                cell.CustomLabel.text = ""//String(indexPath.section)
            }
            if indexPath.row == 2 {
                cell.CustomLabel.text = ""//String(indexPath.section)
            }
            if indexPath.row == 3 {
                cell.CustomLabel.text = ""//String(indexPath.section)
            }
            if indexPath.row == 4 {
                cell.CustomLabel.text = ""//String(indexPath.section)
            }
            else {
                cell.CustomLabel.text = ""
            }
            }
            
            else
           {
           logvalue = log[indexPath.section - 1]
            if indexPath.row == 0 {
                cell.CustomLabel.text = logvalue.date//String(indexPath.section)
            }
            if indexPath.row == 1 {
                cell.CustomLabel.text = logvalue.time//String(indexPath.section)
            }
            if indexPath.row == 2 {
                cell.CustomLabel.text = String(logvalue.ter!)//String(indexPath.section)
            }
            if indexPath.row == 3 {
                cell.CustomLabel.text = logvalue.direction//String(indexPath.section)
            }
            if indexPath.row == 4 {
                cell.CustomLabel.text = logvalue.badgeNo//String(indexPath.section)
            }
           
            }
        }
        return cell

    }
    
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let fileURL = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
            .appendingPathComponent("Elsmart.sqlite")
        
        if sqlite3_open(fileURL.path, &db) != SQLITE_OK {
            print("error opening database")
        }
        
        //creating table
        if sqlite3_exec(db, "CREATE TABLE IF NOT EXISTS tblLogs (id INTEGER PRIMARY KEY AUTOINCREMENT,date TEXT,badgeNo TEXT, ter TEXT,direction TEXT)", nil, nil, nil) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("error creating table: \(errmsg)")
        }
        // Do any additional setup after loading the view.
      readValues()
    }
    
    @IBAction func BackBtn(_ sender: UIButton) {
         self.dismiss(animated: true, completion: nil)
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return log.count + 1
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    func readValues(){
      
        var direction:String?
        var Logtime:String?
        var Logdate:String?
        var badgeNo:String?
        var ter:Int?
        var stmt:OpaquePointer?
        //first empty the list of heroes
        log.removeAll()
        //this is our select query
        let queryString = "SELECT * FROM tblLogs order by id desc"
        //preparing the query
        if sqlite3_prepare(self.db, queryString, -1, &stmt, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(self.db)!)
            print("error preparing insert: \(errmsg)")
            return
        }
        //traversing through all the records
        while(sqlite3_step(stmt) == SQLITE_ROW){
            let id = sqlite3_column_int(stmt, 0)
        if   sqlite3_column_type(stmt, 1) != SQLITE_NULL {
            let date=Date(timeIntervalSinceReferenceDate: sqlite3_column_double(stmt, 1))
            let formatter = DateFormatter()
            formatter.dateFormat="dd-MMM-yyyy"
            Logdate=formatter.string(from: date)
            formatter.dateFormat="hh:mm a"
            formatter.amSymbol="AM"
            formatter.pmSymbol="PM"
            Logtime=formatter.string(from: date)
        }
        else
        {
            Logtime="Invaild Time"
            Logdate="Invalid date"
        }
            
        if  let BadgeNo = sqlite3_column_text(stmt, 2)
         {
             badgeNo = String(cString: BadgeNo)
         }
        else
         {
           badgeNo = ""
         }
        let ter = sqlite3_column_int(stmt, 3)//String(cString: sqlite3_column_text(stmt, 3))
        if  let Direction = sqlite3_column_text(stmt, 4)
        {
            direction = String(cString: Direction)
        }
        else
        {
            direction = ""
        }
        //adding values to list
        log.append(logs( id: Int(id),date: String(describing: Logdate!),time: String(describing: Logtime!), badgeNo: String(describing: badgeNo!),ter: Int(ter),direction: String(describing:direction!)))
            
        }
    }
}
