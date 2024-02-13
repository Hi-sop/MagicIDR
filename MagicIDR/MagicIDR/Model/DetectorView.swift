//
//  DetectorView.swift
//  MagicIDR
//
//  Created by Hisop on 2024/02/08.
//

import UIKit

final class DetectorView: UIView {
    private var widthRatio: CGFloat?
    private var heightRatio: CGFloat?
    private var correction: CGFloat = 115
    
    private var topLeft: CGPoint = CGPoint()
    private var topRight: CGPoint = CGPoint()
    private var bottomLeft: CGPoint = CGPoint()
    private var bottomRight: CGPoint = CGPoint()
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)

        let path = makePath()
    
        UIColor().mainColor.setFill()
        UIColor().subColor.setStroke()
        path.lineWidth = 5
        
        path.stroke()
        path.fill()
    }
        
    private func makePath() -> UIBezierPath {
        let path = UIBezierPath()
        
        path.move(to: topLeft)
        path.addLine(to: topRight)
        path.addLine(to: bottomRight)
        path.addLine(to: bottomLeft)
        path.close()
        
        return path
    }
    
    private func correctionPoint(point: CGFloat) -> CGFloat {
        let frameHeight = self.frame.height
        
        if point - correction < 0 {
            return CGFloat(0)
        }
        
        if point - correction > frameHeight {
            return CGFloat(frameHeight)
        }
        
        return CGFloat(point - correction)
    }
    
    func setRectangle(rectangleFeature: CIRectangleFeature, widthRatio: CGFloat, heightRatio: CGFloat) {
        self.widthRatio = widthRatio
        self.heightRatio = heightRatio
        
        topLeft = CGPoint(
            x: rectangleFeature.topLeft.x * widthRatio,
            y: correctionPoint(point: rectangleFeature.topLeft.y * heightRatio)
        )
        
        topRight = CGPoint(
            x: rectangleFeature.topRight.x * widthRatio,
            y: correctionPoint(point: rectangleFeature.topRight.y * heightRatio)
        )
        
        bottomLeft = CGPoint(
            x: rectangleFeature.bottomLeft.x * widthRatio,
            y: correctionPoint(point: rectangleFeature.bottomLeft.y * heightRatio)
        )
        
        bottomRight = CGPoint(
            x: rectangleFeature.bottomRight.x * widthRatio,
            y: correctionPoint(point: rectangleFeature.bottomRight.y * heightRatio)
        )
    }
    
    func setData(data: PhotoData) {
        topLeft = CGPoint(
            x: data.cutPoint.topLeft.x * (data.widthRatio),
            y: correctionPoint(point: data.cutPoint.topLeft.y * (data.heightRatio))
        )
        
        topRight = CGPoint(
            x: data.cutPoint.topRight.x * (data.widthRatio),
            y: correctionPoint(point: data.cutPoint.topRight.y * (data.heightRatio))
        )
        
        bottomLeft = CGPoint(
            x: data.cutPoint.bottomLeft.x * (data.widthRatio),
            y: correctionPoint(point: data.cutPoint.bottomLeft.y * (data.heightRatio))
        )
        
        bottomRight = CGPoint(
            x: data.cutPoint.bottomRight.x * (data.widthRatio),
            y: correctionPoint(point: data.cutPoint.bottomRight.y * (data.heightRatio))
        )
    }
    
}
