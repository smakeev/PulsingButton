//
//  ViewController.swift
//  Example
//
//  Created by Sergey Makeev on 22.03.2020.
//  Copyright © 2020 SOME projects. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

	override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view.
		
		let button = PulsingButton()
		button.translatesAutoresizingMaskIntoConstraints = false
		
		self.view.addSubview(button)
		button.pulsingColor = .orange
		button.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
		button.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
		
		button.setTitle("   Press Me To See Pulsing   ", for: .normal)
		button.layer.cornerRadius = 25
		button.backgroundColor = .orange
	}


}

