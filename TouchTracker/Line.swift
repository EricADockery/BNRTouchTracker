//
//  Line.swift
//  TouchTracker
//
//  Created by Eric Dockery on 1/14/17.
//  Copyright © 2017 Eric Dockery. All rights reserved.
//

import Foundation
import CoreGraphics

struct Line {
    var begin = CGPoint.zero
    var end = CGPoint.zero
    var angle : Double {
        let diffY = end.y - begin.y
        let diffX = end.x - begin.x
        let angleInRadiants = Double (atan2(diffY, diffX))
        let angle = angleInRadiants * 360 / (2 * M_PI)
        return angle < 0 ? angle + 360 : angle
    }
}
