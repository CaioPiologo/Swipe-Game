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
let HIGHSCOREKEY = "HighScoreKey"

struct PhysicsCategory {
    static let arrow:UInt32 = 0b1 //1
    static let dangerZone:UInt32 = 0b10 //2
    static let endZone:UInt32 = 0b100 //4
}

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    //variables
    var arrowQueue:Array<Queue<Arrow>> = [Queue<Arrow>(),Queue<Arrow>()]
    var arrowSpeed:NSTimeInterval = 1.0
    var scoreLabel:SKLabelNode?;
    var highScoreLabel:SKLabelNode?;
    var levelLabel:SKLabelNode?
    var endZone:SKSpriteNode?
    var dangerZone:SKSpriteNode?
    var score:Int = 0;
    var level:Int = 0;
    var highScore = 0;
    var userDefaults:NSUserDefaults = NSUserDefaults.standardUserDefaults()
    
    override func didMoveToView(view: SKView) {
        /* Setup your scene here */
        //self.size = UIScreen.mainScreen().bounds.size
        
        //get high score from user defaults
        self.highScore = userDefaults.integerForKey(HIGHSCOREKEY)
        NSLog("\(highScore)");
        
        //initialize labels
        self.scoreLabel = self.childNodeWithName("scorelabel") as? SKLabelNode
        self.highScoreLabel = self.childNodeWithName("highScoreLabel") as? SKLabelNode
        self.levelLabel = self.childNodeWithName("levelLabel") as? SKLabelNode
        
        //initilize SKSpriteNode Objects
        self.dangerZone = self.childNodeWithName("dangerZone") as? SKSpriteNode
        self.endZone = self.childNodeWithName("endZone") as? SKSpriteNode
        
        //define collision bitmasks
        self.dangerZone!.physicsBody!.collisionBitMask = PhysicsCategory.dangerZone
        self.endZone!.physicsBody!.collisionBitMask = PhysicsCategory.endZone
        
        /*Right and Left Views, zones that recognize each gesture*/
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
        
        //set collision
        
        
        //start the game
        self.restart(1)
    }
    
    //Restart with initial level
    func restart(level:Int)
    {
        self.score = 0
        self.level = level
        updateLabels()
        //do somethign else
    }
    
    func updateLabels()
    {
        self.scoreLabel!.text = "\(self.score)"
        self.highScoreLabel!.text = "\(self.highScore)"
        self.levelLabel!.text = "\(self.level)"
    }
    
    func changeHighScore(newScore:Int)
    {
        userDefaults.setInteger(newScore, forKey: HIGHSCOREKEY)
        self.highScore = newScore
    }
    
    //Swipe Functions
    func swipeRightLeftView(swipe:UISwipeGestureRecognizer) {
        println("Swipe Right Left View")
        validateSwipe(LEFT, direction: Direction.RIGHT)
    }
    func swipeLeftLeftView(swipe:UISwipeGestureRecognizer) {
        println("Swipe Left Left View")
        validateSwipe(LEFT, direction: Direction.LEFT)
    }
    func swipeUpLeftView(swipe:UISwipeGestureRecognizer) {
        println("Swipe Up Left View")
        validateSwipe(LEFT, direction: Direction.UP)
    }
    func swipeDownLeftView(swipe:UISwipeGestureRecognizer) {
        println("Swipe Down Left View")
        validateSwipe(LEFT, direction: Direction.DOWN)
    }
    
    func swipeRightRightView(swipe:UISwipeGestureRecognizer) {
        println("Swipe Right Right View")
        validateSwipe(RIGHT, direction: Direction.RIGHT)
    }
    func swipeLeftRightView(swipe:UISwipeGestureRecognizer) {
        println("Swipe Left Right View")
        validateSwipe(RIGHT, direction: Direction.LEFT)
    }
    func swipeUpRightView(swipe:UISwipeGestureRecognizer) {
        println("Swipe Up Right View")
        validateSwipe(RIGHT, direction: Direction.UP)
    }
    func swipeDownRightView(swipe:UISwipeGestureRecognizer) {
        println("Swipe Down Right View")
        validateSwipe(RIGHT, direction: Direction.DOWN)
    }
    
    func addArrow(side:Int){
        let randomDir: Direction = Direction(rawValue: arc4random_uniform(Direction.LEFT.rawValue))!
        let randomSpeed = NSTimeInterval(5 + arc4random_uniform(2))
        let newArrow = Arrow(direction: randomDir, imageNamed: "up-Arrow")
        //rotates arrow depending on its direction
        if(randomDir == Direction.UP){
            newArrow.zRotation += 0
        } else if(randomDir == Direction.DOWN){
            newArrow.zRotation += CGFloat(M_PI/2)
        } else if(randomDir == Direction.RIGHT){
            newArrow.zRotation += CGFloat(M_PI)
        } else {
            newArrow.zRotation += CGFloat(3*M_PI/2)
        }
        //chooses which side to generate the arrow
        if(side == 0){
            newArrow.position = CGPointMake(size.width/4, size.height+newArrow.size.height)
            arrowQueue[LEFT].push(newArrow)
        } else {
            newArrow.position = CGPointMake(3*size.width/4, size.height+newArrow.size.height)
            arrowQueue[RIGHT].push(newArrow)
        }
        let actionMove = SKAction.moveTo(CGPoint(x: newArrow.position.x, y: -size.height), duration: randomSpeed)
        newArrow.runAction(actionMove)
        
        self.addChild(newArrow)
        
    }
    
    func addScore(){
        self.score++
        
        if(score % 15 == 0){
            level++
        }
        
        if(score > highScore){
            changeHighScore(score)
        }
        
        updateLabels()
    }
    
    func validateSwipe(side: Int, direction: Direction){
        
        var arrow : Arrow?
        var currentQueue : Int
        
        /*Get first arrow from queue*/
        if(side == LEFT){
            arrow = arrowQueue[LEFT].getPosition(0)
            currentQueue = LEFT
        }else{
            arrow = arrowQueue[RIGHT].getPosition(0)
            currentQueue = RIGHT
        }
addScore()
        /*Check swipe's direction*/
        if(arrow != nil){
            if(arrow!.direction == direction){
                arrowQueue[currentQueue].pop()
                addScore()
            }else{
                //TODO: Wrong direction alert
            }
        }
    }
    
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
    }
    
    func didBeginContact(contact: SKPhysicsContact)
    {
        let collision = contact.bodyA.collisionBitMask|contact.bodyB.collisionBitMask;
        if(collision == (PhysicsCategory.arrow | PhysicsCategory.dangerZone))
        {
            //play danger animation
        }else if(collision == (PhysicsCategory.arrow | PhysicsCategory.endZone))
        {
            NSLog("Perdeu playboy!");
        }
    }
    
    func didEndContact(contact: SKPhysicsContact) {
        let collision = contact.bodyA.collisionBitMask|contact.bodyB.collisionBitMask;
        if(collision == (PhysicsCategory.arrow | PhysicsCategory.dangerZone))
        {
            //stop danger animation
        }
    }
    
    func newLevel(){
        //TODO: atualizar arrowSpeed em função dos leveis
        var wait = SKAction.waitForDuration(arrowSpeed)
        var run = SKAction.runBlock {
            var randGeneration = arc4random_uniform(3)
//            var randGeneration = 2
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
}
