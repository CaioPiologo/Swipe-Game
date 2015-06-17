//
//  GameScene.swift
//  Swipe Hero
//
//  Created by Caio Vinícius Piologo Véras Fernandes on 6/17/15.
//  Copyright (c) 2015 Caio. All rights reserved.
//

import SpriteKit

let LEFT = 0
let RIGHT = 1

class GameScene: SKScene {
    
    var arrowQueue:Array<Queue<Arrow>> = [Queue<Arrow>(),Queue<Arrow>()]
    var arrowSpeed:NSTimeInterval = 1.0
    
    override func didMoveToView(view: SKView) {
        /* Setup your scene here */
        self.size = UIScreen.mainScreen().bounds.size
        
        /*Right and Left Views*/
        var leftView : UIView = UIView(frame: CGRectMake(0, 0, UIScreen.mainScreen().bounds.size.width/2, UIScreen.mainScreen().bounds.size.height))
        leftView.backgroundColor = UIColor.clearColor()
        
        var rightView = UIView(frame: CGRectMake(UIScreen.mainScreen().bounds.size.width/2, 0, UIScreen.mainScreen().bounds.size.width/2, UIScreen.mainScreen().bounds.size.height))
        rightView.backgroundColor = UIColor.clearColor()
        
        self.view?.addSubview(leftView)
        self.view?.addSubview(rightView)
        
        
        /*Gesture recognizer left view*/
        let swipeRightLeftViewRecognizer: UISwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action:"swipeRightLeftView:")
        let swipeLeftLeftViewRecognizer: UISwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action:"swipeLeftLeftView:")
        let swipeUpLeftViewRecognizer: UISwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action:"swipeUpLeftView:")
        let swipeDownLeftViewRecognizer: UISwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action:"swipeDownLeftView:")
        
        swipeRightLeftViewRecognizer.direction = .Right
        swipeLeftLeftViewRecognizer.direction = .Left
        swipeUpLeftViewRecognizer.direction = .Up
        swipeDownLeftViewRecognizer.direction = .Down
        
        leftView.addGestureRecognizer(swipeRightLeftViewRecognizer)
        leftView.addGestureRecognizer(swipeLeftLeftViewRecognizer)
        leftView.addGestureRecognizer(swipeUpLeftViewRecognizer)
        leftView.addGestureRecognizer(swipeDownLeftViewRecognizer)
        
        /*Gesture Recognizer right view*/
        let swipeRightRightViewRecognizer: UISwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action:"swipeRightRightView:")
        let swipeLeftRightViewRecognizer: UISwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action:"swipeLeftRightView:")
        let swipeUpRightViewRecognizer: UISwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action:"swipeUpRightView:")
        let swipeDownRightViewRecognizer: UISwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action:"swipeDownRightView:")
        
        swipeRightRightViewRecognizer.direction = .Right
        swipeLeftRightViewRecognizer.direction = .Left
        swipeUpRightViewRecognizer.direction = .Up
        swipeDownRightViewRecognizer.direction = .Down
        
        rightView.addGestureRecognizer(swipeRightRightViewRecognizer)
        rightView.addGestureRecognizer(swipeLeftRightViewRecognizer)
        rightView.addGestureRecognizer(swipeUpRightViewRecognizer)
        rightView.addGestureRecognizer(swipeDownRightViewRecognizer)
        
        newLevel()
        
    }
    
    func swipeRightLeftView(swipe:UISwipeGestureRecognizer) {
        println("Swipe Right Left View")
    }
    func swipeLeftLeftView(swipe:UISwipeGestureRecognizer) {
        println("Swipe Left Left View")
    }
    func swipeUpLeftView(swipe:UISwipeGestureRecognizer) {
        println("Swipe Up Left View")
    }
    func swipeDownLeftView(swipe:UISwipeGestureRecognizer) {
        println("Swipe Down Left View")
    }
    
    func swipeRightRightView(swipe:UISwipeGestureRecognizer) {
        println("Swipe Right Right View")
    }
    func swipeLeftRightView(swipe:UISwipeGestureRecognizer) {
        println("Swipe Left Right View")
    }
    func swipeUpRightView(swipe:UISwipeGestureRecognizer) {
        println("Swipe Up Right View")
    }
    func swipeDownRightView(swipe:UISwipeGestureRecognizer) {
        println("Swipe Down Right View")
    }
    
    func addArrow(side:Int){
        let randomDir: Direction = Direction(rawValue: arc4random_uniform(Direction.LEFT.rawValue))!
        let newArrow = Arrow(direction: randomDir, imageNamed: "up-Arrow")

        if(randomDir == Direction.UP){
            newArrow.zRotation += 0
        } else if(randomDir == Direction.DOWN){
            newArrow.zRotation += CGFloat(M_PI/2)
        } else if(randomDir == Direction.RIGHT){
            newArrow.zRotation += CGFloat(M_PI)
        } else {
            newArrow.zRotation += CGFloat(3*M_PI/2)
        }
        
        if(side == 0){
            newArrow.position = CGPointMake(size.width/4, size.height+newArrow.size.height)
            arrowQueue[LEFT].push(newArrow)
        } else {
            newArrow.position = CGPointMake(3*size.width/4, size.height+newArrow.size.height)
            arrowQueue[RIGHT].push(newArrow)
        }
        let actionMove = SKAction.moveTo(CGPoint(x: newArrow.position.x, y: -size.height), duration: 5.0)
        newArrow.runAction(actionMove)
        
        
        self.addChild(newArrow)
        
    }
    
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
    }
    
    func newLevel(){
        var wait = SKAction.waitForDuration(arrowSpeed)
        var run = SKAction.runBlock {
            var randGeneration = arc4random_uniform(3)
            switch(randGeneration){
            case 0:
                self.addArrow(LEFT)
                break
            case 1:
                self.addArrow(RIGHT)
                break
            default:
                self.addArrow(LEFT)
                self.addArrow(RIGHT)
                break
            }
        }
        self.runAction(SKAction.repeatAction((SKAction.sequence([wait, run])), count: 15))
    }
    
//    func validateSwipe(side:Side, direction:Direction)
//    {
//        
//    }
    
}
