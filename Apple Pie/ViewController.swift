//
//  ViewController.swift
//  Apple Pie
//
//  Created by Alexey Khestanov on 23.09.2022.
//

import UIKit

class ViewController: UIViewController {
 
    @IBOutlet var apples: [UIImageView]!
 
    var isVisible: [Bool] = []
    
    @IBOutlet var buttons: [UIButton]!
    
    @IBAction func letterPressed(_ sender: Any) {
    }
    
    
    @IBOutlet var currentWord: UILabel!
    
    @IBOutlet var scoreText: UILabel!
    
    func UpdateUI() {
//        scoreText.text = "Total wins: \(totalWins), loses: \(totalLoses)."
        var remainingCount = isVisible.filter { $0 }.count
        
        for (index, visible) in isVisible.enumerated() {
            if remainingCount == 0 {
                break
            }
            if visible {
                apples[index].isHidden = true
                remainingCount -= 1
            }
        }
        
        
    }
        
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }


}

