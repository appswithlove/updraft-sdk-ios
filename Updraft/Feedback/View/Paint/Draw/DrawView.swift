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
			static let width: CGFloat = 5.0
		}
	}
	
	private struct Line {
		var path: CGMutablePath
		var color: CGColor
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
	private var lines = [Line]()
	
	// MARK: Public Interface
	
	var onTouchBegan: () -> Void = {}
	var drawBrush: Brush = .brush(UIColor.black.cgColor)
	var isEraserActive = false
	
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
		lines.removeAll()
		setNeedsDisplay()
	}
	
	// MARK: Touches
	
	override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
		guard let touch = touches.first else { return }
		onTouchBegan()
		swiped = false
		
		switch drawBrush {
		case .eraser:
			return
		case .brush(let color):
			pointIndex = 0
			let currentPoint = touch.location(in: drawImageView)
			points[0] = currentPoint
			
			let line = Line(path: CGMutablePath(), color: color)
			lines.append(line)
		}
	}
	
	override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
		guard let touch = touches.first,
			let event = event,
			let touches = event.coalescedTouches(for: touch)
			else { return }
		
		swiped = true
		
		switch drawBrush {
		case .eraser:
			touches.forEach { erase(for: $0) }
		case .brush:
			touches.forEach { draw(for: $0) }
		}
	}
	
	override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
		switch drawBrush {
		case .eraser:
			guard let touch = touches.first else { return }
			erase(for: touch)
		case .brush:
			if !swiped, let currentPath = lines.last {
				addSubPath(to: currentPath.path, fromPoint: points[0], toPoint: points[0], controlPoint1: nil, controlPoint2: nil)
			}
		}
	}
	
	override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
		touchesEnded(touches, with: event)
	}
	
	// MARK: Draw
	
	override func draw(_ rect: CGRect) {
		drawImageView.image = nil
		UIGraphicsBeginImageContext(drawImageView.bounds.size)
		guard let context = UIGraphicsGetCurrentContext() else {return}
		drawImageView.image?.draw(in: drawImageView.bounds)
		
		context.setLineCap(CGLineCap.round)
		context.setLineWidth(Constants.Stroke.width)
		context.setBlendMode(CGBlendMode.normal)
		
		for line in lines {
			context.setStrokeColor(line.color)
			context.addPath(line.path)
			context.strokePath()
		}
		
		drawImageView.image = UIGraphicsGetImageFromCurrentImageContext()
		drawImageView.sizeToFit()
	}
	
	private func draw(for touch: UITouch) {
		pointIndex += 1
		let currentPoint = touch.location(in: drawImageView)
		points[pointIndex] = currentPoint
		
		if pointIndex == 4 {
			//1. Move the endpoint to the middle of the line joining the second control point of the first Bezier segment
			// and the first control point of the second Bezier segment
			points[3] = CGPoint(x: (points[2].x + points[4].x)/2.0, y: (points[2].y + points[4].y) / 2.0)
			
			//2. draw
			if let currentPath = lines.last {
				addSubPath(to: currentPath.path, fromPoint: points[0], toPoint: points[3], controlPoint1: points[1], controlPoint2: points[2])
			}
			
			//3. replace points and get ready to handle the next segment
			points[0] = points[3]
			points[1] = points[4]
			pointIndex = 1
		}

	}
	
	private func erase(for touch: UITouch) {
		let location = touch.location(in: drawImageView)
		let previousLocation = touch.previousLocation(in: drawImageView)
		let hitTestPoints = hitPoints(fromPoint: previousLocation, toPoint: location, distance: Constants.Stroke.width)
		for point in hitTestPoints {
			//Reverse array to be able to safely remove lines during iteration
			for (index, line) in lines.enumerated().reversed() {
				//Create a stroked copy, for hit testing
				let pathCopy = line.path.copy(strokingWithWidth: Constants.Stroke.width * 2, lineCap: .round, lineJoin: .round, miterLimit: 1)
				if pathCopy.contains(point) {
					lines.remove(at: index)
				}
			}
		}
		setNeedsDisplay()
	}
	
	private func addSubPath(to path: CGMutablePath, fromPoint: CGPoint, toPoint: CGPoint, controlPoint1: CGPoint?, controlPoint2: CGPoint?) {
		let subPath = CGMutablePath()
		subPath.move(to: fromPoint)
		if let cPoint1 = controlPoint1, let cPoint2 = controlPoint2 {
			subPath.addCurve(to: toPoint, control1: cPoint1, control2: cPoint2)
		} else {
			subPath.addLine(to: toPoint)
		}
		path.addPath(subPath)
		setNeedsDisplay()
	}
	
	// MARK: - Convenience
	
	/// Returns hit points along an imaginary straight line between fromPoint and toPoint, starting from fromPoint with a
	/// given distance between them.
	///
	/// - Parameters:
	///   - fromPoint: The starting point
	///   - toPoint: The ending point
	///   - distance: The distance between hit points
	private func hitPoints(fromPoint: CGPoint, toPoint: CGPoint, distance: CGFloat) -> [CGPoint] {
		
		let v = CGVector(dx: toPoint.x - fromPoint.x, dy: toPoint.y - fromPoint.y)
		let length = sqrt(v.dx * v.dx + v.dy * v.dy)
		let u = CGVector(dx: v.dx / length, dy: v.dy / length)
		
		let numberOfPoints = Int(floor(length / distance))
		
		var hitPoints = [fromPoint, toPoint]
		if numberOfPoints > 0 {
			for i in 1...numberOfPoints {
				let point = CGPoint(x: fromPoint.x + distance * CGFloat(i) * u.dx, y: fromPoint.y + distance * CGFloat(i) * u.dy)
				hitPoints.append(point)
			}
		}
		return hitPoints
	}
}
