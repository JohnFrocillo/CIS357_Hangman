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
    @IBOutlet weak var guessedLetter: UITextField!
    
    var stickManNumber = 0
    var chosenWord = ""
    

    override func viewDidLoad() {
        super.viewDidLoad()
        self.guessedLetter.delegate = self
        // Do any additional setup after loading the view.
        let detectTouch = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard))
        self.view.addGestureRecognizer(detectTouch)
        
        print(chosenWord)
        print(chosenWord.count)
        guessedWord.text = ""
        
        for _ in 1...chosenWord.count {
            guessedWord.text = guessedWord.text! + "_  "
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        dismissKeyboard()
        
        // Check if letter already guessed
        // Add it to the list of guessed letters
        // Update the underscores
        
        incorrectGuess()
        
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
            
            return
        }
        else {
            // Update the image
            stickman.image = UIImage(named: "stickman-\(stickManNumber+1)")
            stickManNumber += 1
        }
    }
    
}

