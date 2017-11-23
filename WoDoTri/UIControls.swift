//
//  UIControls.swift
//  WoDoTri
//
//  Created by Markus Staas (Lazada eLogistics Group) on 11/23/17.
//  Copyright © 2017 Markus Staas. All rights reserved.
//

import UIKit

class UIControls: UIViewController {
    
    func startActivity() {
        let button = UIButton(frame: CGRect(x: 100, y: 100, width: 100, height: 50))
        button.backgroundColor = .green
        button.setTitle("Test Button", for: .normal)
        button.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
        self.view.addSubview(button)
        print("test")
    }
    
    @objc func buttonAction(sender: UIButton!) {
        print("Button tapped")
    }

}
