//
//  QuizViewController.swift
//  InterViewTask
//
//  Created by TalentMicro on 16/05/20.
//  Copyright © 2020 Falabella. All rights reserved.
//

import UIKit
import CoreData

class QuizViewController: AppBaseViewController {
    private var timer  :Timer?
    @IBOutlet weak var tblVw:UITableView!
    
    @IBOutlet weak var lblTicktick:UILabel!
    
    var quizData:Welcome?
    private var selectedQuestionIndex = 0
    private var timeOut = 1
    var userData:(String, String, String,Int) = ("","","",0)
    
    private var selectedIndexForRow = -1
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if UserDefaults.standard.bool(forKey: "isLoaded") {
            setData()
        }
        else{
              getData()
        }
        setTitle()
    }
    
    private func setTitle(){
        let navLabel = UILabel()
        let navTitle = NSMutableAttributedString(string: "Questions", attributes:[
            NSAttributedString.Key.foregroundColor: UIColor.white,
            NSAttributedString.Key.font: UIFont(name: "zorque", size: 17)! ])
        
        navLabel.attributedText = navTitle
        self.navigationItem.titleView = navLabel
    }
    
    // MARK: - Save data to Core Data
    
    fileprivate  func saveData(QuizData:Data) {
        
        guard let appDelegate =
            UIApplication.shared.delegate as? AppDelegate else {
                return
        }
        
        let managedContext =
            appDelegate.persistentContainer.viewContext
        
      
        let entity =
            NSEntityDescription.entity(forEntityName: "QuizData",
                                       in: managedContext)!
        
        let questionList = NSManagedObject(entity: entity,
                                           insertInto: managedContext)
        
        questionList.setValue(QuizData, forKeyPath: "QuizData")
        
        do {
            try managedContext.save()
            UserDefaults.standard.setValue(true, forKey: "isLoaded")
            
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
    
    // MARK: - Get data from Core Data
    
    func setData() {
        guard let appDelegate =
            UIApplication.shared.delegate as? AppDelegate else {
                return
        }
        let managedContext =
            appDelegate.persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "QuizData")
        request.returnsObjectsAsFaults = false
        do {
            let result = try managedContext.fetch(request)
            
            var dataObj:Data?
            
            for data in result as! [NSManagedObject] {
                dataObj = data.value(forKey: "quizData") as? Data
            }
            
            quizData = try! JSONDecoder().decode(Welcome.self, from: dataObj!)
            self.setTimer()
            self.tblVw.reloadData()
            
        } catch {
            
            print("Failed")
        }
    }
    
    // MARK: - ApiCall
    
    fileprivate func getData(){
        ApiPublishers.api(url: "https://storage.googleapis.com/sodimac-8590a.appspot.com/App%20Test%20Assignment/app_test_assignment_quiz.json") { (data, response, error) in
            if error != nil {
                print(error.debugDescription)
                return
            }
            
            let jsonDecoder = JSONDecoder()
            self.quizData = try? jsonDecoder.decode(Welcome.self, from: data!)
            DispatchQueue.main.async {
                self.saveData(QuizData: data!)
                self.setTimer()
                self.tblVw.reloadData()
                
                print(error.debugDescription)
            }
            
            
        }
    }
    
    // MARK: - Timer
    
    private func setTimer(){
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.timerAction), userInfo: nil, repeats: true)
        timer?.fire()
    }
    
    // MARK: - Show next view controller
    
    func gameOver() {
        
        let vc:GameOverViewController  = (self.storyboard?.instantiateViewController(identifier: "GameOverViewController") as? GameOverViewController)!
        vc.userData  = UserData(userName: userData.0, userAge: userData.1, userScore: scoreCalculator(model: quizData!), gender: userData.2)
        navigationController?.pushViewController(vc, animated: true)
    }
    
    // MARK: - Score calulation
    
    private func scoreCalculator(model:Welcome) -> Int{
        var totalScore = 0
        var timeLeft = 0
        for (index,dataObj) in model.enumerated(){
            if dataObj.isCorrect == 1{
                timeLeft = 10 - dataObj.timeTaken!
                totalScore = totalScore + 20 + timeLeft
            }else{
                totalScore = totalScore - 10
            }
            if index == 4 {
                break
            }
        }
        return totalScore
    }
    
    @objc func timerAction(){
        
        animationTiktik()
        if timeOut  == 11{
            timeOut = 10
            next(UIButton())
        }
        lblTicktick.text = "\(timeOut)"
        timeOut = timeOut + 1
    }
    
    
    // MARK: - UIViewAnimation
    
    private func animationTiktik(){
        
        UIView.animate(withDuration: 0.5, animations: {
            self.lblTicktick.transform = CGAffineTransform(scaleX: CGFloat(self.timeOut/2), y: CGFloat(self.timeOut/2))
        }) { (bool) in
            self.lblTicktick.transform = .identity
        }
    }
    
    // MARK: - Next Question
    
    @IBAction func next(_ sender:UIButton){
        timeOut = 1
        if selectedQuestionIndex == 4{
            gameOver()
            timer?.invalidate()
            return
        }
       
        quizData?[selectedQuestionIndex].timeTaken = timeOut
        if selectedQuestionIndex < (quizData?.count ?? 0) - 1 {
            selectedQuestionIndex = selectedQuestionIndex + 1
            selectedIndexForRow = -1
            self.tblVw.reloadData()
        }
        
    }
}
// MARK: - TableView delegate and datasource

extension QuizViewController:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let cell = tableView.dequeueReusableCell(withIdentifier: "QuestionTableViewCell") as? QuestionTableViewCell
        cell?.titleLabel.text = quizData?[selectedQuestionIndex].question
        return cell!
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return  quizData?[0].options.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "OptionTableViewCell", for: indexPath) as? OptionTableViewCell
        if selectedIndexForRow == indexPath.row{
            cell?.backgroundImage.image = UIImage(named: "selectedRect")
        }else{
            cell?.backgroundImage.image = UIImage(named: "rectangle")
        }
        cell?.titleLabel.text = quizData?[selectedQuestionIndex].options[indexPath.row]
        cell?.backgroundImage.shimmer()
        return cell!
        //  return UITableViewCell.init()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedIndexForRow = indexPath.row
        self.tblVw.reloadData()
        
        if quizData?[selectedQuestionIndex].answerAlphabets[indexPath.row] == quizData?[selectedQuestionIndex].answer{
            quizData?[selectedQuestionIndex].isCorrect = 1
        }else{
            quizData?[selectedQuestionIndex].isCorrect = 0
        }
    }
    
    
}

// MARK: - TableViewHeaderCell

class QuestionTableViewCell: UITableViewCell {
    @IBOutlet weak var titleLabel:UILabel!
}

// MARK: - TableViewQuestionCell

class OptionTableViewCell: UITableViewCell {
    @IBOutlet weak var titleLabel:UILabel!
    @IBOutlet weak var selectionButton:UIButton!
    @IBOutlet weak var backgroundImage:UIImageView!
}
