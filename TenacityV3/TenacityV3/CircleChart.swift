//
//  CircleChart.swift
//  GraphsPractice
//
//  Created by Jackson Greaves on 7/29/19.
//  Copyright © 2019 Jackson Greaves. All rights reserved.
//

import Foundation
import UIKit


class CircleChart {
    public var outlineLayer: CAShapeLayer
    public var progressLayer: CAShapeLayer
    
    // possibly put text in here as public variables to be added to layers
    
    
    init(radius: CGFloat, progressEndAngle: CGFloat, center: CGPoint, lineWidth: CGFloat, outlineColor: CGColor, progressColor: CGColor) {
        
        self.outlineLayer = CAShapeLayer()
        self.progressLayer = CAShapeLayer()
        
        self.outlineLayer.path = UIBezierPath(arcCenter: center, radius: radius, startAngle: -0.5 * CGFloat.pi, endAngle: 1.5 * CGFloat.pi, clockwise: true).cgPath                 // sets the arc of the circle
        self.progressLayer.path = UIBezierPath(arcCenter: center, radius: radius, startAngle: -0.5 * CGFloat.pi, endAngle: (2*progressEndAngle - 0.5) * CGFloat.pi, clockwise: true).cgPath   // same as above, only has an end angle specified by progressEndAngle
        // above, maybe change progressEndAngle to be the actual end number (require no multiplication in the constructor)
        
        
        self.outlineLayer.strokeColor = outlineColor                            // should be set in global variables at the top of the ViewController file
        self.progressLayer.strokeColor = progressColor
        
        self.outlineLayer.fillColor = UIColor.clear.cgColor                     // this sets the inside of the circle to be transparent (clear)
        self.progressLayer.fillColor = UIColor.clear.cgColor
        
        self.outlineLayer.lineWidth = lineWidth
        self.progressLayer.lineWidth = lineWidth
        
        self.progressLayer.lineCap = CAShapeLayerLineCap.round
    }
    
}
