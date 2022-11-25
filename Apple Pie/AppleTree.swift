//
//  AppleTree.swift
//  Apple Pie
//
//  Created by Alexey Khestanov on 08.11.2022.
//
import UIKit

class AppleTree: UIView {
    
    @IBOutlet var contentView: AppleTree!
    
    @IBOutlet var apples: [UIImageView]!
    
    override init(frame: CGRect) { // for using CustomView in code
        super.init (frame: frame)
        commonInit()
    }
    required init?(coder aDecoder: NSCoder) { // for using CustomView in IB
        super.init(coder: aDecoder)
        commonInit ()
    }
    
    func commonInit() {
        // Do stuff here
        Bundle.main.loadNibNamed("AppleTree", owner: self)
        addSubview(contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
    }
}
