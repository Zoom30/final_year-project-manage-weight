//
//  ProgressViewUIView.swift
//  myReboundShape
//
//  Created by Daniel Ghebrat on 23/04/2021.
//

import UIKit
import RealmSwift

class ProgressViewUIView: UIView {
    
    
    var accessToInitialWeightAndHeight : Results<InitialWeightAndHeight>?
    var accessToTargetWeight : Results<SetTargetWeight>?
    let shapeLayer = CAShapeLayer()
    let trackShapeLayer = CAShapeLayer()

    override func draw(_ rect: CGRect) {
        print("draw method has been called")
        
        drawCircle()
        
        
    }
    
    
    
    private func drawCircle(){
        loadData()
        let targetKgValue = accessToTargetWeight![0].targetWeight
        let initialKgValue = accessToInitialWeightAndHeight![0].weight
        let centerPoint = CGPoint(x: bounds.size.width/2, y: bounds.size.height/2)
        let trackPath = UIBezierPath(arcCenter: centerPoint, radius: 100, startAngle: 0, endAngle: 2 * CGFloat.pi, clockwise: true)
        trackShapeLayer.path = trackPath.cgPath
        trackShapeLayer.lineWidth = 8
        trackShapeLayer.strokeColor = UIColor.lightGray.cgColor
        trackShapeLayer.fillColor = UIColor.clear.cgColor
        layer.addSublayer(trackShapeLayer)
        
        
        
        if initialKgValue <= targetKgValue {
            let circularPath = UIBezierPath(arcCenter:centerPoint, radius: 100, startAngle: CGFloat(270).degreesToRadians, endAngle: CGFloat(initialKgValue/targetKgValue * 360 + 270).degreesToRadians , clockwise: true)
            shapeLayer.path = circularPath.cgPath
            shapeLayer.lineWidth = 10
            shapeLayer.lineCap = CAShapeLayerLineCap.round
            shapeLayer.strokeColor = UIColor.green.cgColor
            shapeLayer.fillColor = UIColor.clear.cgColor
            layer.addSublayer(shapeLayer)
            
            let basicAnimation = CABasicAnimation(keyPath: "strokeEnd")
            basicAnimation.fromValue = 0
            basicAnimation.toValue = 1
            basicAnimation.duration = 2
            basicAnimation.isRemovedOnCompletion = false
            basicAnimation.fillMode = CAMediaTimingFillMode.forwards
            shapeLayer.add(basicAnimation, forKey: "line")
        }
        
        
        
        if initialKgValue > targetKgValue {
            let circularPath = UIBezierPath(arcCenter:centerPoint, radius: 100, startAngle: (3/2 * CGFloat.pi), endAngle: CGFloat(targetKgValue/initialKgValue) * (2 * CGFloat.pi) + (3/2 * CGFloat.pi), clockwise: true)
            shapeLayer.path = circularPath.cgPath
            shapeLayer.lineWidth = 10
            shapeLayer.lineCap = CAShapeLayerLineCap.round
            shapeLayer.strokeColor = UIColor.red.cgColor
            shapeLayer.fillColor = UIColor.clear.cgColor
            layer.addSublayer(shapeLayer)
            
            
            let basicAnimation = CABasicAnimation(keyPath: "strokeEnd")
            basicAnimation.fromValue = 0
            basicAnimation.toValue = 1
            basicAnimation.duration = 2
            basicAnimation.isRemovedOnCompletion = false
            basicAnimation.fillMode = CAMediaTimingFillMode.forwards
            shapeLayer.add(basicAnimation, forKey: "line")
            
        }
    }
    
    
    
    
    func drawShape()  {
        setNeedsDisplay()
    }
    
    
    
    func loadData(){
        if let realm = try? Realm(){
            accessToInitialWeightAndHeight = realm.objects(InitialWeightAndHeight.self)
            accessToTargetWeight = realm.objects(SetTargetWeight.self)
        }
    }
    
    
}


extension FloatingPoint{
    var degreesToRadians : Self {
        return self * .pi / 180
    }
}
