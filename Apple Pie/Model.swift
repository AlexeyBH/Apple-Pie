//
//  Model.swift
//  Apple Pie
//
//  Created by Alexey Khestanov on 27.09.2022.
//

import Foundation

let defaultSymbolsShown = 2...3
let defaultList = ["apple", "shark", "rabbit", "kitty", "dictionary", "turtle"]

// A state of each character in a word being guessed
enum CharacterState {
    case hidden
    case shown
}

// Result of single character guess
enum CharacterGuessState {
    case right
    case wrong
    case roundFinished
    case roundFailed
    case error
}

// A state of the game, in case if round started,
enum GameState {
    case gameOver
    case roundStarted (charactersLeft: Int)
    case internalError
}

// Game model
struct Game {
    // A singleton containing the game itself.
    static var shared = Game(for: defaultList, withSymbolsShown: defaultSymbolsShown)

    // Range refers to number of visible characters when each round starts
    let visibleRange: ClosedRange<Int>
        
    // Available words to guess during all rounds - each word per round
    var wordlist: [String]
    
    // Status of each character for a word being guessed - hidden, guessed right, guessed wrong..
    var data: [(symbol: Character, state: CharacterState)]!

    // Characters to guess
    var charactersLeft = 0
    
    // Current score
    var currentScore = 0
    
    // Number of loses
    var totalLoses = 0
    
    // Number of wins
    var totalWins = 0
    
    // Starts new round. R
    mutating func startNewRound() -> GameState {
        // Safety checks or game over
        guard !wordlist.isEmpty,
              let symbolsShown = visibleRange.randomElement(),
              symbolsShown > 0
        else {
            // If no words left to guess, game is over
            return wordlist.isEmpty ? .gameOver : .internalError
        }
        // Random word from an array, it's removed for next rounds until array is empty (then game is over)
        let newWord = wordlist.remove(at: Int.random(in: 0..<wordlist.count))
    
        // Make all symbols hidden by default, then showing some of them
        data = newWord.map {(symbol: $0, state: .hidden)}
        
        charactersLeft = newWord.count

        for _ in 0..<symbolsShown {
            if let element = data.randomElement()?.symbol {
                _ = guessCharacter(element)
                charactersLeft -= 1
            }
        }
        
        return .roundStarted(charactersLeft: newWord.count)
    }
    
    mutating func updateScore(symbolRight: Bool, wordRight: Bool, noLettersRemaining: Bool) -> CharacterGuessState {
        if wordRight {
            currentScore += 10
            totalWins += 1
            return .roundFinished
        } else if noLettersRemaining {
            currentScore -= 10
            totalLoses += 1
            return .roundFailed
        }
        currentScore += symbolRight ? 1 : -1
        return symbolRight ? .right : .wrong
    }
    
    // Guessing a word
    mutating func guessCharacter(_ char: Character) -> CharacterGuessState {
        guard let comparedWith = char.uppercased().first else { return .error }
        var successful = false
        var counter = 0
        for index in 0..<data.count {
            if data[index].symbol == comparedWith {
                data[index].state = .shown
                successful = true
            }
            counter += data[index].state == .shown ? 1 : 0
        }
        charactersLeft -= successful ? 0 : 1
        return updateScore(
            symbolRight: successful,
            wordRight: counter == data.count,
            noLettersRemaining: charactersLeft <= 0
        )
        
    }

    private init(for words: [String], withSymbolsShown visibleRange: ClosedRange<Int>) {
        self.wordlist = words.map { $0.uppercased() }
        self.visibleRange = visibleRange
    }
    
}

