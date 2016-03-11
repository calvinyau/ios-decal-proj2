//
//  GameViewController.swift
//  Hangman
//
//  Created by Shawn D'Souza on 3/3/16.
//  Copyright © 2016 Shawn D'Souza. All rights reserved.
//

import UIKit

class GameViewController: UIViewController {

    @IBOutlet weak var guessWordLabel: UILabel!
    @IBOutlet weak var incorrectGuess: UIButton!
    @IBOutlet weak var correctGuess: UIButton!
    @IBOutlet weak var incorrectGuessesLabel: UILabel!
    @IBOutlet weak var enterGuessBox: UITextField!
    var incorrectGuesses = [Character : Bool]();
    var numIncorrectGuesses = 0;
    var hangmanPrefix = "hangman";
    var gifSuffix = ".gif"
    
    @IBOutlet weak var hangmanImage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let hangmanPhrases = HangmanPhrases()
        var phrase = hangmanPhrases.getRandomPhrase()
        print(phrase)
        initializeGuessWord(phrase)
        loadInterface()
    }
    
    func loadInterface() {
        incorrectGuess.addTarget(self, action: "incorrectGuessFunc", forControlEvents: .TouchUpInside)
        correctGuess.addTarget(self, action: "correctGuessFunc", forControlEvents: .TouchUpInside)
    }
    
    func incorrectGuessFunc() {
        if let currentGuess = enterGuessBox.text!.capitalizedString.characters.first {
//            let guesses = Array(incorrectGuesses.keys).sort()
            if incorrectGuesses[currentGuess] == nil {
                numIncorrectGuesses++
                if (numIncorrectGuesses >= 6) {
                    //ALERT PLAYER HAS LOST
                }
                incorrectGuesses[currentGuess] = true
                incorrectGuessesLabel.text!.append(currentGuess);
            }
            
        } else {
            let alertController = UIAlertController(title: "No Guess Given!", message: "Please enter a letter to guess!", preferredStyle: UIAlertControllerStyle.Alert)
            alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default,handler: nil))
            self.presentViewController(alertController, animated: true, completion: nil)
        }
        
        let imageName = hangmanPrefix + String(numIncorrectGuesses + 1) + gifSuffix
        hangmanImage.image = UIImage(named: imageName)
//        if currentGuess.characterIsMember(phrase) {
//            
//        }
//        else {
//            
//        }
    }
    
    func correctGuessFunc() {
        if guessWordLabel.text?.isEmpty == false {
            let lastChar = guessWordLabel.text!.characters.last
            if lastChar == "-" {
                guessWordLabel.text!.removeAtIndex(guessWordLabel.text!.endIndex.predecessor())
            }
            else {
                for _ in 0...1 {
                    guessWordLabel.text!.removeAtIndex(guessWordLabel.text!.endIndex.predecessor())
                }
            }
        }
        else {
            //alert win
        }
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
