//
//  Model.swift
//  Apple Pie
//
//  Created by Alexey Khestanov on 27.09.2022.
//

import Foundation

let defaultSymbolsShown = 1...3
let defaultList = ["apple", "shark", "rabbit", "cat", "dictionary", "turtle", "dog"]

// A state of each character in a word being guessed
enum CharacterState {
    case hidden
    case wrong
    case shown
}

// Result of single character guess
enum CharacterGuessState {
    case right
    case wrong
    case roundFinished
    case roundFailed
}

// A state of the game, in case if round started,
enum GameState {
    case gameOver
    case roundStarted (applesLeft: Int)
    case internalError
}

// Game model
struct Game {
    // A singleton containing the game itself.
    static let shared = Game(for: defaultList, withSymbolsShown: defaultSymbolsShown)

    // Range refers to number of visible characters when each round starts
    let visibleRange: ClosedRange<Int>
    
    // When the game is active, a player can guess characters. When it's not, guessCharacter returns nil
    var gameIsActive  = false
    
    // Available words to guess during all rounds - each word per round
    var wordlist: [String]
    
    // Current word to guess
    var currentWord = ""
    
    // Status of each character for a word being guessed - hidden, guessed right, guessed wrong..
    var currentWordStatus: [CharacterState] = []

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
        // Character to suggest
        var charactersCount = newWord.count
        // Make all symbols hidden by default, then showing some of them
        currentWordStatus = Array(repeating: .hidden, count: charactersCount)
        for _ in 0..<symbolsShown {
            currentWordStatus[Int.random(in: 0..<currentWordStatus.count)] = .shown
            charactersCount -= 1
        }
        currentWord = newWord
        gameIsActive = true
        charactersLeft = charactersCount
        return .roundStarted(applesLeft: charactersCount)
    }
    
    // Guessing a word
    mutating func guessCharacter(_ char: Character) -> CharacterGuessState {
        charactersLeft -= 1
        // Searching for a match
        for (index, thisChar) in currentWord.enumerated() {
            if currentWordStatus[index] == .hidden {
                if thisChar == char {
                    currentWordStatus[index] = .shown
                    charactersLeft += 1
                    if currentWordStatus.filter { $0 == .hidden}.count < 1 {
                        totalWins += 1
                        currentScore += 10
                        return .roundFinished
                    } else {
                        currentScore += 1
                        return .right
                    }
                }
            }
        }
        if charactersLeft <= 0 {
            totalLoses += 1
            currentScore -= 10
            return .roundFailed
        } else {
            currentScore -= 1
            return .wrong
        }
    }

    
    private init(for words: [String], withSymbolsShown visibleRange: ClosedRange<Int>) {
        self.wordlist = words
        self.visibleRange = visibleRange
    }
    
}

