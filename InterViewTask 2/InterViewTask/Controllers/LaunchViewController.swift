//
//  LaunchViewController.swift
//  InterViewTask
//
//  Created by TalentMicro on 16/05/20.
//  Copyright © 2020 Falabella. All rights reserved.
//

import UIKit
import CoreData
class LaunchViewController: AppBaseViewController {
    @IBOutlet weak var tblVw:UITableView!
    var finalData:userDataList?
    override func viewDidLoad() {
        super.viewDidLoad()
        
      
    }
    
    override func viewWillAppear(_ animated: Bool) {
          setData()
    }
    
     // MARK: - Get data from Core Data
    
    func setData() {
        guard let appDelegate =
            UIApplication.shared.delegate as? AppDelegate else {
                return
        }
        let managedContext =
            appDelegate.persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Result")
        request.returnsObjectsAsFaults = false
        do {
            let result = try managedContext.fetch(request)
            
            let json = convertToJSONArray(moArray: result as! [NSManagedObject])
            let dataObj = jsonToData(json: json)
            finalData = try! JSONDecoder().decode(userDataList.self, from: dataObj!)
            
            var tempDataNegative = userDataList()
            var tempDataPositive = userDataList()
            
            _ =  finalData?.map({ (dataObj) -> Bool in
                if dataObj.userScore < 0{
                    tempDataNegative.append(dataObj)
                }
                return true
            })
            
            _ = finalData?.map({ (dataObj) -> Bool in
                if dataObj.userScore > 0{
                    tempDataPositive.append(dataObj)
                }
                return true
            })
            
            tempDataNegative = tempDataNegative.sorted(by: { (lhs, rhs) -> Bool in
                if lhs.userScore < 0{
                    return true
                }
                
                return false
            })
            
            tempDataPositive = tempDataPositive.sorted(by: { (lhs, rhs) -> Bool in
                return lhs.userScore > rhs.userScore
                
            })
            
            tempDataPositive.append(contentsOf: tempDataNegative)
            
            finalData = tempDataPositive
            
            
            
            self.tblVw.reloadData()
            
        } catch {
            
            print("Failed")
        }
    }
    
     // MARK: - Start Game
    
    @IBAction func start(_ sender:UIButton){
        let vc = self.storyboard?.instantiateViewController(identifier: "UserDetailViewController") as? UserDetailViewController
        self.navigationController?.pushViewController(vc!, animated: true)
    }
    
}

 // MARK: - TableView delegate and datasource

extension LaunchViewController:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      
        return finalData?.count ?? 0
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ScroreBoardTableViewCell", for: indexPath) as? ScroreBoardTableViewCell
        cell?.lblName.text = finalData?[indexPath.row].userName
        cell?.lblScore.text = "\(finalData?[indexPath.row].userScore ?? 0)"
        
        return cell!
    }
    
}

// MARK: - TableViewCell

class ScroreBoardTableViewCell: UITableViewCell {
    @IBOutlet weak var lblName:UILabel!
    @IBOutlet weak var lblScore:UILabel!
    
}
