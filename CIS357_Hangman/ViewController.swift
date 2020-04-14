//
//  ViewController.swift
//  CIS357_Hangman
//
//  Created by Johnathon Frocillo on 3/30/20.
//  Copyright © 2020 Johnathon Frocillo. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var stickman: UIImageView!
    @IBOutlet weak var wrongGuess: UIButton!
    @IBOutlet weak var guessedWord: UILabel!
    @IBOutlet weak var guessedLetterTextField: UITextField!
    @IBOutlet weak var scoreLabel: UILabel!
    
    var stickManNumber = 0
    var chosenWord = ""
    var guessedLetter:[Character] = []
    var gameCenterGame: Bool = false
    var consecutiveCorrect = 0
    var score = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        self.guessedLetterTextField.delegate = self
        // Do any additional setup after loading the view.
        let detectTouch = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard))
        self.view.addGestureRecognizer(detectTouch)
        
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
            // Enable GameCenter
        }
        else {
            scoreLabel.isHidden = true
        }
        

    }
    
    func updateScore() {
        if consecutiveCorrect == 1 {
            score += 50
        }
        else {
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
            consecutiveCorrect = 0
        }
        else {
            // Correct Guess
            consecutiveCorrect += 1
            updateScore()
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
                let alert = UIAlertController(title: "Winner!", message: "The Guessing Player has Won!", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .default, handler: {_ in
                    self.performSegue(withIdentifier: "unwindToMenu", sender: self)
                }))
                self.present(alert, animated: true, completion: nil)
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

    
    @IBAction func clicked_WrongGuess(_ sender: Any) {
        incorrectGuess()
    }
    
    func incorrectGuess() {
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
    
}

