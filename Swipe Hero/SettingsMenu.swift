//
//  SettingsMenu.swift
//  Swipe Hero
//
//  Created by Andre Sakiyama on 7/2/15.
//  Copyright (c) 2015 Caio. All rights reserved.
//

import Foundation
import SpriteKit

class SettingsMenu: SKSpriteNode {
    
    var tutorialButton : SKSpriteNode!
    var soundButton : SKSpriteNode!
    var creditisButton : SKSpriteNode!
    
    var tutorialLabel : SKLabelNode!
    var soundLabel : SKLabelNode!
    var creditsLabel : SKLabelNode!
    
    init(x : CGFloat, y : CGFloat, width : CGFloat, height : CGFloat, soundOn : Bool){
        
        let fontName = "DisposableDroidBB-Bold"
        let fontColor = UIColor.blackColor()
        let fontSize : CGFloat = 55
        let buttonSize = CGSize(width: 310, height: 120)
        
        tutorialLabel = SKLabelNode(text: "Tutorial")
        tutorialLabel.fontName = fontName
        tutorialLabel.fontColor = fontColor
        tutorialLabel.fontSize = fontSize
        tutorialLabel.name = "tutorialLabel"
        tutorialLabel.zPosition = 20
        
        if(soundOn){
            soundLabel = SKLabelNode(text: "Mute")
        }else{
            soundLabel = SKLabelNode(text: "Unmute")
        }
        soundLabel.fontName = fontName
        soundLabel.fontColor = fontColor
        soundLabel.fontSize = fontSize
        soundLabel.name = "settingsSoundLabel"
        soundLabel.zPosition = 20
        
        creditsLabel = SKLabelNode(text: "Credits")
        creditsLabel.fontName = fontName
        creditsLabel.fontColor = fontColor
        creditsLabel.fontSize = fontSize
        creditsLabel.name = "creditsLabel"
        creditsLabel.zPosition = 20
        
        tutorialButton = SKSpriteNode(texture: SKTexture(imageNamed: "button_generic"), size: buttonSize)
        tutorialButton.position = CGPoint(x: 0, y: height/2 - 200)
        tutorialButton.name = "settingsTutorialButton"
        tutorialButton.zPosition = 19
        tutorialButton.addChild(tutorialLabel)
        
        soundButton = SKSpriteNode(texture: SKTexture(imageNamed: "button_generic"), size: buttonSize)
        soundButton.position = CGPoint(x: 0, y: height/2 - 340)
        soundButton.name = "settingsSoundButton"
        soundButton.zPosition = 19
        soundButton.addChild(soundLabel)
        
        creditisButton = SKSpriteNode(texture: SKTexture(imageNamed: "button_generic"), size: buttonSize)
        creditisButton.position = CGPoint(x: 0, y: height/2 - 480)
        creditisButton.name = "creditsButton"
        creditisButton.zPosition = 19
        creditisButton.addChild(creditsLabel)
        
        super.init(texture: nil, color: UIColor.clearColor(), size: CGSize(width: width, height: height))
        super.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        super.position = CGPoint(x: x, y: y)
        
        self.addChild(tutorialButton)
        self.addChild(soundButton)
        self.addChild(creditisButton)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}