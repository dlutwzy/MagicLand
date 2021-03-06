//
//  GameRunloop.swift
//  GameRunloop
//
//  Created by WZY on 2018/5/11.
//  Copyright © 2018年 WZY. All rights reserved.
//

import Foundation

public class GameRunloop {
    
    public static let instance: GameRunloop = GameRunloop()
    private init() {}
    
    /// 开始游戏循环线程
    ///
    /// - Parameter queue: 游戏计算所在的线程
    /// - Returns: 返回开启的结果
    public func start(gameRunloop queue: DispatchQueue? = nil) -> Bool {
        
        let result = controlSemaphore.wait(timeout: DispatchTime.now())
        defer {
            controlSemaphore.signal()
        }
        if result == .timedOut {
            return false
        }
        if isRunning == true {
            return false
        }
        
        let _ = runloopSemaphone.wait(timeout: DispatchTime.distantFuture)
        isRunning = true
        if let queue = queue {
            calculateQueue = queue
        } else {
            calculateQueue = DispatchQueue(label: StaticValue.calculateQueueLabel,
                                           qos: .default)
        }
        runloopQueue = DispatchQueue(label: StaticValue.runloopQueueLabel,
                                     qos: .default)
        runloopQueue?.async { [weak self] in
            self?.runloop()
        }
        
        return false
    }
    
    public func stageFigure(figure: Figure) {
        
        _ = actionSemaphone.wait(timeout: DispatchTime.distantFuture)
        
        switch figure.type {
            
        case .red:
            redArmy.append(figure)
        case .blue:
            blueArmy.append(figure)
        }
        
        _ = actionSemaphone.signal()
    }
    
    private func runloop() {
        
        defer {
            let _ = runloopSemaphone.signal()
        }
        
        var offset: CFAbsoluteTime = 0.0
        var lastTime: CFAbsoluteTime = CFAbsoluteTimeGetCurrent()
        
        while true {
            
            if isRunning == false {
                break
            }
            
            Thread.sleep(forTimeInterval: StaticValue.sleepInterval)
            
            let currentTime = CFAbsoluteTimeGetCurrent()
            if currentTime + offset - lastTime > StaticValue.stepInterval {
                
                //print("代码执行时长：\((currentTime - lastTime) * 1000) 毫秒")
                offset = currentTime - lastTime + offset - StaticValue.stepInterval
                lastTime = currentTime
                
                _ = actionSemaphone.wait(timeout: DispatchTime.distantFuture)
                
                let actionFigureList = raiseAllFigures()
                actionAllFigure(figures: actionFigureList)
                clearAllFigure()
                
                _ = actionSemaphone.signal()
            }
        }
    }
    
    private func raiseAllFigures() -> [Figure] {
        
        var retList: [Figure] = [Figure]()
        
        for figure in redArmy {
            if figure.raiseProcess() {
                retList.append(figure)
            }
        }
        
        for figure in blueArmy {
            if figure.raiseProcess() {
                retList.append(figure)
            }
        }
        
        return retList
    }
    
    private func actionAllFigure(figures: [Figure]) {
        
        for figure in figures {
            
            switch figure.type {
                
            case .red:
                figure.action(friendlyFigures: &redArmy, amryFigures: &blueArmy)
            case .blue:
                figure.action(friendlyFigures: &blueArmy, amryFigures: &redArmy)
            }
        }
    }
    
    private func clearAllFigure() {
        
        redArmy = redArmy.compactMap { $0.isDead ? nil : $0 }
        blueArmy = blueArmy.compactMap{ $0.isDead ? nil : $0 }
    }
    
    private var redArmy: [Figure] = [Figure]()
    private var blueArmy: [Figure] = [Figure]()
    
    public private(set) var isRunning: Bool = false

    private let controlSemaphore: DispatchSemaphore = DispatchSemaphore(value: 1)
    private let runloopSemaphone: DispatchSemaphore = DispatchSemaphore(value: 1)
    private let actionSemaphone: DispatchSemaphore = DispatchSemaphore(value: 1)
    private var runloopQueue: DispatchQueue?
    private var calculateQueue: DispatchQueue?
    
    private struct StaticValue {
        static let runloopQueueLabel = "com.dlut.wzy.gameRunloop"
        static let calculateQueueLabel = "com.dlut.wzy.figureCalculate"
        static let sleepInterval: TimeInterval = 0.02
        static let stepInterval: TimeInterval = 0.05
    }
}
