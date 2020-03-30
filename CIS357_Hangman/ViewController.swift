//
//  ViewController.swift
//  CIS357_Hangman
//
//  Created by Johnathon Frocillo on 3/30/20.
//  Copyright © 2020 Johnathon Frocillo. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var stickman: UIImageView!
    @IBOutlet weak var wrongGuess: UIButton!
    
    var stickManNumber = 0;
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func clicked_WrongGuess(_ sender: Any) {
        if (stickManNumber >= 6) {
            stickman.image = UIImage(named: "stickman-full")
            
            // Alert message showing the game is over and lost
            let alert = UIAlertController(title: "Game Over!", message: "You Lose!!", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: NSLocalizedString("Darn...", comment: "Default action"), style: .default, handler: {_ in
                self.stickman.image = nil
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

