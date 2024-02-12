//
//  DetectorView.swift
//  MagicIDR
//
//  Created by Hisop on 2024/02/08.
//

import UIKit

final class DetectorView: UIView {
    private var rectangleFeature: CIRectangleFeature?
    private var widthRatio: CGFloat?
    private var heightRatio: CGFloat?
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)

        let path = makePath()
    
        UIColor.red.setStroke()
        path.stroke()
    }
        
    private func makePath() -> UIBezierPath {
        let path = UIBezierPath()
        
        guard let rectangleFeature = rectangleFeature,
              let widthRatio = widthRatio,
              let heightRatio = heightRatio
        else {
            return path
        }
        
        let topLeft = CGPoint(
            x: rectangleFeature.topLeft.x * widthRatio,
            y: correctionPoint(point: rectangleFeature.topLeft.y * heightRatio)
        )
        
        let topRight = CGPoint(
            x: rectangleFeature.topRight.x * widthRatio,
            y: correctionPoint(point: rectangleFeature.topRight.y * heightRatio)
        )
        
        let bottomLeft = CGPoint(
            x: rectangleFeature.bottomLeft.x * widthRatio,
            y: correctionPoint(point: rectangleFeature.bottomLeft.y * heightRatio)
        )
        
        let bottomRight = CGPoint(
            x: rectangleFeature.bottomRight.x * widthRatio,
            y: correctionPoint(point: rectangleFeature.bottomRight.y * heightRatio)
        )
        
        path.move(to: topLeft)
        path.addLine(to: topRight)
        path.addLine(to: bottomRight)
        path.addLine(to: bottomLeft)
        path.close()
        
        return path
    }
    
    private func correctionPoint(point: CGFloat) -> CGFloat {
        let frameHeight = self.frame.height
        
        if point - 90 < 0 {
            return CGFloat(0)
        }
        
        if point - 90 > frameHeight {
            return CGFloat(frameHeight)
        }
        
        return CGFloat(point - 90)
    }
    
    func setRectangle(rectangleFeature: CIRectangleFeature, widthRatio: CGFloat, heightRatio: CGFloat) {
        self.rectangleFeature = rectangleFeature
        self.widthRatio = widthRatio
        self.heightRatio = heightRatio
    }
}
