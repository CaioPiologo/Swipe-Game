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
import GameKit

let LEFT = 0
let RIGHT = 1
let HIGHSCOREKEY = "HighScoreKey"

struct PhysicsCategory {
    static let arrow:UInt32 = 0b1 //1
    static let dangerZone:UInt32 = 0b10 //2
    static let endZone:UInt32 = 0b100 //4
    static let world:UInt32 = 0b1000 //8
}

class GameScene: SKScene, SKPhysicsContactDelegate, GKGameCenterControllerDelegate, GameCenterHelperProtocol {
    
    //variables
    var arrowQueue:Array<Queue<Arrow>> = [Queue<Arrow>(),Queue<Arrow>()]
    var tutorialArrow:Arrow?
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
    var comboLabel:SKLabelNode?
    var highScoreLabel:SKLabelNode?
    var levelLabel:SKLabelNode?
    var tutorialLabel1:SKLabelNode?
    var tutorialLabel2:SKLabelNode?
    var highlight:SKSpriteNode?
    var endZone:SKSpriteNode?
    var dangerZone:SKSpriteNode?
    var arrowInDangerZone:Int = 0
    var leftBulb : SKSpriteNode?
    var rightBulb : SKSpriteNode?
    var leftLight : SKSpriteNode?
    var rightLight : SKSpriteNode?
    var startButton: SKSpriteNode?
    var gameCenterButton : SKSpriteNode!
    var gameCenterIcon : SKSpriteNode!
    var score:Int = 0
    var level:Int = 0
    var difficulty:Float = 0
    var highScore = 0
    var firstTime:Int = 0
    var userDefaults:NSUserDefaults = NSUserDefaults.standardUserDefaults()
    var bgMusicPlayer:AVAudioPlayer?
    var menuMusicPlayer:AVAudioPlayer?
    var leftDoor:SKSpriteNode?
    var rightDoor:SKSpriteNode?
    var middleDoor:SKNode?
    var middleLeftDoor:SKSpriteNode?
    var middleRightDoor:SKSpriteNode?
    var menu:SKSpriteNode?
    var comboCounter:Int = 0;
    var comboTop:SKEmitterNode?
    var comboLeft:SKEmitterNode?
    var comboBot:SKEmitterNode?
    var comboRight:SKEmitterNode?
    var scoreAction : SKAction!
    var dangerActionLeft : SKAction!
    var dangerActionRight : SKAction!
    var openDoorAction : SKAction!
    var closeDoorAction : SKAction!
    var inTutorial = 0
    var inMenu = false
    var inGame = false
    var pause = false
    var animatingMenu = false
    var pauseButton : SKSpriteNode!
    var bgImage : SKSpriteNode!
    var soundOn = true
    
    var pauseEnable = true
    var endGameMenu : EndGameMenu!
    var pauseMenu : PauseMenu!
    var settingsMenu : SettingsMenu!
    var credits : Credits!
    var gameCenter: GameCenterHelper!
    
    override func didMoveToView(view: SKView) {
        
        /* Setup your scene here */
//        GameViewController().authenticateLocalPlayer()
        gameCenter = GameCenterHelper(VC: GameViewController())
        gameCenter.delegate = self
        gameCenter.authenticateLocalPlayer()
        
        self.leftBulb = self.childNodeWithName("leftBulb") as? SKSpriteNode
        self.leftBulb?.zPosition = -3
        self.rightBulb = self.childNodeWithName("rightBulb") as? SKSpriteNode
        self.rightBulb?.zPosition = -3
        
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
        self.arrowParent.size = CGSize(width: 1, height: 1)
        self.addChild(arrowParent)
        
        //get high score from user defaults
        self.firstTime = userDefaults.integerForKey("firstTime")
        self.highScore = userDefaults.integerForKey(HIGHSCOREKEY)
        self.firstTime = userDefaults.integerForKey("firstTime")
        if(self.firstTime==0)
        {
            self.userDefaults.setBool(true, forKey: "soundOn")
        }
        self.soundOn = userDefaults.boolForKey("soundOn")
        
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
        self.comboLabel = self.childNodeWithName("comboLabel") as? SKLabelNode
        self.comboLabel?.hidden = true
        self.scoreLabel = self.childNodeWithName("scorelabel") as? SKLabelNode
        self.scoreLabel?.hidden = true
        self.highScoreLabel = self.childNodeWithName("highScoreLabel") as? SKLabelNode
        self.highScoreLabel?.hidden = true
        self.levelLabel = self.childNodeWithName("levelLabel") as? SKLabelNode
        self.levelLabel?.hidden = true
        self.dangerZone = self.childNodeWithName("dangerZone") as? SKSpriteNode
        self.dangerZone?.zPosition = -3
        self.endZone = self.childNodeWithName("endZone") as? SKSpriteNode
        self.startButton = self.childNodeWithName("playButton") as? SKSpriteNode
        self.leftDoor = self.childNodeWithName("portaEsquerda") as? SKSpriteNode
        self.rightDoor = self.childNodeWithName("portaDireita") as? SKSpriteNode
        self.middleDoor = self.childNodeWithName("portaMeio")
        self.middleRightDoor = self.middleDoor?.childNodeWithName("portaMeioDireita") as? SKSpriteNode
        self.middleLeftDoor = self.middleDoor?.childNodeWithName("portaMeioEsquerda") as? SKSpriteNode
        self.menu = self.childNodeWithName("menu") as? SKSpriteNode
        
        self.gameCenterButton = self.childNodeWithName("gameCenterButton") as? SKSpriteNode
        self.gameCenterIcon = self.gameCenterButton.childNodeWithName("gameCenterIcon") as? SKSpriteNode
        
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
        
        //define openDoorAction
        let rotateMiddle = SKAction.rotateByAngle(CGFloat(M_PI_2), duration: 0.7)
        rotateMiddle.timingMode = SKActionTimingMode.EaseInEaseOut
        let openDoorLeft = SKAction.moveBy(CGVector(dx: -485, dy: 0), duration: 1.0)
        openDoorLeft.timingMode = SKActionTimingMode.EaseInEaseOut
        let openDoorRight = SKAction.moveBy(CGVector(dx: 475, dy: 0), duration: 1.0)
        openDoorRight.timingMode = SKActionTimingMode.EaseInEaseOut
        let openMiddleLeft = SKAction.moveBy(CGVector(dx: -485, dy: 0), duration: 1.0)
        openMiddleLeft.timingMode = SKActionTimingMode.EaseInEaseOut
        let openMiddleRight = SKAction.moveBy(CGVector(dx: 475, dy: 0), duration: 1.0)
        openMiddleRight.timingMode = SKActionTimingMode.EaseInEaseOut
        let openingDoorGroup = SKAction.group([openDoorLeft,openDoorRight,openMiddleLeft,openMiddleRight])
        self.openDoorAction = SKAction.sequence([
            rotateMiddle,SKAction.waitForDuration(0.7),SKAction.runBlock({ () -> Void in
                if(self.soundOn){
                    self.playBackgroundMusic()
                }
            }),
            SKAction.group([
                SKAction.runBlock({ () -> Void in
                    if(self.soundOn){
                        self.runAction(SKAction.playSoundFileNamed("doorsfx.mp3", waitForCompletion: false))
                    }
                }),
                //SKAction.playSoundFileNamed("doorsfx.mp3", waitForCompletion: false),
                SKAction.runBlock({
                    self.leftDoor?.runAction(openDoorLeft)
                }),
                SKAction.runBlock({
                    self.rightDoor?.runAction(openDoorRight)
                }),
                SKAction.runBlock({
                    self.middleLeftDoor?.runAction(openMiddleLeft)
                }),
                SKAction.runBlock({
                    self.middleRightDoor?.runAction(openMiddleRight)
                })
                
                ])
            ])
        self.closeDoorAction = SKAction.sequence([
            SKAction.group([
                SKAction.runBlock({
                    self.leftDoor?.runAction(openDoorLeft.reversedAction())
                }),
                SKAction.runBlock({
                    self.rightDoor?.runAction(openDoorRight.reversedAction())
                }),
                SKAction.runBlock({
                    self.middleLeftDoor?.runAction(openMiddleLeft.reversedAction())
                }),
                SKAction.runBlock({
                    self.middleRightDoor?.runAction(openMiddleRight.reversedAction())
                })
                
                ]),
            SKAction.waitForDuration(1.0),
            SKAction.runBlock({ () -> Void in
                if(self.soundOn){
                    self.runAction(SKAction.playSoundFileNamed("doorsfx.mp3", waitForCompletion: false))
                }
            }),
            //SKAction.playSoundFileNamed("doorsfx.mp3", waitForCompletion: false),
            rotateMiddle,
            SKAction.runBlock({ () -> Void in
                self.stopBackgroundMusic()
                if(self.soundOn){
                    self.playMenuMusic()
                }
                
            })
            ])
        
        
        //start danger zone animations
        self.startDangerZoneAnimation()
        
        //begin background music
        if(soundOn){
            self.playMenuMusic()
        }
        
        highlight = SKSpriteNode(color: SKColor.blackColor(), size: CGSizeMake(self.frame.width, self.frame.height))
        
        self.bgImage = self.childNodeWithName("bgImage") as? SKSpriteNode
        self.pauseButton = self.bgImage.childNodeWithName("pauseButton") as? SKSpriteNode
        
        let cancelButton : SKSpriteNode = SKSpriteNode(texture: SKTexture(imageNamed: "cancel_button_pixelated"), size: CGSize(width: 85, height: 85))
        cancelButton.position = CGPoint(x: 626/2 - 90, y: 606/2 - 120)
        cancelButton.name = "cancelButton"
        cancelButton.zPosition = 20
        self.menu?.addChild(cancelButton)
        
        credits = Credits(x: 0, y: 0, width: 626, height: 606)
        credits.zPosition = 18
        
        endGameMenu = EndGameMenu(x: 0, y: 0, width: 626, height: 606, score: 100, highScore: 9999)
        endGameMenu.zPosition = 18
        
        pauseMenu = PauseMenu(x: 0, y: 0, width: 626, height: 606, soundOn: soundOn)
        pauseMenu.zPosition = 18
        
        settingsMenu = SettingsMenu(x: 0, y: 0, width: 626, height: 606, soundOn: soundOn)
        settingsMenu.zPosition = 18
        
    }
    
    //Restart with initial level
    func restart(level:Int)
    {
        self.score = 0
        self.level = level
        self.difficulty = Float(self.level)
        updateLabels()
        self.arrowSpeed = 1.0
        self.arrowInDangerZone = 0;
        self.removeAllActions()
        //begin background music
        self.stopMenuMusic()
        self.pauseEnable = true
        
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
        validateSwipe(LEFT, direction: Direction.RIGHT)
    }
    func swipeLeftLeftView(swipe:UISwipeGestureRecognizer) {
        validateSwipe(LEFT, direction: Direction.LEFT)
    }
    func swipeUpLeftView(swipe:UISwipeGestureRecognizer) {
        validateSwipe(LEFT, direction: Direction.UP)
    }
    func swipeDownLeftView(swipe:UISwipeGestureRecognizer) {
        validateSwipe(LEFT, direction: Direction.DOWN)
    }
    
    func swipeRightRightView(swipe:UISwipeGestureRecognizer) {
        validateSwipe(RIGHT, direction: Direction.RIGHT)
    }
    func swipeLeftRightView(swipe:UISwipeGestureRecognizer) {
        validateSwipe(RIGHT, direction: Direction.LEFT)
    }
    func swipeUpRightView(swipe:UISwipeGestureRecognizer) {
        validateSwipe(RIGHT, direction: Direction.UP)
    }
    func swipeDownRightView(swipe:UISwipeGestureRecognizer) {
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
            
            if(node.name == "endGamePlayButton"){
                self.endGameMenu.playButton.texture = SKTexture(imageNamed: "button_play_pressed_pixelated")
            }
            
            if(node.name == "mainMenuButton" || node.name == "mainMenuLabel"){
                self.pauseMenu.mainMenuButton.texture = SKTexture(imageNamed: "button_generic_pressed")
                self.pauseMenu.mainMenuLabel.position = CGPoint(x: 0, y: -10)
            }
            
            if(node.name == "pauseSoundButton" || node.name == "pauseSoundLabel"){
                self.pauseMenu.soundButton.texture = SKTexture(imageNamed: "button_generic_pressed")
                self.pauseMenu.soundLabel.position = CGPoint(x: 0, y: -10)

            }
            
            if(node.name == "settingsTutorialButton" || node.name == "tutorialLabel"){
                self.settingsMenu.tutorialButton.texture = SKTexture(imageNamed: "button_generic_pressed")
                self.settingsMenu.tutorialLabel.position = CGPoint(x: 0, y: -10)
            }
            
            if(node.name == "settingsSoundButton" || node.name == "settingsSoundLabel"){
                self.settingsMenu.soundButton.texture = SKTexture(imageNamed: "button_generic_pressed")
                self.settingsMenu.soundLabel.position = CGPoint(x: 0, y: -10)
            }
            
            if(node.name == "creditsButton" || node.name == "creditsLabel"){
                self.settingsMenu.creditisButton.texture = SKTexture(imageNamed: "button_generic_pressed")
                self.settingsMenu.creditsLabel.position = CGPoint(x: 0, y: -10)
            }
            
            if(node.name == "gameCenterButton" || node.name == "gameCenterIcon"){
                self.gameCenterButton.texture = SKTexture(imageNamed: "small_generic_button_pressed_pixelated")
                self.gameCenterIcon.position = CGPoint(x: 0, y: -5)
            }
            
            if(node.name == "cancelButton" && !animatingMenu){
                self.hideMenu(){
                    self.highlight?.removeFromParent()
                    self.settingsMenu.removeFromParent()
                    self.pauseMenu.removeFromParent()
                    self.endGameMenu.removeFromParent()
                    self.credits.removeFromParent()
                    self.unpauseGame()
                    if(self.inGame && self.soundOn){
                        self.unpauseBackGroundMusic()
                    }
                }
            }
            
            //settings button
            if node.name == "settings" && !inGame && !animatingMenu{

                animatingMenu = true
                if(!inMenu)
                {
                    self.menu?.addChild(self.settingsMenu)
                    self.highlight?.position.x = CGRectGetMidX(self.frame)
                    self.highlight?.position.y = CGRectGetMidY(self.frame)
                    self.highlight?.zPosition = 10
                    self.highlight?.alpha = 0.5
                    self.addChild(self.highlight!)
                    self.showMenu(){}
                }else
                {
                    self.hideMenu(){
                        self.highlight?.removeFromParent()
                        self.settingsMenu.removeFromParent()
                        self.endGameMenu.removeFromParent()
                    }
                }
            }
            if node.name == "pauseButton" && inGame && !animatingMenu && pauseEnable{
                animatingMenu = true
                if(!self.pause)
                {
                    self.pauseGame()
                    self.pauseBackGroundMusic()
                    self.menu?.addChild(self.pauseMenu)
                    self.highlight?.position.x = CGRectGetMidX(self.frame)
                    self.highlight?.position.y = CGRectGetMidY(self.frame)
                    self.highlight?.zPosition = 10
                    self.highlight?.alpha = 0.5
                    self.addChild(self.highlight!)
                    self.showMenu(){}
                }else
                {
                    self.hideMenu(){
                        self.highlight?.removeFromParent()
                        self.unpauseGame()
                        if(self.soundOn){
                            self.unpauseBackGroundMusic()
                        }
                        self.pauseMenu.removeFromParent()
                    }
                }
                
            }
        }
    }
    
    func setGame(){
        self.inGame = true
        self.startButton?.removeFromParent()
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
        self.levelLabel?.hidden = false
        self.gameCenterButton.hidden = true
        self.gameCenterButton.zPosition = -50
        self.gameCenterIcon.hidden = true
        self.gameCenterIcon.zPosition = -50
        self.stopMenuMusic()
        self.playBackgroundMusic()
        if(!soundOn){
            self.pauseBackGroundMusic()
        }
        self.leftLight?.texture = nil
        self.leftLight?.removeActionForKey("dangerAction")
        self.rightLight?.texture = nil
        self.rightLight?.removeActionForKey("dangerAction")
        self.leftBulb?.texture = SKTexture(imageNamed: "bulb_off")
        self.leftBulb?.removeActionForKey("dangerAction")
        self.rightBulb?.texture = SKTexture(imageNamed: "bulb_off")
        self.rightBulb?.removeActionForKey("dangerAction")
    }
    
    override func touchesEnded(touches: Set<NSObject>, withEvent event: UIEvent) {
        for touch: AnyObject in touches {
            // Get the location of the touch in this scene
            let location = touch.locationInNode(self)
            let node = self.nodeAtPoint(location)
            // Check if the location of the touch is within the button's bounds
            if node.name == "playButton" && inMenu == false{
                self.setGame()
                if(self.firstTime == 1){
                    self.restart(1);
                } else {
                    self.tutorial()
                    self.firstTime = 1
                    userDefaults.setInteger(1, forKey: "firstTime")
                }
                self.animateDoor()
                {
                    self.startLevel()
                }
            } else if node.name == "endGamePlayButton" {
            
                self.endGameMenu.playButton.texture = SKTexture(imageNamed: "button_play_pixelated")
                self.hideMenu(){
                    self.highlight?.removeFromParent()
                    self.endGameMenu.removeFromParent()
                    self.setGame()
                    if(self.firstTime == 1){
                        self.restart(1);
                    } else {
                        self.tutorial()
                        self.firstTime = 1
                        self.userDefaults.setInteger(1, forKey: "firstTime")
                    }
                    self.animateDoor()
                        {
                            
                            self.startLevel()
                    }
                }
                
            } else if node.name == "mainMenuButton" || node.name == "mainMenuLabel"{
                self.pauseMenu.mainMenuButton.texture = SKTexture(imageNamed: "button_generic")
                self.pauseMenu.mainMenuLabel.position = CGPoint(x: 0, y: 0)
                
                self.unpauseGame()
                self.hideMenu(){
                    self.highlight?.removeFromParent()
                    self.pauseMenu.removeFromParent()
                    self.finishGame()
                }
            }else if (node.name == "pauseSoundButton" || node.name == "pauseSoundLabel"){
                if(self.soundOn){
                    self.pauseMenu.soundLabel.text = "Unmute"
                    self.settingsMenu.soundLabel.text = "Unmute"
                    self.soundOn = false
                    self.userDefaults.setBool(false, forKey: "soundOn")
                }else{
                    self.pauseMenu.soundLabel.text = "Mute"
                    self.settingsMenu.soundLabel.text = "Mute"
                    self.soundOn = true
                    self.userDefaults.setBool(true, forKey: "soundOn")
                }
                self.pauseMenu.soundButton.texture = SKTexture(imageNamed: "button_generic")
                self.pauseMenu.soundLabel.position = CGPoint(x: 0, y: 0)
            
            }else if (node.name == "settingsTutorialButton" || node.name == "tutorialLabel"){
                self.settingsMenu.tutorialButton.texture = SKTexture(imageNamed: "button_generic")
                self.settingsMenu.tutorialLabel.position = CGPoint(x: 0, y: 0)
                self.highlight?.removeFromParent()
                self.setGame()
                self.hideMenu(){
                    self.settingsMenu.removeFromParent()
                    self.inTutorial = 0
                    self.tutorial()
                    self.animateDoor(){
                        self.startLevel()
                    }
                }
                
            }else if (node.name == "settingsSoundButton" || node.name == "settingsSoundLabel"){
                if(self.soundOn){
                    self.stopMenuMusic()
                    self.settingsMenu.soundLabel.text = "Unmute"
                    self.pauseMenu.soundLabel.text = "Unmute"
                    self.soundOn = false
                    self.userDefaults.setBool(false, forKey: "soundOn")
                }else{
                    self.playMenuMusic()
                    self.settingsMenu.soundLabel.text = "Mute"
                    self.pauseMenu.soundLabel.text = "Mute"
                    self.soundOn = true
                    self.userDefaults.setBool(true, forKey: "soundOn")
                }
                self.settingsMenu.soundButton.texture = SKTexture(imageNamed: "button_generic")
                self.settingsMenu.soundLabel.position = CGPoint(x: 0, y: 0)
                
            }else if(node.name == "creditsButton" || node.name == "creditsLabel"){
                self.settingsMenu.creditisButton.texture = SKTexture(imageNamed: "button_generic")
                self.settingsMenu.creditsLabel.position = CGPoint(x: 0, y: 0)
                self.hideMenu({ () -> () in
                    self.settingsMenu.removeFromParent()
                    self.menu?.addChild(self.credits)
                    self.showMenu(){
                        
                    }
                })
                
            }else if (node.name == "gameCenterButton" || node.name == "gameCenterIcon"){
                self.gameCenterButton.texture = SKTexture(imageNamed: "small_generic_button")
                self.gameCenterIcon.position = CGPoint(x: 0, y: 5)
                self.showLeaderboard()

            }else{
                self.startButton?.texture = SKTexture(imageNamed: "button_play_pixelated")
                self.endGameMenu.playButton.texture = SKTexture(imageNamed: "button_play_pixelated")
                self.pauseMenu.mainMenuButton.texture = SKTexture(imageNamed: "button_generic")
                self.pauseMenu.mainMenuLabel.position = CGPoint(x: 0, y: 0)
                self.pauseMenu.soundButton.texture = SKTexture(imageNamed: "button_generic")
                self.pauseMenu.soundLabel.position = CGPoint(x: 0, y: 0)
                self.settingsMenu.tutorialButton.texture = SKTexture(imageNamed: "button_generic")
                self.settingsMenu.tutorialLabel.position = CGPoint(x: 0, y: 0)
                self.settingsMenu.soundButton.texture = SKTexture(imageNamed: "button_generic")
                self.settingsMenu.soundLabel.position = CGPoint(x: 0, y: 0)
                self.settingsMenu.creditisButton.texture = SKTexture(imageNamed: "button_generic")
                self.settingsMenu.creditsLabel.position = CGPoint(x: 0, y: 0)
                self.gameCenterButton.texture = SKTexture(imageNamed: "small_generic_button")
                self.gameCenterIcon.position = CGPoint(x: 0, y: 5)
                
            }
            
        }
    }
    
    //Function that creates and adds arrows to the scene
    func addArrow(side:Int){
        if(!pause)
        {
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
    }
    //Function that increases score and level through progress
    func addScore(){
        self.score++;
        if(score % 15 == 0){
            level++
            if(level >= 5){
                if(level % 2 == 0){
                    difficulty += (Float(1/Float(self.level)) + (0.001 * Float(self.level)))
                }
                arrowSpeed -= NSTimeInterval(1/Float(self.level))
            } else {
                self.difficulty = Float(level)
            }
            if(difficulty >= 10){
                difficulty = 10
            }
            if(arrowSpeed <= 0.5 && level < 50){
                arrowSpeed = 0.5
            } else if(level >= 50 && level < 100){
                arrowSpeed = 0.4
            } else if(level >= 100){
                arrowSpeed = 0.3
            }
            if(level % 50 == 0){
                difficulty += 1.0
            }
            self.arrowParent.removeAllActions()
            var block = SKAction.runBlock{
                self.startLevel()
            }
            self.runAction(block)
        }
        
        if(score > highScore){
            changeHighScore(score)
            GameViewController().saveHighscore(score)
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
        self.arrowParent.position = CGPoint(x: 0, y: 0)
        if(soundOn){
            randomActions.append(SKAction.playSoundFileNamed("swipe2.wav", waitForCompletion: false) )
        }
        
        for i in 0..<10 {
            let newX = initialX + CGFloat(arc4random_uniform(UInt32(amplitudeX))) - CGFloat(amplitudeX / 2)
            let newY = initialY + CGFloat(arc4random_uniform(UInt32(amplitudeY))) - CGFloat(amplitudeY / 2)
            randomActions.append(SKAction.moveTo(CGPointMake(newX, newY), duration: 0.015))
        }
        randomActions.append(SKAction.moveTo(CGPoint(x: initialX, y: initialY), duration: 0.015))
        var rep = SKAction.sequence(randomActions)
        
        self.arrowParent.runAction(rep)
        self.sparkAt(CGPoint(x: 735, y: 1178),angle: 180)
        self.sparkAt(CGPoint(x: 16, y: 668),angle: 0)
        
    }
    
    //Function checks the swipe and the first arrow from the side queue direction
    func validateSwipe(side: Int, direction: Direction){
        if(!pause)
        {
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
                    if(soundOn){
                        scoreLabel?.runAction(SKAction.playSoundFileNamed("swipe.wav", waitForCompletion: false))
                    }
                    if(CGRectIntersectsRect(arrow!.frame, dangerZone!.frame)){
                        arrowInDangerZone--
                        addScore()
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
                    self.comboCounter++
                    if(self.comboCounter > 32)
                    {
                        self.comboCounter = 32
                    }
                    var repeatTimes = (self.comboCounter/16) * (self.comboCounter/16)
                    if(repeatTimes == 0)
                    {
                        repeatTimes = 1
                    }else if(repeatTimes==1)
                    {
                        repeatTimes = 2
                    }
                    repeat(repeatTimes, function: { () -> () in
                        self.addScore()
                    })
                    if(self.comboCounter>=16)
                    {
                        self.comboLabel?.text = "Combo \(repeatTimes)X"
                        self.comboLabel?.hidden = false
                        if(repeatTimes==4 && self.comboTop?.parent == nil)
                        {
                            self.combo()
                        }
                    }
                }else{
                    self.missAction()
                    self.comboLabel?.hidden = true
                    self.comboCounter = 0
                    self.comboFinalize()
                }
            }else{
                self.missAction()
                self.comboLabel?.hidden = true
                self.comboCounter = 0
                self.comboFinalize()
            }
        } else if(inTutorial == 1) {
            if(side == LEFT && direction == Direction.LEFT){
                if(soundOn){
                    scoreLabel?.runAction(SKAction.playSoundFileNamed("swipe.wav", waitForCompletion: false))
                }
                inTutorial = 2
                self.addScore()
                tutorial()
            }
        } else if(inTutorial == 3) {
            if(side == RIGHT && direction == Direction.UP){
                if(soundOn){
                    scoreLabel?.runAction(SKAction.playSoundFileNamed("swipe.wav", waitForCompletion: false))
                }
                inTutorial = 4
                self.addScore()
                self.addScore()
                tutorial()
            }
        } else if(inTutorial == 5) {
            if(side == LEFT && direction == Direction.DOWN){
                if(soundOn){
                    scoreLabel?.runAction(SKAction.playSoundFileNamed("swipe.wav", waitForCompletion: false))
                }
                inTutorial = 6
                self.addScore()
                tutorial()
            }
        }
    }
    
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
        if(!pause)
        {
            for i in 0 ... self.arrowQueue[LEFT].length {
                self.arrowQueue[LEFT].getPosition(i)?.update(CGFloat(self.difficulty/100) + CGFloat(0.05), queue:arrowQueue[LEFT])
            }
            for i in 0 ... self.arrowQueue[RIGHT].length {
                self.arrowQueue[RIGHT].getPosition(i)?.update(CGFloat(self.difficulty/100) + CGFloat(0.05), queue:arrowQueue[RIGHT])
            }
        }
        
    }
    
    func arrowDidCollideWithEndZone(){
        self.pauseEnable = false
        finishGame()
    }
    
    func arrowDidCollideWithDangetZone(){
        arrowInDangerZone++
        
        if(arrowInDangerZone == 1 && soundOn){
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
        let collision = arrow.categoryBitMask | secondBody.categoryBitMask
        if(collision == (PhysicsCategory.arrow | PhysicsCategory.dangerZone))
        {
            arrowDidCollideWithDangetZone()
            //play danger animation
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
        self.arrowParent.runAction(SKAction.repeatActionForever(SKAction.sequence([wait, run])))
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
        if(soundOn){
            self.runAction(SKAction.playSoundFileNamed("explosion.wav", waitForCompletion: false))
        }
    }
    
    func endGame(){
        
        var fadeIn = SKAction.fadeAlphaTo(0.5, duration: 0.5)
        
        if(!self.inMenu)
        {
            self.inMenu = true
            self.pauseEnable = false
            self.comboFinalize()
            animateDoorReverse { () -> () in
                self.stopBackgroundMusic()
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
                self.comboLabel?.hidden = true
                self.comboCounter = 0
                self.inGame = false
                self.inMenu = true
                self.endGameMenu.label2.text = String(self.score)
                self.endGameMenu.label4.text = String(self.highScore)
                self.menu?.addChild(self.endGameMenu)
                self.highlight?.position.x = CGRectGetMidX(self.frame)
                self.highlight?.position.y = CGRectGetMidY(self.frame)
                self.highlight?.zPosition = 10
                self.highlight?.alpha = 0.0
                self.addChild(self.highlight!)
                self.highlight?.runAction(fadeIn)
                self.gameCenterButton.hidden = false
                self.gameCenterButton.zPosition = 6
                self.gameCenterIcon.hidden = false
                self.gameCenterIcon.zPosition = 0
                self.showMenu({ () -> () in
                    
                })
            }
        }
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
            var url:NSURL = NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("Rhinocerosseamless", ofType: "mp3")!)!
            var erro:NSError? = nil
            bgMusicPlayer = AVAudioPlayer(contentsOfURL: url, error: &erro)
            bgMusicPlayer?.numberOfLoops = -1;
            bgMusicPlayer?.prepareToPlay()
        }
        bgMusicPlayer?.play()
    }
    
    func pauseBackGroundMusic()
    {
        bgMusicPlayer?.pause()
    }
    
    func unpauseBackGroundMusic()
    {
        bgMusicPlayer?.play()
    }
    
    func stopBackgroundMusic()
    {
        bgMusicPlayer?.pause()
        bgMusicPlayer?.currentTime = 0;
    }
    
    func playMenuMusic()
    {
        if(self.menuMusicPlayer == nil)
        {
            var url:NSURL = NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("menumusic", ofType: "mp3")!)!
            var erro:NSError? = nil
            menuMusicPlayer = AVAudioPlayer(contentsOfURL: url, error: &erro)
            menuMusicPlayer?.numberOfLoops = -1;
            menuMusicPlayer?.prepareToPlay()
        }
        menuMusicPlayer?.pause()
        menuMusicPlayer?.currentTime = 0;
        menuMusicPlayer?.play()
    }
    
    func stopMenuMusic()
    {
        menuMusicPlayer?.pause()
    }
    
    func sparkAt(pos: CGPoint, angle:Float) {
        var emitterNode = SKEmitterNode(fileNamed: "sparkParticle.sks")
        emitterNode.particlePosition = pos
        emitterNode.particleColorBlendFactor = 1.0
        emitterNode.particleColorSequence = nil
        emitterNode.emissionAngle = CGFloat(angle)
        arrowParent.addChild(emitterNode)
        self.runAction(SKAction.waitForDuration(1.5), completion: { emitterNode.removeFromParent() })
    }
    
    //Combo Particle
    func combo() {
        comboTop = SKEmitterNode(fileNamed: "comboParticle.sks")
        comboBot = SKEmitterNode(fileNamed: "comboParticle.sks")
        comboLeft = SKEmitterNode(fileNamed: "comboParticle.sks")
        comboRight = SKEmitterNode(fileNamed: "comboParticle.sks")
        
        comboTop!.particlePosition = CGPointMake(size.width/2, size.height)
        comboBot!.particlePosition = CGPointMake(size.width/2, 0)
        comboBot!.yAcceleration = CGFloat(400.0)
        
        comboLeft!.particlePosition = CGPointMake(0, size.height/2)
        comboLeft!.particlePositionRange = CGVector(dx: 1, dy: 1500)
        comboLeft!.xAcceleration = CGFloat(400.0)
        
        comboRight!.particlePosition = CGPointMake(size.width, size.height/2)
        comboRight!.particlePositionRange = CGVector(dx: 1, dy: 1500)
        comboRight!.xAcceleration = CGFloat(-400.0)
        
        comboRight!.zPosition = -1
        comboLeft?.zPosition = -1
        comboTop?.zPosition = -1
        comboBot?.zPosition = -1
        
        self.addChild(comboTop!)
        self.addChild(comboBot!)
        self.addChild(comboLeft!)
        self.addChild(comboRight!)
    }
    
    func animateDoor(callback:()->())
    {
        
        var action = SKAction.sequence([self.openDoorAction,SKAction.waitForDuration(2.0),SKAction.runBlock(callback)])
        self.middleDoor?.runAction(action)
    }
    
    func animateDoorReverse(callback:()->())
    {
        var action = SKAction.sequence([self.closeDoorAction,SKAction.waitForDuration(0.3),SKAction.runBlock(callback)])
        self.middleDoor?.runAction(action)
    }
    
    func showMenu(callback:()->())
    {
        self.inMenu = true
        var act1 = SKAction.moveBy(CGVector(dx: 0, dy: -1054), duration: 0.5)
        var act2 = SKAction.moveBy(CGVector(dx: 0, dy: 20), duration: 0.1)
        var act3 = SKAction.moveBy(CGVector(dx: 0, dy: -20), duration: 0.1)
        act1.timingMode = SKActionTimingMode.EaseInEaseOut
        act2.timingMode = SKActionTimingMode.EaseInEaseOut
        act3.timingMode = SKActionTimingMode.EaseInEaseOut
        
        if(self.soundOn){
            self.runAction(SKAction.playSoundFileNamed("chainDrop.mp3", waitForCompletion: false))
        }
        
        self.menu?.runAction(SKAction.sequence([
            act1,
            act2,
            act3,
            SKAction.runBlock({self.animatingMenu = false})
            ]), completion: callback)
    }
    
    func hideMenu(callback:()->())
    {
        self.inMenu = false
        inMenu = false
        var action = SKAction.moveBy(CGVector(dx: 0, dy: 1054), duration: 0.5)
        action.timingMode = SKActionTimingMode.EaseIn
        if(self.soundOn){
            self.runAction(SKAction.playSoundFileNamed("chainDrop.mp3", waitForCompletion: false))
        }
        self.menu?.runAction(SKAction.sequence([action,SKAction.runBlock({self.animatingMenu = false})]), completion: callback)
        
    }
    
    func pauseGame()
    {
        self.pause = true;
        self.arrowParent.paused = true
        
    }
    
    func unpauseGame()
    {
        self.pause = false;
        self.arrowParent.paused = false
    }
    
    func repeat(num:Int,function:()->())
    {
        var i=0;
        for(i=0;i<num;i++)
        {
            function()
        }
    }
    
    func tutorial(){
        
        self.pauseButton.hidden = true
        self.pauseButton.position = CGPoint(x: 100, y: 100)
        
        //sets basic tutorial actions
        var wait = SKAction.waitForDuration(2)
        var setAlpha = SKAction.fadeAlphaTo(0.65, duration: 0.5)
        var block = SKAction.runBlock{
            //self.highlight!.runAction(setAlpha)
            self.tutorialLabel1!.hidden = false
            self.tutorialLabel2!.hidden = false
            self.leftView.hidden = false
            self.rightView.hidden = false
        }
        
        pause = true
        
        if(inTutorial == 0){
            //sets game level and score
            self.restart(1)
            //sets the tutorial arrow
            tutorialArrow = Arrow(direction: Direction.LEFT, type:RIGHT, imageNamed: "arrow_pixelated")
            tutorialArrow!.color = UIColor.blueColor()
            tutorialArrow!.colorBlendFactor = 1.0
            tutorialArrow!.position = CGPointMake(size.width/4, size.height+tutorialArrow!.size.height)
            //initializes the highlight
            highlight!.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame))
            highlight!.alpha = 0
            highlight!.zPosition = -2
            self.addChild(self.highlight!)
            //sets the labels with instructions
            tutorialLabel1 = SKLabelNode(fontNamed: "DisposableDroidBB-Bold")
            tutorialLabel1!.text = "Swipe in the arrow direction"
            tutorialLabel1!.fontColor = SKColor(red: 36/255, green: 141/255, blue: 1, alpha: 1.0)
            tutorialLabel1!.fontSize = 50
            tutorialLabel1!.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame))
            tutorialLabel1!.hidden = true
            self.addChild(self.tutorialLabel1!)
            tutorialLabel2 = SKLabelNode(fontNamed: "DisposableDroidBB-Bold")
            tutorialLabel2!.text = "inside its area to destroy it."
            tutorialLabel2!.fontColor = SKColor(red: 36/255, green: 141/255, blue: 1, alpha: 1.0)
            tutorialLabel2!.fontSize = 50
            tutorialLabel2!.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame) - tutorialLabel1!.frame.height)
            tutorialLabel2!.hidden = true
            self.addChild(self.tutorialLabel2!)
            
            self.leftView.hidden = true
            var move = SKAction.moveToY((size.height/2)+2*tutorialLabel1!.frame.height, duration: 2)
            
            self.arrowParent.addChild(self.tutorialArrow!)
            self.tutorialArrow!.runAction(SKAction.sequence([wait, move]))
            self.highlight!.position.x = self.size.width
            self.highlight!.runAction(SKAction.sequence([wait, wait, setAlpha, block, SKAction.runBlock({ () -> Void in
                self.inTutorial = 1
            })]))
            //inTutorial = 1
            
        } else if(inTutorial == 2){
            tutorialLabel1!.hidden = true
            tutorialLabel2!.hidden = true
            rightView.hidden = true
            highlight!.alpha = 0.0
            
            tutorialArrow!.position.y = size.height+tutorialArrow!.size.height
            tutorialArrow!.position.x = 3*size.width/4
            tutorialArrow!.direction = Direction.UP
            tutorialArrow!.zRotation += CGFloat(3*M_PI/2)
            
            tutorialLabel1!.text = "If you destroy the arrow in the"
            tutorialLabel1!.fontSize = 45
            tutorialLabel2!.text = "danger zone you get double points"
            tutorialLabel2!.fontSize = 45
            highlight!.position.x = CGRectGetMidX(self.frame)
            highlight!.position.y += self.dangerZone!.size.height
            
            var move = SKAction.moveToY(tutorialArrow!.size.height, duration: 2)
            tutorialArrow!.runAction(move)
            self.highlight!.runAction(SKAction.sequence([wait, setAlpha, block]))
            inTutorial = 3
        } else if(inTutorial == 4){
            tutorialLabel1!.hidden = true
            tutorialLabel2!.hidden = true
            leftView.hidden = true
            highlight!.alpha = 0.0
            highlight!.removeFromParent()
            
            tutorialArrow!.position.y = size.height+tutorialArrow!.size.height
            tutorialArrow!.position.x = size.width/4
            tutorialArrow!.color = SKColor.redColor()
            
            tutorialLabel1!.text = "Swipe in the opposite direction"
            tutorialLabel1!.fontSize = 50
            tutorialLabel2!.text = "to destroy the red arrows!"
            tutorialLabel2!.fontSize = 50
            
            leftBulb?.texture = SKTexture(imageNamed: "bulb_off")
            leftBulb?.removeActionForKey("dangerAction")
            leftLight?.texture = nil
            leftLight?.removeActionForKey("dangerAction")
            rightBulb?.texture = SKTexture(imageNamed: "bulb_off")
            rightBulb?.removeActionForKey("dangerAction")
            rightLight?.texture = nil
            rightLight?.removeActionForKey("dangerAction")
            self.arrowInDangerZone--
            
            tutorialArrow!.texture = SKTexture(imageNamed: "arrow_wrong_pixelated")
            
            var move = SKAction.moveToY((size.height/2)+3*tutorialLabel1!.frame.height, duration: 2)
            var newBlock = SKAction.runBlock({ () -> Void in
                self.leftView.hidden = false
                self.tutorialLabel1!.hidden = false
                self.tutorialLabel2!.hidden = false
            })
            
            tutorialArrow!.runAction(move)
            self.runAction(SKAction.sequence([wait, newBlock]))
            inTutorial = 5
        } else if(inTutorial == 6){
            tutorialArrow!.removeFromParent()
            tutorialLabel1!.removeFromParent()
            tutorialLabel2!.removeFromParent()
            var unpause = SKAction.runBlock({ () -> Void in
                self.pause = false
                self.pauseButton.hidden = false
                self.pauseButton.position = CGPoint(x: 695, y: -80)
            })
            self.runAction(SKAction.sequence([wait, unpause]))
        }
    }
    
    func comboFinalize()
    {
        if(self.comboTop?.parent != nil){
            self.comboTop!.removeFromParent()
            self.comboBot!.removeFromParent()
            self.comboLeft!.removeFromParent()
            self.comboRight!.removeFromParent()
            changeComboColor(UIColor(red: 0, green: 44, blue: 246, alpha: 1))
        }
        
    }
    
    func changeComboColor(color:UIColor)
    {
        self.comboTop!.particleColor = color
        self.comboBot!.particleColor = color
        self.comboLeft!.particleColor = color
        self.comboRight!.particleColor = color
        self.comboTop?.particleColorSequence = nil
        self.comboBot?.particleColorSequence = nil
        self.comboLeft?.particleColorSequence = nil
        self.comboRight?.particleColorSequence = nil
    }
    
    //send high score to leaderboard
    func saveHighscore() {
        
        //check if user is signed in
        if GKLocalPlayer.localPlayer().authenticated {
            
            var scoreReporter = GKScore(leaderboardIdentifier: "swipe_hero_leaderboard")
            
            scoreReporter.value = Int64(self.highScore)
            
            var scoreArray: [GKScore] = [scoreReporter]
            
            GKScore.reportScores(scoreArray, withCompletionHandler: {(error : NSError!) -> Void in
                if error != nil {
                    println("error")
                }
            })
            
        }
        
    }
    
    func finishGame()
    {
        self.arrowParent.removeAllActions()
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
    
    
    
    //shows leaderboard screen
    func showLeaderboard() {
        var vc = self.view?.window?.rootViewController
        var gc = GKGameCenterViewController()
        gc.gameCenterDelegate = self
        vc?.presentViewController(gc, animated: true, completion: nil)
    }
    
    //hides leaderboard screen
    func gameCenterViewControllerDidFinish(gameCenterViewController: GKGameCenterViewController!)
    {
        gameCenterViewController.dismissViewControllerAnimated(true, completion: nil)
        
    }
    
    func didStartAuthentication() {
        self.startButton?.hidden = true
    }
    
    func finishedAuthenticationWithSuccess() {
        self.startButton?.hidden = false
        self.highScore = gameCenter.gcScore
    }
    
    func finishedAuthenticationFailed() {
        println("OHFUCK")
    }
    
    func finishedLoadingScore() {
        if(self.highScore < gameCenter.gcScore){
            changeHighScore(gameCenter.gcScore)
            
        }
    }
}
