//
//  MainMenuViewController.swift
//  CIS357_Hangman
//
//  Created by Johnathon Frocillo and Kyle Jacobson on 3/31/20.
//  Copyright © 2020 Johnathon Frocillo. All rights reserved.
//

import UIKit

class MainMenuViewController: UIViewController {

    @IBAction func unwindToMenu(segue: UIStoryboardSegue) {}
    @IBOutlet weak var passAndPlayButton: UIButton!
    @IBOutlet weak var gameCenterButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.backBarButtonItem = UIBarButtonItem(
            title: "Quit", style: .plain, target: nil, action: #selector(self.quitTapped))
        
        passAndPlayButton.layer.borderWidth = 1.0
        passAndPlayButton.layer.cornerRadius = 20.0
        gameCenterButton.layer.borderWidth = 1.0
        gameCenterButton.layer.cornerRadius = 20.0
    }
    
    @IBAction func howToPlay(_ sender: UIBarButtonItem) {
        let message = "Pass and Play:\nOne human player creates a word, then passes the phone. The second human player will start guessing letters!\n\nGame Center Challenge:\n Compete against other players for the highest score! Words are randomly created, and you start guessing! Every consecutive correct guess will boost your score! Good luck!"
        
        let alert = UIAlertController(title: "How To Play", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .default ))
        self.present(alert, animated: true, completion: nil)
    }
    
    @objc func quitTapped() {
        // Stuff when Quit tapped
    }

}
