//
//  ViewController.swift
//  Apple Pie
//
//  Created by Alexey Khestanov on 23.09.2022.
//

import UIKit

class ViewController: UIViewController {
 
    @IBOutlet var apples: [UIImageView]!
    
    @IBOutlet var buttons: [UIButton]!
    
    @IBOutlet var correctWord: NSLayoutConstraint!
 
    @IBOutlet var scoreLabel: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }


}

