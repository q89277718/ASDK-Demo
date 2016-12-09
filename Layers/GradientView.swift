//
//  GradientView.swift
//  Layers
//
//  Created by René Cacheaux on 10/18/14.
//  Copyright (c) 2014 Razeware LLC. All rights reserved.
//

import UIKit

class GradientView: UIView {

  required init(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)!
    backgroundColor = UIColor.clear
  }
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    backgroundColor = UIColor.clear
  }
  
  convenience init() {
    self.init(frame:  CGRect.zero)
  }
  
  override func draw(_ rect: CGRect) {
    let myContext = UIGraphicsGetCurrentContext()
    myContext!.saveGState()
    myContext!.clip(to: bounds)
    
    let componentCount: Int = 2
    let locations: [CGFloat] = [0.0, 1.0]
    let components: [CGFloat] = [0.0, 0.0, 0.0, 1.0,
                                 0.0, 0.0, 0.0, 0.0]
    let myColorSpace = CGColorSpaceCreateDeviceRGB()
    let myGradient = CGGradient(colorSpace: myColorSpace, colorComponents: components,
                                locations: locations, count: componentCount)
    
    let myStartPoint = CGPoint(x: bounds.midX, y: bounds.maxY)
    let myEndPoint = CGPoint(x: bounds.midX, y: bounds.midY)
    myContext?.drawLinearGradient(myGradient!, start: myStartPoint, end: myEndPoint, options: CGGradientDrawingOptions.drawsAfterEndLocation)
    
    myContext!.restoreGState()
  }
  
}
