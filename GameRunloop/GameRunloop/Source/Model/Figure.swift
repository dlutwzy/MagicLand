//
//  Figure.swift
//  GameRunloop
//
//  Created by WZY on 2018/5/11.
//  Copyright © 2018年 WZY. All rights reserved.
//

import Foundation

public enum FigureType {
    case red
//    case neutral
    case blue
}

public protocol FigureDelegate: class {
    func figureDidDeath(figure: Figure)
}

public class Figure {
    
    weak var delegate: FigureDelegate?
    
    var type: FigureType = .red
    
    var isDead: Bool {
        return self.hp < 0
    }
    
    var hp: Int = 0 {
        didSet {
            if hp < 0 {
                delegate?.figureDidDeath(figure: self)
            }
        }
    }
    var mp: Int = 0
    
    var attack: Int = 0
    var defense: Int = 0
    
    var speed: Int = 0
    private var process: Int = 0
    
    weak var aimFigure: Figure?
    var summonFigures: [Figure] = [Figure]()
    
    private struct StaticValue {
        static let processMax: Int = 9999
    }
}

extension Figure {
    
    private func attack(figure: Figure) {
        figure.hp = self.attack - figure.defense
    }
}

extension Figure {
    
    func raiseProcess() -> Bool {
        
        process += speed
        if process > StaticValue.processMax {
            
            process = 0
            return true
        }
        
        return false
    }

    func action(friendlyFigures: inout [Figure],
                amryFigures: inout [Figure]) {
        
        if amryFigures.count == 0 {
            return
        }
    }
}
