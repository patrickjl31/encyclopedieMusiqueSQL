//
//  CustomButton.swift
//  encyclopedieMusiqueSQL
//
//  Created by patrick lanneau on 13/01/2020.
//  Copyright © 2020 patrick lanneau. All rights reserved.
//

import UIKit

class CustomButton: UIButton {

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    func setup()  {
        layer.cornerRadius = self.frame.height / 2
        backgroundColor = color_bleu_sombre
        //setTitle(title, for: .normal)
        titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        setTitleColor(.white, for: .normal)
    }
}
