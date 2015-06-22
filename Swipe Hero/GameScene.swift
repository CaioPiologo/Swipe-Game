//
//  GameScene.swift
//  Swipe Hero
//
//  Created by Caio Vinícius Piologo Véras Fernandes on 6/17/15.
//  Copyright (c) 2015 Caio. All rights reserved.
//

import SpriteKit
import CoreGraphics
import AVFoundation

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
    var arrowSpeed:NSTimeInterval = 1.0
    var leftView: UIView!
    var rightView: UIView!
    var arrowParent : SKSpriteNode!
    var swipeLabel: SKSpriteNode?
    var heroLabel: SKSpriteNode?
    var scoreText: SKLabelNode?
    var highScoreText: SKLabelNode?
    var levelText: SKLabelNode?
    var scoreLabel:SKLabelNode?
    var highScoreLabel:SKLabelNode?
    var levelLabel:SKLabelNode?
    var endZone:SKSpriteNode?
    var dangerZone:SKSpriteNode?
    var arrowInDangerZone:Int = 0
    var leftBulb : SKSpriteNode?
    var rightBulb : SKSpriteNode?
    var leftLight : SKSpriteNode?
    var rightLight : SKSpriteNode?
    var startButton: SKSpriteNode?
    var score:Int = 0;
    var level:Int = 0;
    var difficulty:Float = 0;
    var highScore = 0;
    var userDefaults:NSUserDefaults = NSUserDefaults.standardUserDefaults()
    var bgMusicPlayer:AVAudioPlayer?
    
    var scoreAction : SKAction!
    var dangerActionLeft : SKAction!
    var dangerActionRight : SKAction!
//    var missAction : SKAction!
    
    override func didMoveToView(view: SKView) {
            
        /* Setup your scene here */
        
        self.leftBulb = self.childNodeWithName("leftBulb") as? SKSpriteNode
        self.leftBulb?.zPosition = -1
        self.rightBulb = self.childNodeWithName("rightBulb") as? SKSpriteNode
        self.rightBulb?.zPosition = -1
        
        self.leftLight = self.childNodeWithName("leftLight") as? SKSpriteNode
        self.leftLight?.texture = nil
        self.leftLight?.zPosition = 0
        
        self.rightLight = self.childNodeWithName("rightLight") as? SKSpriteNode
        self.rightLight?.texture = nil
        self.rightLight?.zPosition = 0
        
        self.arrowParent = SKSpriteNode(color: SKColor.clearColor(), size: self.size)
        self.arrowParent.anchorPoint.x = -self.size.width/2
        self.arrowParent.anchorPoint.y = -self.size.height/2
        self.arrowParent.position = self.position
        self.addChild(arrowParent)

        //get high score from user defaults
        self.highScore = userDefaults.integerForKey(HIGHSCOREKEY)
        
        //initialize labels
        self.physicsWorld.gravity = CGVector(dx: 0, dy: 0)
        self.physicsWorld.contactDelegate = self
        self.swipeLabel = self.childNodeWithName("swipeLabel") as? SKSpriteNode
        self.heroLabel = self.childNodeWithName("heroLabel") as? SKSpriteNode
        self.scoreText = self.childNodeWithName("scoreText") as? SKLabelNode
        self.scoreText?.hidden = true
        self.levelText = self.childNodeWithName("levelText") as? SKLabelNode
        self.levelText?.hidden = true
        self.highScoreText = self.childNodeWithName("highScoreText") as? SKLabelNode
        self.highScoreText?.hidden = true
        self.scoreLabel = self.childNodeWithName("scorelabel") as? SKLabelNode
        self.scoreLabel?.hidden = true
        self.highScoreLabel = self.childNodeWithName("highScoreLabel") as? SKLabelNode
        self.highScoreLabel?.hidden = true
        self.levelLabel = self.childNodeWithName("levelLabel") as? SKLabelNode
        self.levelLabel?.hidden = true
        self.dangerZone = self.childNodeWithName("dangerZone") as? SKSpriteNode
        self.endZone = self.childNodeWithName("endZone") as? SKSpriteNode
        self.startButton = self.childNodeWithName("playButton") as? SKSpriteNode
        
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
        leftView = UIView(frame: CGRectMake(0, 0, UIScreen.mainScreen().bounds.size.width/2, UIScreen.mainScreen().bounds.size.height))
        leftView.backgroundColor = UIColor.clearColor()
        leftView.hidden = true
        
        rightView = UIView(frame: CGRectMake(UIScreen.mainScreen().bounds.size.width/2, 0, UIScreen.mainScreen().bounds.size.width/2, UIScreen.mainScreen().bounds.size.height))
        rightView.backgroundColor = UIColor.clearColor()
        rightView.hidden = true
        
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
        let touchButtonRecognizer: UIGestureRecognizer = UIGestureRecognizer(target: self, action: "playButton")
        
        swipeRightRightViewRecognizer.direction = .Right
        swipeLeftRightViewRecognizer.direction = .Left
        swipeUpRightViewRecognizer.direction = .Up
        swipeDownRightViewRecognizer.direction = .Down
        
        rightView.addGestureRecognizer(swipeRightRightViewRecognizer)
        rightView.addGestureRecognizer(swipeLeftRightViewRecognizer)
        rightView.addGestureRecognizer(swipeUpRightViewRecognizer)
        rightView.addGestureRecognizer(swipeDownRightViewRecognizer)
        
        self.scoreAction = SKAction.group([
            SKAction.playSoundFileNamed("swipe.wav", waitForCompletion: false),
            
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
        
        self.dangerActionLeft = SKAction.repeatActionForever(SKAction.rotateByAngle(4.34, duration: 1.0))
        self.dangerActionRight = SKAction.repeatActionForever(SKAction.rotateByAngle(-4.34, duration: 1.0))
        
        //start danger zone animations
        self.startDangerZoneAnimation()
        
        //begin background music
        self.playBackgroundMusic()
    }
    
    //Restart with initial level
    func restart(level:Int)
    {
        self.score = 0
        self.level = level
        self.difficulty = Float(level)
        updateLabels()
        self.arrowSpeed = 1.0
        self.arrowInDangerZone = 0;
        self.removeAllActions()
        //begin background music
        self.playBackgroundMusic()
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
    
    //Start game function
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        for touch: AnyObject in touches {
            // Get the location of the touch in this scene
            let location = touch.locationInNode(self)
            let node = self.nodeAtPoint(location)
            // Check if the location of the touch is within the button's bounds
            if node.name == "playButton" {
                self.startButton?.texture = SKTexture(imageNamed: "button_play_pressed_pixelated")
            }
        }
    }
    override func touchesEnded(touches: Set<NSObject>, withEvent event: UIEvent) {
        for touch: AnyObject in touches {
            // Get the location of the touch in this scene
            let location = touch.locationInNode(self)
            let node = self.nodeAtPoint(location)
            // Check if the location of the touch is within the button's bounds
            if node.name == "playButton" {
                self.startButton?.removeFromParent()
                self.restart(1);
                self.startLevel()
                self.scoreLabel?.hidden = false
                self.highScoreLabel?.hidden = false
                self.levelLabel?.hidden = false
                self.leftView.hidden = false
                self.rightView.hidden = false
                self.scoreText?.hidden = false
                self.levelText?.hidden = false
                self.highScoreText?.hidden = false
                self.swipeLabel?.hidden = true
                self.heroLabel?.hidden = true
                
                self.leftLight?.texture = nil
                self.leftLight?.removeActionForKey("dangerAction")
                self.rightLight?.texture = nil
                self.rightLight?.removeActionForKey("dangerAction")
                self.leftBulb?.texture = SKTexture(imageNamed: "bulb_off")
                self.leftBulb?.removeActionForKey("dangerAction")
                self.rightBulb?.texture = SKTexture(imageNamed: "bulb_off")
                self.rightBulb?.removeActionForKey("dangerAction")
            } else {
                self.startButton?.texture = SKTexture(imageNamed: "button_play_pixelated")
            }
        }
    }
    
    //Function that creates and adds arrows to the scene
    func addArrow(side:Int){
        let arrowType = arc4random_uniform(5)
        let randomDir = Direction(rawValue: arc4random_uniform(Direction.LEFT.rawValue + 1))!
        let newArrow:Arrow
        //defines arrow type
        if(arrowType == 0){
            newArrow = Arrow(direction: randomDir, type:LEFT, imageNamed: "arrow_wrong_pixelated")
            newArrow.color = UIColor.redColor()
        } else {
            newArrow = Arrow(direction: randomDir, type:RIGHT, imageNamed: "arrow_pixelated")
            newArrow.color = UIColor.blueColor()
        }
        newArrow.colorBlendFactor = 1
        //rotates arrow depending on its direction
        if(randomDir == Direction.UP){
            newArrow.zRotation += CGFloat(3*M_PI/2)
        } else if(randomDir == Direction.LEFT){
            newArrow.zRotation += 0
        } else if(randomDir == Direction.DOWN){
            newArrow.zRotation += CGFloat(M_PI/2)
        } else {
            newArrow.zRotation += CGFloat(M_PI)
        }
        //chooses which side to generate the arrow
        if(side == 0){
            newArrow.position = CGPointMake(size.width/4, size.height+newArrow.size.height)
            arrowQueue[LEFT].push(newArrow)
        } else {
            newArrow.position = CGPointMake(3*size.width/4, size.height+newArrow.size.height)
            arrowQueue[RIGHT].push(newArrow)
        }
        //sets its collision properties
        newArrow.physicsBody = SKPhysicsBody(rectangleOfSize: newArrow.size)
        newArrow.physicsBody?.dynamic = true
        newArrow.physicsBody?.categoryBitMask = PhysicsCategory.arrow
        newArrow.physicsBody?.contactTestBitMask = PhysicsCategory.dangerZone | PhysicsCategory.endZone
        newArrow.physicsBody?.collisionBitMask = 0        
        self.arrowParent.addChild(newArrow)
    }
    //Function that increases score and level through progress
    func addScore(){
        //TODO: ajustar dificuldade para dispositivo
        self.score++
        if(score % 15 == 0){
            level++
            if(level >= 5){
                difficulty += Float(1/Float(self.level))
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
                self.startLevel()
            }
            self.runAction(block)
        }
        
        if(score > highScore){
            changeHighScore(score)
        }
        
        updateLabels()
        scoreLabel?.runAction(scoreAction)
    }
    
    func missAction(){
        let initialX = self.arrowParent.position.x
        let initialY = self.arrowParent.position.y
        let amplitudeX = 32
        let amplitudeY = 2
        var newX : CGFloat
        var newY : CGFloat
        var randomActions : [SKAction] = []
        var i = 0
        
        randomActions.append(SKAction.playSoundFileNamed("swipe2.wav", waitForCompletion: false) )
        
        for i in 0..<10 {
            let newX = initialX + CGFloat(arc4random_uniform(UInt32(amplitudeX))) - CGFloat(amplitudeX / 2)
            let newY = initialY + CGFloat(arc4random_uniform(UInt32(amplitudeY))) - CGFloat(amplitudeY / 2)
            randomActions.append(SKAction.moveTo(CGPointMake(newX, newY), duration: 0.015))
        }
        
        var rep = SKAction.sequence(randomActions)
        
        self.arrowParent.runAction(rep)
    }
    
    //Function checks the swipe and the first arrow from the side queue direction
    func validateSwipe(side: Int, direction: Direction){
        
        var arrow : Arrow?
        var currentQueue : Int
        var comparingDir = direction
        /*Get first arrow from queue*/
        if(side == LEFT){
            arrow = arrowQueue[LEFT].getPosition(0)
            currentQueue = LEFT
        }else{
            arrow = arrowQueue[RIGHT].getPosition(0)
            currentQueue = RIGHT
        }
        /*Check swipe's direction*/
        if(arrow != nil){
            /*Checks arrow type and convert the direction to match*/
            if(arrow!.type == LEFT){
                if(direction == .UP){
                    comparingDir = Direction.DOWN
                } else if(direction == .RIGHT){
                    comparingDir = Direction.LEFT
                } else if(direction == Direction.DOWN){
                    comparingDir = Direction.UP
                } else if(direction == Direction.LEFT){
                    comparingDir = Direction.RIGHT
                }
            }
            if(arrow!.direction.rawValue == comparingDir.rawValue){
                if(CGRectIntersectsRect(arrow!.frame, dangerZone!.frame)){
                    arrowInDangerZone--
                    if(arrowInDangerZone == 0){
                        leftBulb?.texture = SKTexture(imageNamed: "bulb_off")
                        leftBulb?.removeActionForKey("dangerAction")
                        leftLight?.texture = nil
                        leftLight?.removeActionForKey("dangerAction")
                        rightBulb?.texture = SKTexture(imageNamed: "bulb_off")
                        rightBulb?.removeActionForKey("dangerAction")
                        rightLight?.texture = nil
                        rightLight?.removeActionForKey("dangerAction")
                    }
                }
                arrow = arrowQueue[currentQueue].pop()
                arrow!.runAction(SKAction.removeFromParent())
                addScore()
            }else{
                self.missAction()
                //TODO: Wrong direction alert
            }
        }else{
            self.missAction()
        }
    }
    
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
        for i in 0 ... self.arrowQueue[LEFT].length {
            self.arrowQueue[LEFT].getPosition(i)?.update(CGFloat(self.difficulty/100) + CGFloat(0.05), queue:arrowQueue[LEFT])
        }
        for i in 0 ... self.arrowQueue[RIGHT].length {
            self.arrowQueue[RIGHT].getPosition(i)?.update(CGFloat(self.difficulty/100) + CGFloat(0.05), queue:arrowQueue[RIGHT])
        }
    }
    
    func arrowDidCollideWithEndZone(){
        self.removeAllActions()
        for i in 0 ... self.arrowQueue[LEFT].length {
            var arrow = self.arrowQueue[LEFT].pop()
            if(arrow != nil){
                explosion(arrow!.position, color: arrow!.type)
                arrow!.removeFromParent()
            }
        }
        for i in 0 ... self.arrowQueue[RIGHT].length {
            var arrow = self.arrowQueue[RIGHT].pop()
            if(arrow != nil){
                explosion(arrow!.position, color: arrow!.type)
                arrow!.removeFromParent()
            }
        }
        arrowQueue[LEFT].emptyQueue()
        arrowQueue[RIGHT].emptyQueue()
        endGame()
    }
    
    func arrowDidCollideWithDangetZone(){
        arrowInDangerZone++
        
        if(arrowInDangerZone == 1){
            self.runAction(SKAction.playSoundFileNamed("dangerZone.wav", waitForCompletion: false))
        }
        
        leftBulb?.texture = SKTexture(imageNamed: "bulb_on")
        leftBulb?.runAction(dangerActionLeft, withKey: "dangerAction")
        leftLight?.texture = SKTexture(imageNamed: "lights")
        leftLight?.runAction(dangerActionLeft, withKey: "dangerAction")
        rightBulb?.texture = SKTexture(imageNamed: "bulb_on")
        rightBulb?.runAction(dangerActionRight, withKey: "dangerAction")
        rightLight?.texture = SKTexture(imageNamed: "lights")
        rightLight?.runAction(dangerActionRight, withKey: "dangerAction")
        
    }
    
    func arrowDidEndContactWithDangerZone(){
        
    }
    
    func didBeginContact(contact: SKPhysicsContact)
    {
        var arrow: SKPhysicsBody
        var secondBody: SKPhysicsBody
        if contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask {
            arrow = contact.bodyA
            secondBody = contact.bodyB
        } else {
            arrow = contact.bodyB
            secondBody = contact.bodyA
        }
       // NSLog("paiseh");
        let collision = arrow.categoryBitMask | secondBody.categoryBitMask
        if(collision == (PhysicsCategory.arrow | PhysicsCategory.dangerZone))
        {
            arrowDidCollideWithDangetZone()
            //play danger animation
           // NSLog("COSTOOOOO");
        }else if(collision == (PhysicsCategory.arrow | PhysicsCategory.endZone))
        {
            //end game
            arrowDidCollideWithEndZone()
            //TODO: end game animation + end game view
        }
    }
    
    func didEndContact(contact: SKPhysicsContact) {
        let collision = contact.bodyA.categoryBitMask|contact.bodyB.categoryBitMask
        if(collision == (PhysicsCategory.arrow | PhysicsCategory.dangerZone))
        {
            arrowDidEndContactWithDangerZone()
            //stop danger animation
        }
    }
    //Function called with each level or new game
    func startLevel(){
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
    //Function that explodes the arrows
    func explosion(pos: CGPoint, color:Int) {
        var emitterNode = SKEmitterNode(fileNamed: "ExplosionParticle.sks")
        emitterNode.particlePosition = pos
        if(color == LEFT){
            emitterNode.particleColor = UIColor.redColor()
        } else {
            emitterNode.particleColor = UIColor.blueColor()
        }
        emitterNode.particleColorBlendFactor = 1.0
        emitterNode.particleColorSequence = nil
        self.addChild(emitterNode)
        self.runAction(SKAction.waitForDuration(2), completion: { emitterNode.removeFromParent() })
        self.runAction(SKAction.playSoundFileNamed("explosion.wav", waitForCompletion: false))
    }
    
    func endGame(){
        self.startButton?.removeFromParent()
        self.addChild(self.startButton!)
        self.startButton?.texture = SKTexture(imageNamed: "button_play_pixelated")
        //self.scoreLabel?.hidden = true
        self.levelLabel?.hidden = true
        self.leftView.hidden = true
        self.rightView.hidden = true
        //self.scoreText?.hidden = true
        self.levelText?.hidden = true
        self.highScoreText?.hidden = false
        self.swipeLabel?.hidden = false
        self.heroLabel?.hidden = false
    }
    
    func startDangerZoneAnimation()
    {
        leftBulb?.texture = SKTexture(imageNamed: "bulb_on")
        leftBulb?.runAction(dangerActionLeft, withKey: "dangerAction")
        leftLight?.texture = SKTexture(imageNamed: "lights")
        leftLight?.runAction(dangerActionLeft, withKey: "dangerAction")
        rightBulb?.texture = SKTexture(imageNamed: "bulb_on")
        rightBulb?.runAction(dangerActionRight, withKey: "dangerAction")
        rightLight?.texture = SKTexture(imageNamed: "lights")
        rightLight?.runAction(dangerActionRight, withKey: "dangerAction")
    }
    
    
    func playBackgroundMusic()
    {
        if(self.bgMusicPlayer == nil)
        {
            var url:NSURL = NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("Rhinoceros", ofType: "mp3")!)!
            var erro:NSError? = nil
            bgMusicPlayer = AVAudioPlayer(contentsOfURL: url, error: &erro)
            bgMusicPlayer?.numberOfLoops = -1;
            bgMusicPlayer?.prepareToPlay()
        }
        bgMusicPlayer?.pause()
        bgMusicPlayer?.currentTime = 0;
        bgMusicPlayer?.play()
    }
    
    func stopBackgroundMusic()
    {
        bgMusicPlayer?.pause()
    }
    

}
