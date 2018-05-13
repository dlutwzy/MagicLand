//
//  ViewController.swift
//  MagicLand
//
//  Created by WZY on 2018/5/11.
//  Copyright © 2018年 WZY. All rights reserved.
//

import UIKit
import GameRunloop

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

extension ViewController: FigureDelegate {
    func figureDidDeath(figure: Figure) {
        <#code#>
    }
    
    
}

