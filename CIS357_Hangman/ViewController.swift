//
//  ViewController.swift
//  CIS357_Hangman
//
//  Created by Johnathon Frocillo on 3/30/20.
//  Copyright © 2020 Johnathon Frocillo. All rights reserved.
//

import UIKit
import GameKit

class ViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var stickman: UIImageView!
    @IBOutlet weak var guessedWord: UILabel!
    @IBOutlet weak var guessedLetterTextField: UITextField!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var multiplierLabel: UILabel!
    
    var stickManNumber = 0
    var chosenWord = ""
    var guessedLetter:[Character] = []
    var gameCenterGame: Bool = false
    var consecutiveCorrect = 0
    var score = 0
    var mistakeFreeGames = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        self.guessedLetterTextField.delegate = self
        // Do any additional setup after loading the view.
        let detectTouch = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard))
        self.view.addGestureRecognizer(detectTouch)
        
        stickman.image = nil
        
        print(chosenWord)
        print(chosenWord.count)
        guessedWord.text = ""
        var fontSize = guessedWord.font.pointSize
        for _ in 1...chosenWord.count {
            guessedWord.text = guessedWord.text! + "_  "
            guessedWord.font = guessedWord.font.withSize(fontSize)
            fontSize -= 1
        }
    
        if gameCenterGame {
            scoreLabel.isHidden = false
            scoreLabel.text = "Score:\n00"
            
            multiplierLabel.isHidden = true
            // Enable GameCenter
        }
        else {
            scoreLabel.isHidden = true
            multiplierLabel.isHidden = true
        }
        

    }
    
    func updateScore() {
        if consecutiveCorrect == 1 {
            multiplierLabel.isHidden = true
            score += 50
        }
        else {
            multiplierLabel.isHidden = false
            score *= 2
        }
        
        // Check for any Achievements completed
        
        scoreLabel.text = "Score:\n\(score)"
        print("Consecutive correct: \(consecutiveCorrect)")
        print("Score: \(score)")
    }
    
    @IBAction func displayGuessedLetters(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(title: "Guessed Letters:", message: String(guessedLetter.sorted()), preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .default ))
        self.present(alert, animated: true, completion: nil)
        
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        dismissKeyboard()
        
        // Get the guessed letter
        let temp = guessedLetterTextField.text?.uppercased()
        if temp!.count > 1 {
            let alert = UIAlertController(title: "Too Many Letters", message: "Only Guess 1 at a Time!", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .default ))
            self.present(alert, animated: true, completion: nil)
            
            guessedLetterTextField.text = ""
            return false
        }
        
        if (temp!.isEmpty || temp!.range(of: "[^a-zA-Z]", options: .regularExpression) != nil) {
            let alert = UIAlertController(title: "Invalid Guess", message: "Only Guess Letters!", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .default ))
            self.present(alert, animated: true, completion: nil)
            
            guessedLetterTextField.text = ""
            return false
        }
        
        // Check if letter already guessed
        for letter in guessedLetter {
            if letter == Character(temp!) {
                let alert = UIAlertController(title: "Already Guessed", message: "You have already guessed that letter!", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .default ))
                self.present(alert, animated: true, completion: nil)
                
                guessedLetterTextField.text = ""
                return false
            }
        }
        
        // Add it to the list of guessed letters
        guessedLetter.append(Character(temp!))
        print(guessedLetter)
        
        // Update the underscores
        let value = chosenWord.firstIndex(of: Character(temp!))
        if  value == nil {
            incorrectGuess()
            if gameCenterGame {
                consecutiveCorrect = 0
                multiplierLabel.isHidden = true
            }
        }
        else {
            // Correct Guess
            if gameCenterGame {
                consecutiveCorrect += 1
                updateScore()
            }
            var word = guessedWord.text!
            var index: String.Index
            
            for x in 0...chosenWord.count-1 {
                index = chosenWord.index(chosenWord.startIndex, offsetBy: x)

                if Character(temp!) == chosenWord[index] {
                    print("success")
                    
                    if x == 0 {
                        word.remove(at: index)
                        word.insert(Character(temp!), at: index)
                    }
                    else {
                        let removeLetter = word.index(word.startIndex, offsetBy: x*3)
                        word.remove(at: removeLetter)
                        word.insert(Character(temp!), at: removeLetter)
                    }
                    
                    guessedWord.text = word
                    
                }
            }
            
            // When there's no more underscores, that means the player won. Display message
            var gameOver = true
            for x in 0...word.count-1 {
                index = word.index(word.startIndex, offsetBy: x)
                if word[index] == "_" {
                    // There is still an unguessed letter
                    // The game continues
                    gameOver = false
                }
            }
            
            if gameOver {
                // When player wins
                playerWins()
            }
            
            print(word)
            guessedWord.text = word
        }
        
        self.guessedLetterTextField.text = ""
        return true
    }
    
    @objc func dismissKeyboard() {
        self.view.endEditing(true)
    }
    
    func incorrectGuess() {
        self.mistakeFreeGames = 0
        
        if (stickManNumber >= 6) {
            stickman.image = UIImage(named: "stickman-full")
            
            // Alert message showing the game is over and lost
            let alert = UIAlertController(title: "Game Over!", message: "You Lose!!", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: NSLocalizedString("Reset Game", comment: "Default action"), style: .default, handler: {_ in
                self.stickman.image = nil
                self.navigationController?.popViewController(animated: true)
            }))
            alert.addAction(UIAlertAction(title: NSLocalizedString("Back to Main Menu", comment: "Secondary action"), style: .default, handler: {_ in
                self.performSegue(withIdentifier: "unwindToMenu", sender: self)
            }))
            self.present(alert, animated: true, completion: nil)
            
            // Reset the counter
            stickManNumber = 0
            
            // Send your score to GameCenter
            // Update the GameCenter Leaderboards
            // Check for any Achievements completed
            
            return
        }
        else {
            // Update the image
            stickman.image = UIImage(named: "stickman-\(stickManNumber+1)")
            stickManNumber += 1
        }
    }
    
    func playerWins() {
        // Show the alert that the player won
        let alert = UIAlertController(title: "Winner!", message: "The Guessing Player has Won!", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .default, handler: {_ in
            self.performSegue(withIdentifier: "unwindToMenu", sender: self)
        }))
        self.present(alert, animated: true, completion: nil)
        
        self.mistakeFreeGames += 1
        
        // Update score on Game Center
        if !gameCenterGame {
            return
        }
        
        let score = GKScore(leaderboardIdentifier: "357_hangman_leaderboard")
        score.value = Int64(self.score)
        GKScore.report([score]) { error in
          guard error == nil else {
            print(error?.localizedDescription ?? "")
            return
          }
        }
        
        // Check for Achievements
        // Baby Steps
        if self.score > 400 {
            let achievement = GKAchievement(identifier: "babySteps")
            achievement.percentComplete = 100
            achievement.showsCompletionBanner = true
            GKAchievement.report([achievement]) { error in
              guard error == nil else {
                print(error?.localizedDescription ?? "")
                return
              }
            }
        }
        
        // Hill Hiker
        if self.score > 6400 {
            let achievement = GKAchievement(identifier: "hillHiker")
            achievement.percentComplete = 100
            achievement.showsCompletionBanner = true
            GKAchievement.report([achievement]) { error in
              guard error == nil else {
                print(error?.localizedDescription ?? "")
                return
              }
            }
        }
        
        // Mountain Climber
        if self.score > 102400 {
            let achievement = GKAchievement(identifier: "mountainClimber")
            achievement.percentComplete = 100
            achievement.showsCompletionBanner = true
            GKAchievement.report([achievement]) { error in
              guard error == nil else {
                print(error?.localizedDescription ?? "")
                return
              }
            }
        }
        
        // Sky Rider
        if self.score >= 409600 {
            let achievement = GKAchievement(identifier: "skyRider")
            achievement.percentComplete = 100
            achievement.showsCompletionBanner = true
            GKAchievement.report([achievement]) { error in
              guard error == nil else {
                print(error?.localizedDescription ?? "")
                return
              }
            }
        }
        
        // Word Weasel
        if chosenWord.count >= 4 && stickman.image == nil {
            let achievement = GKAchievement(identifier: "wordWeasel")
            achievement.percentComplete = 100
            achievement.showsCompletionBanner = true
            GKAchievement.report([achievement]) { error in
              guard error == nil else {
                print(error?.localizedDescription ?? "")
                return
              }
            }
        }
        
        // Word Whiz
        if chosenWord.count >= 8 && stickman.image == nil {
            let achievement = GKAchievement(identifier: "wordWhiz")
            achievement.percentComplete = 100
            achievement.showsCompletionBanner = true
            GKAchievement.report([achievement]) { error in
              guard error == nil else {
                print(error?.localizedDescription ?? "")
                return
              }
            }
        }
        
        // Word Warrior
        if chosenWord.count >= 14 && stickman.image == nil {
            let achievement = GKAchievement(identifier: "wordWarrior")
            achievement.percentComplete = 100
            achievement.showsCompletionBanner = true
            GKAchievement.report([achievement]) { error in
              guard error == nil else {
                print(error?.localizedDescription ?? "")
                return
              }
            }
        }
        
        // Problem Solver
        if self.mistakeFreeGames >= 3 {
            let achievement = GKAchievement(identifier: "problemSolver")
            achievement.percentComplete = 100
            achievement.showsCompletionBanner = true
            GKAchievement.report([achievement]) { error in
              guard error == nil else {
                print(error?.localizedDescription ?? "")
                return
              }
            }
        }
        
        // Perfectionist
        if self.mistakeFreeGames >= 6 {
            let achievement = GKAchievement(identifier: "perfectionist")
            achievement.percentComplete = 100
            achievement.showsCompletionBanner = true
            GKAchievement.report([achievement]) { error in
              guard error == nil else {
                print(error?.localizedDescription ?? "")
                return
              }
            }
        }
        
        // Works Well Under Pressure
            // Solve an entire word with one chance left
        if ((self.chosenWord.count <= self.consecutiveCorrect) && (stickManNumber == 5)) {
            let achievement = GKAchievement(identifier: "underPressure")
            achievement.percentComplete = 100
            achievement.showsCompletionBanner = true
            GKAchievement.report([achievement]) { error in
              guard error == nil else {
                print(error?.localizedDescription ?? "")
                return
              }
            }
        }

    }
    
}

