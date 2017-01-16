//
//  DrawView.swift
//  TouchTracker
//
//  Created by Eric Dockery on 1/14/17.
//  Copyright © 2017 Eric Dockery. All rights reserved.
//

import UIKit

class DrawView: UIView {
    var currentLines = [NSValue: Line]()
    var finishedLines = [Line]()
    var selectedLineIndex: Int?
    
    @IBInspectable var finishedLineColor: UIColor = UIColor.black {
        didSet {
            setNeedsDisplay()
        }
    }
    
    @IBInspectable var currentLineColor: UIColor = UIColor.red {
        didSet {
            setNeedsDisplay()
        }
    }
    
    @IBInspectable var lessThanFortyFiveDegreeLineColor: UIColor = UIColor.purple {
        didSet {
            setNeedsDisplay()
        }
    }
    
    @IBInspectable var betweenFortyFiveAndNinteyLineColor: UIColor = UIColor.blue {
        didSet {
            setNeedsDisplay()
        }
    }
    @IBInspectable var betweenNinteyAndOneThirtyFive : UIColor = UIColor.yellow {
        didSet {
            setNeedsDisplay()
        }
    }
    
    @IBInspectable var lineThickness: CGFloat = 10 {
        didSet {
            setNeedsDisplay()
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        let doubleTapRecognizer = UITapGestureRecognizer(target: self, action: #selector(doubleTap(gestureRecognizer:)))
        doubleTapRecognizer.numberOfTapsRequired = 2
        doubleTapRecognizer.delaysTouchesBegan = true
        addGestureRecognizer(doubleTapRecognizer)
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(tap(gestureRecognizer:)))
        tapRecognizer.delaysTouchesBegan = true
        tapRecognizer.require(toFail: doubleTapRecognizer)
        addGestureRecognizer(tapRecognizer)
    }
    
    func strokeLine(line: Line) {
        let path = UIBezierPath()
        path.lineWidth = lineThickness
        path.lineCapStyle = CGLineCap.round
        path.move(to: line.begin)
        path.addLine(to: line.end)
        path.stroke()
    }
    
    func doubleTap(gestureRecognizer: UIGestureRecognizer) {
        currentLines.removeAll(keepingCapacity: false)
        finishedLines.removeAll(keepingCapacity: false)
        setNeedsDisplay()
    }
    
    func tap(gestureRecognizer: UIGestureRecognizer) {
        
    }
    
    override func draw(_ rect: CGRect) {
        finishedLineColor.setStroke()
        for line in finishedLines {
            let angle = line.angle
            switch angle {
            case 0...44.999:
                lessThanFortyFiveDegreeLineColor.setStroke()
            case 45...89.999:
                betweenFortyFiveAndNinteyLineColor.setStroke()
            case 90...134.999:
                betweenNinteyAndOneThirtyFive.setStroke()
            default:
                currentLineColor.setStroke()
            }
            strokeLine(line: line)
        }
        currentLineColor.setStroke()
        for (_, line) in currentLines{
            strokeLine(line: line)
        }
        if let index = selectedLineIndex {
            UIColor.green.setStroke()
            let selectedLine = finishedLines[index]
            strokeLine(line: selectedLine)
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let location = touch.location(in: self)
            let newLine = Line(begin: location, end: location)
            let key = NSValue(nonretainedObject: touch)
            currentLines[key] = newLine
        }
        setNeedsDisplay()
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let key = NSValue(nonretainedObject: touch)
            currentLines[key]?.end = touch.location(in: self)
        }
        setNeedsDisplay()
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let key = NSValue(nonretainedObject: touch)
            if var line = currentLines[key] {
                line.end = touch.location(in: self)
                print(line.angle)
                finishedLines.append(line)
                currentLines.removeValue(forKey: key)
            }
        }
        setNeedsDisplay()
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        currentLines.removeAll()
        setNeedsDisplay()
    }
    
}
