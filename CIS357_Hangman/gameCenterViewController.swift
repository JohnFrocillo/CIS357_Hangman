//
//  gameCenterViewController.swift
//  CIS357_Hangman
//
//  Created by Johnathon Frocillo on 4/7/20.
//  Copyright © 2020 Johnathon Frocillo. All rights reserved.
//

import UIKit
import GameKit
import Foundation

class gameCenterViewController: UIViewController, GKGameCenterControllerDelegate {
    
    @IBOutlet weak var newGameButton: UIButton!
    @IBOutlet weak var leaderboardButton: UIButton!
    @IBOutlet weak var achievementsButton: UIButton!
    
    var chosenWord: String = ""
    var wordBank: [String] = []
    
    func gameCenterViewControllerDidFinish(_ gameCenterViewController: GKGameCenterViewController) {
        // Stuff when game center is finished
        gameCenterViewController.dismiss(animated: true, completion: nil)
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        newGameButton.layer.borderWidth = 1.0
        newGameButton.layer.cornerRadius = 20.0
        leaderboardButton.layer.borderWidth = 1.0
        leaderboardButton.layer.cornerRadius = 20.0
        achievementsButton.layer.borderWidth = 1.0
        achievementsButton.layer.cornerRadius = 20.0
        
        authenticateUser()
    }
    
    func generateWord() {

        

        // Set chosenWord String to that random word
        
        // Read through the file words.txt
        let path = Bundle.main.path(forResource: "words", ofType: "txt")
        let string = try? String(contentsOfFile: path!, encoding: String.Encoding.utf8)

        // Store each line (word) into an array
        string!.enumerateLines { line, _ in
            self.wordBank.append(line)
        }
        
        // Get a random index in the array < 14 characters.
        let randomInt = Int.random(in: 0...wordBank.count)
        
        var x = false
        repeat {
            if wordBank[randomInt].count < 14 {
                x = true
            }
        } while x == false
        
        self.chosenWord = wordBank[randomInt].uppercased()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "gameCenterSegue" {
            
            generateWord()
            
            let dest = segue.destination as! ViewController
            dest.chosenWord = chosenWord
            dest.gameCenterGame = true
            
        }
    }
    
    func authenticateUser() {
        let player = GKLocalPlayer.local
        
        player.authenticateHandler = { vc, error in
              guard error == nil else {
                print(error?.localizedDescription ?? "")
                return
              }
        
              if let vc = vc {
                self.present(vc, animated: true, completion: nil)
              }
            }
    }
    
    @IBAction func leaderboard(_ sender: UIButton) {
        let vc = GKGameCenterViewController()
           vc.gameCenterDelegate = self
           vc.viewState = .achievements
           present(vc, animated: true, completion: nil)
    }
    
    @IBAction func achievements(_ sender: UIButton) {
        let vc = GKGameCenterViewController()
        vc.gameCenterDelegate = self
        vc.viewState = .leaderboards
        vc.leaderboardIdentifier = "Scores"
        present(vc, animated: true, completion: nil)
    }
    
}
