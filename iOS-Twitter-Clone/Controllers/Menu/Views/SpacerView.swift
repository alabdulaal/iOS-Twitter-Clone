//
//  SpacerView.swift
//  iOS-Twitter-Automation
//
//  Created by ahmed on 2/11/19.
//  Copyright © 2019 com.ahmed. All rights reserved.
//

import UIKit

class SpacerView: UIView {

    let space: CGFloat
    
    override var intrinsicContentSize: CGSize {
        return .init(width: space, height: space)
    }
    
    init(space: CGFloat) {
        self.space = space
        super.init(frame: .zero)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
