//
//  GameOverViewController.swift
//  InterViewTask
//
//  Created by TalentMicro on 16/05/20.
//  Copyright © 2020 Falabella. All rights reserved.
//
import CoreData
import UIKit

class GameOverViewController: UIViewController {
    
    @IBOutlet weak var lblTotalScore: UILabel!
    
    var userData:UserData?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.setHidesBackButton(true, animated: true)
        
        lblTotalScore.text = "\(userData?.userScore ?? 0)"
        
        saveData(name: userData?.userName ?? "", age: userData?.userAge ?? "", gender: userData?.gender ?? "", userScore: userData?.userScore ?? 0)
        
        setTitle()
        
    }
    
    private func setTitle(){
        let navLabel = UILabel()
        let navTitle = NSMutableAttributedString(string: "Score", attributes:[
            NSAttributedString.Key.foregroundColor: UIColor.white,
            NSAttributedString.Key.font: UIFont(name: "zorque", size: 17)! ])
        
        navLabel.attributedText = navTitle
        self.navigationItem.titleView = navLabel
    }
    
    // MARK: - ButtonRetry
    
    @IBAction func btnRetryAction(_ sender: Any) {
        
        navigationController?.popToRootViewController(animated: true)
        
    }
    
    // MARK: - Save data to Core Data
    
    fileprivate  func saveData(name: String,age: String,gender: String,userScore: Int) {
        
        guard let appDelegate =
            UIApplication.shared.delegate as? AppDelegate else {
                return
        }
        
        // 1
        let managedContext =
            appDelegate.persistentContainer.viewContext
        
        // 2
        let entity =
            NSEntityDescription.entity(forEntityName: "Result",
                                       in: managedContext)!
        
        let userDetail = NSManagedObject(entity: entity,
                                         insertInto: managedContext)
        
        userDetail.setValue(name, forKeyPath: "userName")
        userDetail.setValue(age, forKeyPath: "userAge")
        userDetail.setValue(gender, forKeyPath: "gender")
        userDetail.setValue(userScore, forKeyPath: "userScore")
        
        do {
            try managedContext.save()
            
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
    
    
}
