//
//  GameScene.swift
//  Swipe Hero
//
//  Created by Caio Vinícius Piologo Véras Fernandes on 6/17/15.
//  Copyright (c) 2015 Caio. All rights reserved.
//

import SpriteKit
import CoreGraphics

let LEFT = 0
let RIGHT = 1
let HIGHSCOREKEY = "HighScoreKey"

struct PhysicsCategory {
    static let arrow:UInt32 = 0b1 //1
    static let dangerZone:UInt32 = 0b10 //2
    static let endZone:UInt32 = 0b100 //4
    static let world:UInt32 = 0b1000 //8
}

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    //variables
    var arrowQueue:Array<Queue<Arrow>> = [Queue<Arrow>(),Queue<Arrow>()]
    var arrowSpeed:NSTimeInterval = 2.0
    var scoreLabel:SKLabelNode?;
    var highScoreLabel:SKLabelNode?;
    var levelLabel:SKLabelNode?
    var endZone:SKSpriteNode?
    var dangerZone:SKSpriteNode?
    var score:Int = 0;
    var level:Int = 0;
    var difficulty:Float = 0;
    var highScore = 0;
    var userDefaults:NSUserDefaults = NSUserDefaults.standardUserDefaults()
    
    var scoreAction : SKAction!
    var missAction : SKAction!
    
    override func didMoveToView(view: SKView) {
        /* Setup your scene here */
        //get high score from user defaults
        self.highScore = userDefaults.integerForKey(HIGHSCOREKEY)
        NSLog("\(highScore)");
        
        //initialize labels
        self.physicsWorld.gravity = CGVector(dx: 0, dy: 0)
        self.physicsWorld.contactDelegate = self
        self.scoreLabel = self.childNodeWithName("scorelabel") as? SKLabelNode
        self.highScoreLabel = self.childNodeWithName("highScoreLabel") as? SKLabelNode
        self.levelLabel = self.childNodeWithName("levelLabel") as? SKLabelNode
        self.dangerZone = self.childNodeWithName("dangerZone") as? SKSpriteNode
        self.endZone = self.childNodeWithName("endZone") as? SKSpriteNode

        
        //define collision bitmasks
        self.dangerZone!.physicsBody = SKPhysicsBody(rectangleOfSize: dangerZone!.size)
        self.endZone!.physicsBody = SKPhysicsBody(rectangleOfSize: endZone!.size)
        self.dangerZone!.physicsBody!.categoryBitMask = PhysicsCategory.dangerZone
        self.dangerZone!.physicsBody!.contactTestBitMask = PhysicsCategory.arrow
        self.dangerZone!.physicsBody!.collisionBitMask = 0
        self.endZone!.physicsBody!.categoryBitMask = PhysicsCategory.endZone
        self.endZone!.physicsBody!.contactTestBitMask = PhysicsCategory.arrow
        self.endZone!.physicsBody!.collisionBitMask = 0
        
        /*Right and Left Views, zones that recognize each gesture*/
        var leftView = UIView(frame: CGRectMake(0, 0, UIScreen.mainScreen().bounds.size.width/2, UIScreen.mainScreen().bounds.size.height))
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
        
        
        self.scoreAction = SKAction.group([
            SKAction.sequence([
                SKAction.scaleTo(2.0, duration: 0.2),
                SKAction.scaleTo(1.0, duration: 0.2)
            
            ]),
            
            SKAction.sequence([
                
                SKAction.colorizeWithColor(SKColor.orangeColor(), colorBlendFactor: 1.0, duration: 0.2),
                
                SKAction.runBlock(){
                    self.scoreLabel?.color = SKColor.blackColor()
                }
                
            ])
            
        ])
        
        self.missAction = SKAction.sequence([
            
            SKAction.colorizeWithColor(SKColor.redColor(), colorBlendFactor: 1.0, duration: 0.2),
            
            //SKAction.colorizeWithColorBlendFactor(0.0, duration: 0.1)
            SKAction.colorizeWithColor(SKColor(red: 1, green: 240/255, blue: 216/255, alpha: 1), colorBlendFactor: 0.0, duration: 0.1)
            
        ])
        //start the game
        self.restart(1)
    }
    
    //Restart with initial level
    func restart(level:Int)
    {
        self.score = 0
        self.level = level
        self.difficulty = Float(level)
        updateLabels()
        //do somethign else
        startGame()
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
        addScore()
        addScore()
        addScore()
        
        self.addChild(newArrow)
        
    }
    
    func addScore(){
        //TODO: ajustar dificuldade para dispositivo
        self.score++
        if(score % 15 == 0){
            level++
            if(level >= 5){
                difficulty += Float(2/Float(self.level))
                arrowSpeed -= NSTimeInterval(1/Float(self.level))
            } else {
                difficulty = Float(level)
            }
            if(difficulty >= 15){
                difficulty = 15
            }
            if(arrowSpeed <= 0.5){
                arrowSpeed = 0.5
            }
            self.removeAllActions()
            var block = SKAction.runBlock{
                self.startGame()
            }
            self.runAction(block)
        }
        
        if(score > highScore){
            changeHighScore(score)
        }
        
        updateLabels()
        scoreLabel?.runAction(scoreAction)
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
        self.runAction(missAction)
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
        for i in 0 ... self.arrowQueue[LEFT].length {
            self.arrowQueue[LEFT].getPosition(i)?.update(CGFloat(self.difficulty/100) + CGFloat(0.05))
        }
        for i in 0 ... self.arrowQueue[RIGHT].length {
            self.arrowQueue[RIGHT].getPosition(i)?.update(CGFloat(self.difficulty/100) + CGFloat(0.05))
        }
    }
    
    func didBeginContact(contact: SKPhysicsContact)
    {
       // NSLog("paiseh");
        let collision = contact.bodyA.categoryBitMask | contact.bodyB.categoryBitMask
        if(collision == (PhysicsCategory.arrow | PhysicsCategory.dangerZone))
        {
            //play danger animation
           // NSLog("COSTOOOOO");
        }else if(collision == (PhysicsCategory.arrow | PhysicsCategory.endZone))
        {
            //end game
          //  NSLog("Perdeu playboy!");
        }
    }
    
    func didEndContact(contact: SKPhysicsContact) {
        let collision = contact.bodyA.categoryBitMask|contact.bodyB.categoryBitMask
        if(collision == (PhysicsCategory.arrow | PhysicsCategory.dangerZone))
        {
            //stop danger animation
        }
    }
    
    func startGame(){
        var wait = SKAction.waitForDuration(arrowSpeed)
        var run = SKAction.runBlock {
            var randGeneration = arc4random_uniform(UInt32(self.difficulty))
            
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
        self.runAction(SKAction.repeatActionForever(SKAction.sequence([wait, run])))
    }
}
