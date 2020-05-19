//
//  UserDetailViewController.swift
//  InterViewTask
//
//  Created by TalentMicro on 16/05/20.
//  Copyright © 2020 Falabella. All rights reserved.
//

import UIKit

class UserDetailViewController: UIViewController, UITextFieldDelegate  {

    @IBOutlet weak var txtName: UITextField!
    
    @IBOutlet weak var txtAge: UITextField!
    
    @IBOutlet weak var txtGender: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setTitle()
        txtGender.delegate = self
       
    }
    
    private func setTitle(){
        let navLabel = UILabel()
        let navTitle = NSMutableAttributedString(string: "Player Details", attributes:[
            NSAttributedString.Key.foregroundColor: UIColor.white,
            NSAttributedString.Key.font: UIFont(name: "zorque", size: 17)! ])
 
        navLabel.attributedText = navTitle
        self.navigationItem.titleView = navLabel
    }
    
     // MARK: - Start Game
    
    @IBAction func btnNextAction(_ sender: Any) {
        
        if txtName.text?.count ?? 0 > 0 {
        
        let vc:QuizViewController  = (self.storyboard?.instantiateViewController(identifier: "QuizViewController") as? QuizViewController)!
        
        vc.userData = (txtName.text ?? "",txtAge.text ?? "",txtGender.text ?? "",0)
        
        navigationController?.pushViewController(vc, animated: true)
        }
        else{
            let alert = UIAlertController(title: "Alert", message: "Please enter your name", preferredStyle: .actionSheet)
            
            alert.addAction(UIAlertAction(title: "OK", style: .default , handler:{ (UIAlertAction)in
                self.txtName.becomeFirstResponder()
            }))
            
            self.present(alert, animated: true, completion:nil)
        }
    }
    
     // MARK: - UIAlert
    
    func showAlert(){
        let alert = UIAlertController(title: "Gener", message: "Please Select an Option", preferredStyle: .actionSheet)

        alert.addAction(UIAlertAction(title: "Male", style: .default , handler:{ (UIAlertAction)in
            self.txtGender.text = "Male"
        }))

        alert.addAction(UIAlertAction(title: "Female", style: .default , handler:{ (UIAlertAction)in
            self.txtGender.text = "Female"
        }))

        alert.addAction(UIAlertAction(title: "Others", style: .default , handler:{ (UIAlertAction)in
            self.txtGender.text = "Others"
        }))

        self.present(alert, animated: true, completion:nil)
    }
    
     // MARK: - UITextFieldDelegate
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        
        if textField == txtGender {
            showAlert()
              return false
        }
        
        return true
    }
    
   

}
