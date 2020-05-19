//
//  Model.swift
//  InterViewTask
//
//  Created by TalentMicro on 16/05/20.
//  Copyright © 2020 Falabella. All rights reserved.
//

import Foundation
import Foundation

// MARK: - WelcomeElement
struct WelcomeElement: Codable {
    let question: String
    let options: [String]
    let answer: String
    
    let answerAlphabets = ["A","B","C","D"]
    
    enum CodingKeys:String,CodingKey {
        case question
        case options
        case answer
    }
    var isCorrect = 0
    var timeTaken:Int?
}
 
typealias Welcome = [WelcomeElement]


struct UserData:Codable{
    var userName:String?
    var userAge:String?
    var userScore:Int
    var gender:String?
}
 
 
typealias userDataList = [UserData]

 
