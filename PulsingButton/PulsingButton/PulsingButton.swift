//
//  PulsingButton.swift
//  PulsingButton
//
//  Created by Sergey Makeev on 21.03.2020.
//  Copyright © 2020 SOME projects. All rights reserved.
//

import Foundation
import UIKit

public class PulsingButton: UIButton{
	internal class ButtonPulsingLayerHelper: NSObject, PulsingLayerAnymationDelegate {
		var position: CGPoint {
			guard let owner = owner else { return CGPoint.zero}
			var point = CGPoint.zero
			point.x = owner.bounds.size.width  / 2
			point.y = owner.bounds.size.height / 2
			
			return point
		}
		
		var colorForLayer: UIColor {
			return owner?.pulsingColor ?? .white
		}
		
		weak var owner: PulsingButton? = nil
		
		init(with button: PulsingButton) {
			owner = button
			super.init()
		}
		
		func addPulsingAnimation() {
			guard let owner = owner else { return }
			let layer = PulsingLayer(with: self, initialScale: 0, delay: 0, duration: 1.5, radius: owner.frame.size.width)
			owner.layer.insertSublayer(layer, below: owner.layer)
		}
	}

	public var pulsingColor: UIColor = .white
	public var pulsingOnBegin = true
	public var pulsingOnEnd   = true
	
	public var onAnimationsCompleted: (() -> Void)?

	public func initialize() {
		initialTransform = self.transform
		helper = ButtonPulsingLayerHelper(with: self)
	}
	
	private var initialTransform: CGAffineTransform = .identity
	private var helper: ButtonPulsingLayerHelper!
	
	public override func awakeFromNib() {
		super.awakeFromNib()
		initialize()
	}
	
	public convenience init() {
		self.init(frame: .zero)
		initialize()
	}
	
	public override init(frame: CGRect) {
		super.init(frame: frame)
		initialize()
	}
	
	public required init?(coder: NSCoder) {
		super.init(coder: coder)
		initialize()
	}
	
	public override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
		self.layer.removeAllAnimations()
		
		if let sublayers = self.layer.sublayers {
			for layer in sublayers {
				layer.removeAllAnimations()
			}
		}
		self.transform = self.transform.scaledBy(x: 1.4, y: 1.4)
		if pulsingOnBegin {
			helper.addPulsingAnimation()
		}
		super.touchesBegan(touches, with: event)
	}
	
	public override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
		UIView.animate(withDuration: 0.5,
							  delay: 0,
			 usingSpringWithDamping: 0.5,
			  initialSpringVelocity: 6.0,
							options: .allowUserInteraction,
							animations: {
								self.transform = self.initialTransform
								
							},
							completion: { finished in
								if finished, let competionHandler = self.onAnimationsCompleted {
									UIView.animate(withDuration: 0.5, animations: {
										competionHandler()
									})
								}
							})
		if pulsingOnEnd {
			helper.addPulsingAnimation()
		}
		super.touchesEnded(touches, with: event)
	}
}
