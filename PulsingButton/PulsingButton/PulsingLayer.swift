//
//  PulsingLayer.swift
//  PulsingButton
//
//  Created by Sergey Makeev on 21.03.2020.
//  Copyright © 2020 SOME projects. All rights reserved.
//

import Foundation
import UIKit
import QuartzCore

public protocol PulsingLayerAnymationDelegate: class, CAAnimationDelegate {
	var position: CGPoint { get }
	var colorForLayer: UIColor { get }
}

public class PulsingLayer: CALayer {
	private var animationGroup: CAAnimationGroup!
	private var initialPulseScale: CGFloat      = 0
	private var animationDuration: TimeInterval = 0
	private var radius: CGFloat = 0
	private var delay: TimeInterval   = 0
	
	public weak var animationDelegate: PulsingLayerAnymationDelegate? = nil
	
	public static let removeKey = "animationRemoveLayer"
	
	public init(with delegate: PulsingLayerAnymationDelegate,
				initialScale:  CGFloat,
				delay:         TimeInterval,
				duration:      TimeInterval,
				radius:        CGFloat) {
		animationDelegate = delegate
		super.init()
		self.subinit()
		self.delay = delay
		self.backgroundColor = delegate.colorForLayer.cgColor
		self.contentsScale = UIScreen.main.scale
		self.opacity = 0
		self.radius = radius
		self.initialPulseScale = initialScale
		self.animationDuration = duration
		self.bounds = CGRect(x: 0, y: 0, width: radius * 2, height: radius * 2)
		self.cornerRadius = radius
		self.masksToBounds   = false
		self.shouldRasterize = true
		self.rasterizationScale = UIScreen.main.scale
		DispatchQueue.global().async {
			self.setupAnimationGroup()
			DispatchQueue.main.async {
				self.add(self.animationGroup, forKey: "pulse")
			}
		}
	}
	
	public required init(coder: NSCoder) {
		super.init(coder: coder)!
		self.subinit()
	}
	
	public init(layer: CALayer) {
		super.init(layer: layer)
		self.subinit()
	}
	
	private func subinit() {
		animationGroup = CAAnimationGroup()
		initialPulseScale = 0
		animationDuration = 1.5
		radius = 200
		delay  = 0
		self.position = self.animationDelegate?.position ?? CGPoint(x: 0, y: 0)
	}
	
	private func createScaleAnimation() -> CABasicAnimation {
		let scaleAnimation = CABasicAnimation(keyPath: "transform.scale.xy")
		scaleAnimation.fromValue = initialPulseScale
		scaleAnimation.toValue = 1
		scaleAnimation.duration = animationDuration
		
		return scaleAnimation;
	}
	
	private func createOpacityAnimation() -> CAKeyframeAnimation {
		let opacityAnimation = CAKeyframeAnimation(keyPath: "opacity")
		opacityAnimation.duration = animationDuration
		opacityAnimation.values = [0.4, 0.8, 0]
		opacityAnimation.keyTimes = [0, 0.2, 1]
		
		return opacityAnimation;
	}
	
	private func setupAnimationGroup() {
		animationGroup.delegate = animationDelegate
		animationGroup.duration = animationDuration
		animationGroup.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.default)
		animationGroup.animations = [createScaleAnimation(), createOpacityAnimation()]
		animationGroup.setValue(self, forKey: PulsingLayer.removeKey)
		animationGroup.beginTime = CACurrentMediaTime() + delay
	}
}
