//
//  MovableView.swift
//  MovableView
//
//  Created by Gabriel D'Luca on 15/03/19.
//  Copyright © 2019 Gabriel D'Luca. All rights reserved.
//
//
//  The MIT License

/*
 The MIT License (MIT)
 
 Copyright (c) 2019 Gabriel D'Luca
 
 Permission is hereby granted, free of charge, to any person obtaining a copy
 of this software and associated documentation files (the "Software"), to deal
 in the Software without restriction, including without limitation the rights
 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 copies of the Software, and to permit persons to whom the Software is
 furnished to do so, subject to the following conditions:
 
 The above copyright notice and this permission notice shall be included in all
 copies or substantial portions of the Software.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
 SOFTWARE.
 */

import UIKit

class MovableView: UIImageView {
    
    // MARK: - Variables
    private var isMoving:Bool = false
    public var objectiveVertex:CGPoint = CGPoint.zero
    public var objectiveCenter:CGPoint = CGPoint.zero
    weak var levelDelegate:MergeLevelDelegate?
    
    // MARK: - Initializers
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    init(image: UIImage) {
        super.init(image: image)
        self.isUserInteractionEnabled = true
    }
    
    // MARK: - Methods
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = event?.allTouches?.first
        let touchPoint = touch?.location(in: self.window)
        
        if self.frame.contains(touchPoint!){
            self.isMoving = true
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = event?.allTouches?.first
        let touchPoint = touch?.location(in: self.window)
        
        if self.isMoving {
            self.center = CGPoint(x: (touchPoint?.x)!, y: (touchPoint?.y)!)
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.isMoving = false
        
        let deltaX = self.objectiveCenter.x - self.center.x
        let deltaY = self.objectiveCenter.y - self.center.y
        
        if abs(deltaX) <= 10 && abs(deltaY) <= 10 {
            UIView.animate(withDuration: 0.25, animations: {
                self.center = self.objectiveCenter
            })
            self.isUserInteractionEnabled = false
            self.levelDelegate?.didFit(piece: self)
        }
    }
}
