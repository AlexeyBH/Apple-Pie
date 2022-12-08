//
//  ViewController.swift
//  Apple Pie
//
//  Created by Alexey Khestanov on 23.09.2022.
//

import UIKit
import WebKit


class ViewController: UIViewController {
 

    
    @IBOutlet var treeView: AppleTree!
    // Apples on the tree

    
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
        enableDisableAllButtons(true)
        gameState = Game.shared.startNewRound()
        characterGuessState = .right
        setDisabledButtons()
        UpdateUI()
    }
    
    // Screen keyboard pressed
    @IBAction func characterPressed(_ sender: UIButton) {
        guard let character = sender.configuration?.title?.first else { return }
        
        
        NetworkManager.shared.fetchData()
        
            let state = Game.shared.guessCharacter(character)
            if state == .roundFailed || state == .roundFinished{
                enableDisableAllButtons(false)
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
    func enableDisableAllButtons(_ state: Bool) {
        buttons.forEach {
            $0.isEnabled = state
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
            enableDisableAllButtons(false)
        case .roundStarted(_):
            currentWord.attributedText = makeFormattedText()
        default:
            currentWord.text = "Something happened..."
        }
        scoreText.text = "Score: \(Game.shared.currentScore)"
        winsText.text = "Wins: \(Game.shared.totalWins)"
        losesText.text = "Loses: \(Game.shared.totalLoses)"
        
        dropApplesFromTree()
    }
    
    // Hiding all apples that are outside 0..characterLeft range
    // Should be replaced with something more interesting
    private func dropApplesFromTree() {
        treeView.apples.enumerated().forEach {
            $0.element.isHidden = $0.offset + 1 > Game.shared.charactersLeft
        }
    }
        
    // Disables buttons on keyboard that were already shown
    private func setDisabledButtons() {
        // Array of shown characters
        let alreadyShown = Game.shared.data.filter{$0.state == .shown}.map{$0.symbol}
        // Disabling all buttons that title contain any of shown characters
        buttons.filter {
            guard let title = $0.configuration?.title else { return false }
            return alreadyShown.contains(Character(title))
        }.forEach{ $0.isEnabled = false }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        gameState = Game.shared.startNewRound()
        
        setDisabledButtons()

        
        UpdateUI()

    }


}

