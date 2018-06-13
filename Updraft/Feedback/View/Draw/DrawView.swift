//
//  DrawView.swift
//  DrawDraw
//
//  Created by Raphael Neuenschwander on 17.04.18.
//  Copyright © 2018 Raphael Neuenschwander. All rights reserved.
//

import UIKit

class DrawView: UIView {
	
	struct Constants {
		struct Stroke {
			static let color = UIColor.red.cgColor
			static let width: CGFloat = 3.0
		}
	}
	
	private let backgroundImageView = UIImageView()
	private let drawImageView = UIImageView()
	
	// MARK: Init

	override init(frame: CGRect) {
		super.init(frame: frame)
		setup()
	}
	
	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
		setup()
	}
	
	// MARK: Setup
	
	private func setup() {
		autoresizesSubviews = true
		addSubview(backgroundImageView)
		backgroundImageView.stickToView(self)
		backgroundImageView.contentMode = .scaleAspectFit
		addSubview(drawImageView)
		drawImageView.stickToView(self)
	}
	
	// MARK: Drawing variables
	
	private var pointIndex = 0
	private var points = [CGPoint](repeating: CGPoint.zero, count: 5)
	private var swiped = false // Identify if strokes are continous
	
	// MARK: Public Interface
	
	var backgroundImage: UIImage? {
		didSet {
			backgroundImageView.image = backgroundImage
		}
	}
	
	var mergedImage: UIImage {
		UIGraphicsBeginImageContextWithOptions(frame.size, false, 0.0)
		
		draw(CGRect(x: 0, y: 0, width: frame.width, height: frame.height))
		
		backgroundImageView.image?.draw(in: backgroundImageView.bounds)
		drawImageView.image?.draw(in: drawImageView.bounds)
		
		let mergedImage = UIGraphicsGetImageFromCurrentImageContext()
		UIGraphicsEndImageContext()
		return mergedImage ?? UIImage()
	}
	
	func clearDrawing() {
		drawImageView.image = nil
	}
	
	// MARK: Touches
	
	override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
		swiped = false
		if let touch = touches.first {
			pointIndex = 0
			let currentPoint = touch.location(in: drawImageView)
			points[0] = currentPoint
		}
	}
	
	override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
		swiped = true
		if let touch = touches.first {
			pointIndex += 1
			let currentPoint = touch.location(in: drawImageView)
			points[pointIndex] = currentPoint
			
			if pointIndex == 4 {
				//1. Move the endpoint to the middle of the line joining the second control point of the first Bezier segment
				// and the first control point of the second Bezier segment
				points[3] = CGPoint(x: (points[2].x + points[4].x)/2.0, y: (points[2].y + points[4].y) / 2.0)
				
				//2. draw
				draw(fromPoint: points[0], toPoint: points[3], controlPoint1: points[1], controlPoint2: points[2])
				
				//3. replace points and get ready to handle the next segment
				points[0] = points[3]
				points[1] = points[4]
				pointIndex = 1
			}
		}
	}
	
	override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
		if !swiped {
			draw(fromPoint: points[0], toPoint: points[0], controlPoint1: nil, controlPoint2: nil)
		}
	}
	
	override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
		touchesEnded(touches, with: event)
	}
	
	// MARK: Draw
	
	private func draw(fromPoint: CGPoint, toPoint: CGPoint, controlPoint1: CGPoint?, controlPoint2: CGPoint?) {
		UIGraphicsBeginImageContext(drawImageView.bounds.size)
		guard let context = UIGraphicsGetCurrentContext() else {return}
		drawImageView.image?.draw(in: drawImageView.bounds)
	
		context.move(to: fromPoint)
		if let cPoint1 = controlPoint1, let cPoint2 = controlPoint2 {
			context.addCurve(to: toPoint, control1: cPoint1, control2: cPoint2)
		} else {
			context.addLine(to: toPoint)
		}
		
		context.setLineCap(CGLineCap.round)
		context.setLineWidth(Constants.Stroke.width)
		context.setStrokeColor(Constants.Stroke.color)
		context.setBlendMode(CGBlendMode.normal)
		
		context.strokePath()
		
		drawImageView.image = UIGraphicsGetImageFromCurrentImageContext()
		drawImageView.sizeToFit()
	}
}
