//
//  WordSelectorViewController.swift
//  CIS357_Hangman
//
//  Created by Johnathon Frocillo on 3/31/20.
//  Copyright © 2020 Johnathon Frocillo. All rights reserved.
//

import UIKit

class WordSelectorViewController: UIViewController, UITextFieldDelegate {

    // ADD ABILITY TO PRESS ENTER AS WELL AS CONTINUE BUTTON
    @IBOutlet weak var chosenWordTextField: UITextField!
    @IBOutlet weak var continueButton: UIButton!
    var chosenWord = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.chosenWordTextField.delegate = self
        let detectTouch = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard))
        self.view.addGestureRecognizer(detectTouch)
        
        continueButton.layer.borderWidth = 1.0
        continueButton.layer.cornerRadius = 20.0
    }
    
    @objc func dismissKeyboard() {
        self.view.endEditing(true)
    }
    
    @IBAction func continuePressed(_ sender: UIButton) {
        // Make sure word is <= 11 letters
        // No whitespace allowed
        // No numbers, no symbols
        
        chosenWord = chosenWordTextField.text!.uppercased()
        chosenWordTextField.text = ""
        
        if verify(word: chosenWord) {
            self.performSegue(withIdentifier: "passAndPlaySegue", sender: sender)
        }
        else {
            let alert = UIAlertController(title: "Invalid Word!", message: "You may only enter letters and less than 15 characters", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .default ))
            self.present(alert, animated: true, completion: nil)
        }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "passAndPlaySegue" {
            let dest = segue.destination as! ViewController
            dest.chosenWord = chosenWord
            
        }
        
    }
    
    func verify (word: String) -> Bool {
        if word.count > 14 {
            return false
        }
        
        return !word.isEmpty && word.range(of: "[^a-zA-Z]", options: .regularExpression) == nil
       
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        dismissKeyboard()
        continuePressed(continueButton)
        return true
    }

}
