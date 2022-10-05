//
//  ViewController.swift
//  Apple Pie
//
//  Created by Alexey Khestanov on 23.09.2022.
//

import UIKit

class ViewController: UIViewController {
 
    // Apples on the tree
    @IBOutlet var apples: [UIImageView]!
    
    // Screen keyboard
    @IBOutlet var buttons: [UIButton]!
    
    // Text label containing the word
    @IBOutlet var currentWord: UILabel!
    
    // Scores
    @IBOutlet var scoreText: UILabel!
    @IBOutlet var winsText: UILabel!
    @IBOutlet var losesText: UILabel!
    @IBOutlet var nextRoundBtn: UIButton!
    
    @IBAction func nextRoundPressed(_ sender: UIButton) {
        sender.isHidden = true
        makeButtons(true)
        gameState = Game.shared.startNewRound()
        characterGuessState = .right
        updateDisabledButtons()
        UpdateUI()
    }
    
    // Screen keyboard pressed
    @IBAction func characterPressed(_ sender: UIButton) {
        guard let character = sender.configuration?.title?.first else { return }
            let state = Game.shared.guessCharacter(character)
            if state == .roundFailed || state == .roundFinished{
                makeButtons(false)
                nextRoundBtn.isHidden = false
            } else {
                characterGuessState = state
                sender.isEnabled = false
            }
            UpdateUI()
    }
    
    typealias Attributes = [NSAttributedString.Key: Any]?
    
    let revealedTextAttributes: Attributes = [.foregroundColor: UIColor.black]
    let wrongTextAttributes:    Attributes = [.foregroundColor: UIColor.red]
    
    var gameState: GameState!
    var characterGuessState: CharacterGuessState!
    
    // Enables oe disables screen keyboard
    func makeButtons(_ state: Bool) {
        for button in buttons {
            button.isEnabled = state
        }
    }
    
    // Produces colored string for the letter being guessed.
    func makeFormattedText() -> NSMutableAttributedString {
        let text = NSMutableAttributedString()
        for (symbol, state) in Game.shared.data {
            let isHidden = state == .hidden
            let char = (isHidden ? "_" : String(symbol)) + " "
            let attributes = isHidden && characterGuessState == .wrong ? wrongTextAttributes : revealedTextAttributes
            text.append(NSMutableAttributedString(string: char, attributes: attributes))
        }
        return text
    }
    
    // Updates user interface depending on game state
    func UpdateUI() {
        switch gameState {
        case .gameOver:
            currentWord.text = "Game is over."
            makeButtons(false)
        case .roundStarted(_):
            currentWord.attributedText = makeFormattedText()
        default:
            currentWord.text = "Something happened..."
        }
        scoreText.text = "Score: \(Game.shared.currentScore)"
        winsText.text = "Wins: \(Game.shared.totalWins)"
        losesText.text = "Loses: \(Game.shared.totalLoses)"
    }
        
    func updateDisabledButtons() {
        let alreadyShown = Game.shared.data.filter{$0.state == .shown}.map{$0.symbol}
        buttons.filter {
            guard let title = $0.configuration?.title else { return false }
            return alreadyShown.contains(Character(title))
        }.forEach{ $0.isEnabled = false }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        gameState = Game.shared.startNewRound()
        
        updateDisabledButtons()

        
        UpdateUI()

    }


}

