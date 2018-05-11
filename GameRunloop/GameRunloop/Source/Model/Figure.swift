//
//  Figure.swift
//  GameRunloop
//
//  Created by WZY on 2018/5/11.
//  Copyright © 2018年 WZY. All rights reserved.
//

import Foundation

struct Figure {
    var hp: Int
    var mp: Int
    var attack: Int
    var defense: Int
    
    var speed: Int
    private var process: Int
    
    private struct StaticValue {
        static let processMax: Int = 9999
    }
}

extension Figure {
    
    @inline(__always)
    private mutating func raiseProcess() -> Bool {
        
        process += speed
        if process > StaticValue.processMax {
            
            process = 0
            return true
        }
        
        return false
    }
}

extension Figure {
    
    mutating func action(friendlyForces: inout [Figure],
                neutralForces: inout [Figure],
                hostileForces: inout [Figure]) {
        
        if raiseProcess() {
            
        }
    }
}
