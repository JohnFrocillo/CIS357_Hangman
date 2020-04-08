//
//  MainMenuViewController.swift
//  CIS357_Hangman
//
//  Created by Johnathon Frocillo on 3/31/20.
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
    
    @objc func quitTapped() {
        // Stuff when Quit tapped
    }

}
