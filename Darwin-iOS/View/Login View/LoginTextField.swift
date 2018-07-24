//
//  LoginTextField.swift
//  Darwin-iOS
//
//  Created by Zenos on 7/16/18.
//  Copyright © 2018 Zixia. All rights reserved.
//

import UIKit
import QuartzCore

class LoginTextField: UITextField {

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.configureUI()
    }

    private func configureUI() {
        self.layer.borderColor = UIColor.gray.cgColor
        self.layer.borderWidth = 0.5
        self.layer.cornerRadius = 4.0
    }
}
