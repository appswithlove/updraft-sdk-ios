//
//  UIImage+DrawCircle.swift
//  Updraft
//
//  Created by Yanis Plumit on 15.09.2025.
//

import UIKit

extension UIImage {
    struct DrawingCircle {
        let center: CGPoint
        let radius: CGFloat
        let fill: UIColor?
        let stroke: UIColor?
        let lineWidth: CGFloat
    }
    
    func imageByDrawingCircles(
        _ circles: [DrawingCircle]
    ) -> UIImage {
        guard !circles.isEmpty else {
            return self
        }
        
        let format = UIGraphicsImageRendererFormat()
        format.scale = self.scale
        format.opaque = false

        let renderer = UIGraphicsImageRenderer(size: self.size, format: format)
        let img = renderer.image { ctx in
            self.draw(at: .zero)
            let cg = ctx.cgContext
            for c in circles {
                let rect = CGRect(x: c.center.x - c.radius,
                                  y: c.center.y - c.radius,
                                  width: c.radius * 2,
                                  height: c.radius * 2)

                cg.saveGState()
                if let fill = c.fill {
                    cg.setFillColor(fill.cgColor)
                    cg.fillEllipse(in: rect)
                }
                if let stroke = c.stroke {
                    cg.setStrokeColor(stroke.cgColor)
                    cg.setLineWidth(c.lineWidth)
                    cg.strokeEllipse(in: rect)
                }
                cg.restoreGState()
            }
        }
        return img
    }
}
