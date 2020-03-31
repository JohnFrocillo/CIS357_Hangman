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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.backBarButtonItem = UIBarButtonItem(
            title: "Quit", style: .plain, target: nil, action: #selector(self.quitTapped))
        // Do any additional setup after loading the view.
    }
    
    @objc func quitTapped() {
        // Stuff when Quit tapped
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
