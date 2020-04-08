//
//  gameCenterViewController.swift
//  CIS357_Hangman
//
//  Created by Johnathon Frocillo on 4/7/20.
//  Copyright © 2020 Johnathon Frocillo. All rights reserved.
//

import UIKit
import GameKit

class gameCenterViewController: UIViewController, GKGameCenterControllerDelegate {
    
    @IBOutlet weak var newGameButton: UIButton!
    @IBOutlet weak var leaderboardButton: UIButton!
    @IBOutlet weak var achievementsButton: UIButton!
    
    func gameCenterViewControllerDidFinish(_ gameCenterViewController: GKGameCenterViewController) {
        // Stuff when game center is finished
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        newGameButton.layer.borderWidth = 1.0
        newGameButton.layer.cornerRadius = 20.0
        leaderboardButton.layer.borderWidth = 1.0
        leaderboardButton.layer.cornerRadius = 20.0
        achievementsButton.layer.borderWidth = 1.0
        achievementsButton.layer.cornerRadius = 20.0
        
        // authenticateUser()
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

}
