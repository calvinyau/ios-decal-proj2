//
//  GameViewController.swift
//  Hangman
//
//  Created by Shawn D'Souza on 3/3/16.
//  Copyright © 2016 Shawn D'Souza. All rights reserved.
//

import UIKit

class GameViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var guessWordLabel: UILabel!
    @IBOutlet weak var incorrectGuess: UIButton!
    @IBOutlet weak var correctGuess: UIButton!
    @IBOutlet weak var incorrectGuessesLabel: UILabel!
    @IBOutlet weak var enterGuessBox: UITextField!
    @IBOutlet weak var makeAGuess: UIButton!
    @IBOutlet weak var newGameButton: UIButton!
    
    var incorrectGuesses : [Character] = []
    var numIncorrectGuesses = 0
    var hangmanPrefix = "hangman"
    var gifSuffix = ".gif"
    var phrase = ""
    var correctGuesses : [Character] = []
    
    @IBOutlet weak var hangmanImage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let hangmanPhrases = HangmanPhrases()
        phrase = hangmanPhrases.getRandomPhrase()
        print(phrase)
        enterGuessBox.delegate = self
        initializeGuessWord(phrase)
        numIncorrectGuesses = 0
        correctGuesses = []
        incorrectGuesses = []
        incorrectGuessesLabel.text = "Incorrect Guesses: "
        loadInterface()
    }
    
    func loadInterface() {
        incorrectGuess.addTarget(self, action: "incorrectGuessFunc", forControlEvents: .TouchUpInside)
        correctGuess.addTarget(self, action: "correctGuessFunc", forControlEvents: .TouchUpInside)
        makeAGuess.addTarget(self, action: "guessFunc", forControlEvents: .TouchUpInside)
        newGameButton.addTarget(self, action: "newGame", forControlEvents: .TouchUpInside)
    }
    
    func guessFunc() {
        // entered text
        if let currentGuess = enterGuessBox.text {
            // too many letters
            if currentGuess.capitalizedString.characters.count > 1 {
                let alertController = UIAlertController(title: "Too many letters!", message: "Please enter only one letter to guess!", preferredStyle: UIAlertControllerStyle.Alert)
                alertController.addAction(UIAlertAction(title: "Okay", style: UIAlertActionStyle.Default, handler: nil))
                self.presentViewController(alertController, animated: true, completion: nil)
                return
            }
            
            // not a letter
            if currentGuess.rangeOfCharacterFromSet(NSCharacterSet.letterCharacterSet()) == nil {
                let alertController = UIAlertController(title: "Not a letter!", message: "Please enter a letter to guess!", preferredStyle: UIAlertControllerStyle.Alert)
                alertController.addAction(UIAlertAction(title: "Okay", style: UIAlertActionStyle.Default, handler: nil))
                self.presentViewController(alertController, animated: true, completion: nil)
                return
            }
            
            // correct guess
            if phrase.rangeOfString(currentGuess.capitalizedString) != nil {
                correctGuessFunc(currentGuess.capitalizedString.characters.first!)
            }
            // incorrect guess
            else {
                incorrectGuessFunc(currentGuess.capitalizedString.characters.first!)
            }
            enterGuessBox.text = ""
        }
        // empty guess box
        else {
            let alertController = UIAlertController(title: "No Guess Given!", message: "Please enter a letter to guess!", preferredStyle: UIAlertControllerStyle.Alert)
            alertController.addAction(UIAlertAction(title: "Okay", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alertController, animated: true, completion: nil)
        }
        
        
    }
    
    func correctGuessFunc(guess:Character) {
        if correctGuesses.contains(guess) {
            let alertController = UIAlertController(title: "Already tried this guess!", message: "Please enter a different letter to guess!", preferredStyle: UIAlertControllerStyle.Alert)
            alertController.addAction(UIAlertAction(title: "Okay", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alertController, animated: true, completion: nil)
        }
        else {
            correctGuesses.append(guess)
            var newGuessWordLabelText = ""
            for i in phrase.characters {
                if correctGuesses.contains(i) {
                    newGuessWordLabelText.append(i)
                }
                else if i == " " {
                    newGuessWordLabelText.append(Character(" "))
                }
                else {
                    newGuessWordLabelText.append(Character("-"))
                }
            }
            guessWordLabel.text = newGuessWordLabelText
            
            var stillNeedsGuesses = false
            for i in (guessWordLabel.text?.characters)! {
                if i == "-" {
                    stillNeedsGuesses = true
                }
            }
            
            if stillNeedsGuesses == false {
                // game win
                let alertController = UIAlertController(title: "You Win!", message: "You deserve a gold star.", preferredStyle: UIAlertControllerStyle.Alert)
                alertController.addAction(UIAlertAction(title: "New Game", style: UIAlertActionStyle.Default, handler: { _ in self.newGame()}))
                self.presentViewController(alertController, animated: true, completion: nil)
            }
        }
    }
    
    func incorrectGuessFunc(guess:Character) {
        if !incorrectGuesses.contains(guess) {
            numIncorrectGuesses++
            if (numIncorrectGuesses >= 6) {
                let alertController = UIAlertController(title: "You Lost!", message: "Better luck next time.", preferredStyle: UIAlertControllerStyle.Alert)
                alertController.addAction(UIAlertAction(title: "New Game", style: UIAlertActionStyle.Default, handler: { _ in self.newGame()}))
                self.presentViewController(alertController, animated: true, completion: nil)

            }
            incorrectGuesses.append(guess)
            incorrectGuessesLabel.text!.append(guess);
            incorrectGuessesLabel.text!.append(Character(" "))
            
            let imageName = hangmanPrefix + String(numIncorrectGuesses + 1) + gifSuffix
            hangmanImage.image = UIImage(named: imageName)
        }
        else {
            let alertController = UIAlertController(title: "Already tried this guess!", message: "Please enter a different letter to guess.", preferredStyle: UIAlertControllerStyle.Alert)
            alertController.addAction(UIAlertAction(title: "Okay", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alertController, animated: true, completion: nil)
        }
        
    }
    
    func newGame() {
        self.viewDidLoad()
    }
    
    func initializeGuessWord(phrase : String) {
        var word:String = ""
        for i in phrase.characters {
            if i != " " {
                word = word + "-"
            }
            else {
                word = word + " "
            }
        }
        guessWordLabel.text = word
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
