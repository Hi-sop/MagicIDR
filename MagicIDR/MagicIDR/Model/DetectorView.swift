//
//  DetectorView.swift
//  MagicIDR
//
//  Created by Hisop on 2024/02/08.
//

import UIKit

final class DetectorView: UIView {
    var rectangleFeature: CIRectangleFeature?
    var tempRect: CGRect?
    var widthRatio: CGFloat?
    var heightRatio: CGFloat?
    let newLayer = CAShapeLayer()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        //newLayer.frame = layer.bounds
        //layer.addSublayer(newLayer)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
                
        //topLeft가 내가 생각하는 topLeft가 아닐수도 있음...
        
        guard let rectangleFeature =  rectangleFeature else {
            return
        }
        
        let topLeft = CGPoint(
            x: rectangleFeature.topLeft.x * (widthRatio ?? 0),
            y: correctionPoint(point: rectangleFeature.topLeft.y * (heightRatio ?? 0))
        )
        
        let topRight = CGPoint(
            x: rectangleFeature.topRight.x * (widthRatio ?? 0),
            y: correctionPoint(point: rectangleFeature.topRight.y * (heightRatio ?? 0))
        )
        let bottomLeft = CGPoint(
            x: rectangleFeature.bottomLeft.x * (widthRatio ?? 0),
            y: correctionPoint(point: rectangleFeature.bottomLeft.y * (heightRatio ?? 0))
        )
        let bottomRight = CGPoint(
            x: rectangleFeature.bottomRight.x * (widthRatio ?? 0),
            y: correctionPoint(point: rectangleFeature.bottomRight.y * (heightRatio ?? 0))
        )
        guard let tempRect = tempRect else {
            return
        }
        
        
        
        
        //let pathtemp = UIBezierPath(rect: tempRect)

//        newLayer.path = pathtemp.cgPath
//        newLayer.strokeColor = UIColor.red.cgColor
//        newLayer.fillColor = UIColor.clear.cgColor
//        
//        layer.addSublayer(newLayer)
        
//        print("topLeft: \(bottomLeft.y), \(bottomLeft.x)")
//        print("topRight: \(topLeft.y), \(topLeft.x)")
//        print("bottomLeft: \(bottomRight.y), \(bottomRight.x)")
//        print("bottomRight: \(topRight.y), \(topRight.x)")
        
        //제가 받은 좌표는 기기의 실제 좌표를 받는 느낌
        
        // 변환된 좌표로 사각형 그리기
       // let path = UIBezierPath()
        
        //let pathtemp = UIBezierPath(rect: tempRect)
        let pathtemp = UIBezierPath()
        
        pathtemp.move(to: topLeft)
        pathtemp.addLine(to: topRight)
        pathtemp.addLine(to: bottomRight)
        pathtemp.addLine(to: bottomLeft)
        
        pathtemp.close()
        
        UIColor.red.setStroke()
        pathtemp.stroke()
        
        
        
//        path.move(to: CGPoint(x: rectangleFeature.topLeft.x, y: rect.height - rectangleFeature.topLeft.y))
//        path.addLine(to: CGPoint(x: rectangleFeature.topRight.x, y: rect.height - rectangleFeature.topRight.y))
//        path.addLine(to: CGPoint(x: rectangleFeature.bottomLeft.x, y: rect.height - rectangleFeature.bottomLeft.y))
//        path.addLine(to: CGPoint(x: rectangleFeature.bottomRight.x, y: rect.height - rectangleFeature.bottomRight.y))
        

        
//        path.move(to: topLeft)
//        path.addLine(to: bottomLeft)
//        
//        path.addLine(to: bottomRight)
//        path.addLine(to: topRight)
//        path.close()
//        
////        path.move(to: CGPoint(x: 5.2, y: 78.5))
////        path.addLine(to: CGPoint(x: 10.54, y: 307))
////        path.addLine(to: CGPoint(x: 212, y: 300))
////        path.addLine(to: CGPoint(x: 200, y: 73.25))
//        
////        path.close()
//        
//        UIColor.red.setStroke()
//        path.stroke()
    }
}
