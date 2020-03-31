//
//  WordSelectorViewController.swift
//  CIS357_Hangman
//
//  Created by Johnathon Frocillo on 3/31/20.
//  Copyright © 2020 Johnathon Frocillo. All rights reserved.
//

import UIKit

class WordSelectorViewController: UIViewController {

    @IBOutlet weak var chosenWordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        // Make sure word is <= 10 letters
        // No whitespace allowed
        // No numbers, no symbols
        
        if segue.identifier == "passAndPlaySegue" {
            let dest = segue.destination as! ViewController
            dest.chosenWord = chosenWordTextField.text!
            
        }
        
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
