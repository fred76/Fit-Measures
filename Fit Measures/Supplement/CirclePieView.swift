//
//  CirclePieView.swift
//  iFit Girths & Caliper
//
//  Created by Alberto Lunardini on 15/04/2019.
//  Copyright © 2019 Alberto Lunardini. All rights reserved.
//

import UIKit

class CirclePieView:  UIView {
     
    var value : [CGFloat] = [0,0,0]
    func calcPercentage()->(carbs:CGFloat, fat:CGFloat, pro:CGFloat){
        let total = value[0]+value[1]+value[2]
        let carbsPercentage = (value[0]/total)*100
        let fatPercentage = (value[1]/total)*100
        let proteinPercentage = (value[2]/total)*100
        return (carbsPercentage, fatPercentage, proteinPercentage)
    }
    var carbsColor : UIColor = .blue
    var fatColor : UIColor = .red
    var proteinColor : UIColor = .green
    
    var carbsStartPoint : CGFloat = 0
    var fatStartPoint : CGFloat = 0
    var proteinStartPoint : CGFloat = 0
    
    var carbsFillPercentage : CGFloat = 0
    var fatFillPercentage : CGFloat = 0
    var proteinFillPercentage : CGFloat = 0
    
    
    //var startPoint: CGFloat = 0
    var color: UIColor = UIColor.yellow
    var trackColor: UIColor = UIColor.gray
    var trackWidth: CGFloat = 5
    var fillPercentage: CGFloat = 50
    
    override init(frame: CGRect) {
        
        super.init(frame: frame)
        self.backgroundColor = UIColor.clear
        
    } // init
    
    required init(coder aDecoder: NSCoder) {
        
        super.init(coder: aDecoder)!
        self.backgroundColor = UIColor.clear
        
    } // init
    
    private func getGraphStartAndEndPointsInRadians(startPointInsert : CGFloat, fillPercentageInsert:CGFloat) -> (graphStartingPoint: CGFloat, graphEndingPoint: CGFloat) {
        var startPoint = startPointInsert
        var fillPercentage = fillPercentageInsert
        // make sure our starting point is at least 0 and less than 100
        if ( 0 > startPoint ) {
            startPoint = 0
        } else if ( 100 < startPoint ) {
            startPoint = 100
        } // if
        
        // make sure our fill percentage is at least 0 and less than 100
        if ( 0 > fillPercentage ) {
            self.fillPercentage = 0
        } else if ( 100 < fillPercentage ) {
            fillPercentage = 100
        } // if
        
        // we take 25% off the starting point, so that a zero starting point
        // begins at the top of the circle instead of the right side...
        startPoint = startPoint - 25
        
        // we calculate a true fill percentage as we need to account
        // for the potential difference in starting points
        let trueFillPercentage = fillPercentage + startPoint
        
        let π: CGFloat = .pi
        
        // now we can calculate our start and end points in radians
        let newStartPoint: CGFloat = ((2 * π) / 100) * (CGFloat(startPoint))
        let endPoint: CGFloat = ((2 * π) / 100) * (CGFloat(trueFillPercentage))
        
        return(newStartPoint, endPoint)
        
    } // func
    
    override func draw(_ rect: CGRect) {
        
        // first we want to find the centerpoint and the radius of our rect
        
        let center: CGPoint = CGPoint(x: rect.midX, y: rect.midY)
        let radius: CGFloat = rect.width / 2
        
        // make sure our track width is at least 1
        if ( 1 > self.trackWidth) {
            self.trackWidth = 1
        } // if
        
        // and our track width cannot be greater than the radius of our circle
        if ( radius < self.trackWidth ) {
            self.trackWidth = radius
        } // if
        
        // we need our graph starting and ending points
        let (carbsGraphStartingPoint, carbsGraphEndingPoint) = self.getGraphStartAndEndPointsInRadians(startPointInsert: carbsStartPoint, fillPercentageInsert: calcPercentage().carbs)
        let (fatGraphStartingPoint, fatGraphEndingPoint) = self.getGraphStartAndEndPointsInRadians(startPointInsert: carbsStartPoint+calcPercentage().carbs, fillPercentageInsert: calcPercentage().fat)
        let (proteinGraphStartingPoint, proteinGraphEndingPoint) = self.getGraphStartAndEndPointsInRadians(startPointInsert: carbsStartPoint+calcPercentage().carbs+calcPercentage().fat, fillPercentageInsert: calcPercentage().pro)
        
        
        // now we can draw the progress arc
        let carbsPercentagePath = UIBezierPath(arcCenter: center, radius: radius - (trackWidth / 2), startAngle: carbsGraphStartingPoint, endAngle: carbsGraphEndingPoint, clockwise: true)
        carbsPercentagePath.lineWidth = trackWidth
        carbsPercentagePath.lineCapStyle = .square
        self.carbsColor.setStroke()
        carbsPercentagePath.stroke()
        
        let fatPercentagePath = UIBezierPath(arcCenter: center, radius: radius - (trackWidth / 2), startAngle: fatGraphStartingPoint, endAngle: fatGraphEndingPoint, clockwise: true)
        fatPercentagePath.lineWidth = trackWidth
        fatPercentagePath.lineCapStyle = .square
        self.fatColor.setStroke()
        fatPercentagePath.stroke()
        
        let proteinPercentagePath = UIBezierPath(arcCenter: center, radius: radius - (trackWidth / 2), startAngle: proteinGraphStartingPoint, endAngle: proteinGraphEndingPoint, clockwise: true)
        proteinPercentagePath.lineWidth = trackWidth
        proteinPercentagePath.lineCapStyle = .square
        self.proteinColor.setStroke()
        proteinPercentagePath.stroke()
        
        return
        
}
}
