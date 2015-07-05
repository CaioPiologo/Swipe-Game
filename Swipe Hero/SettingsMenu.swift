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
    
    var tutorialLabel : SKLabelNode!
    var soundLabel : SKLabelNode!
    
    init(x : CGFloat, y : CGFloat, width : CGFloat, height : CGFloat, soundOn : Bool){
        
        let fontName = "DisposableDroidBB-Bold"
        let fontColor = UIColor.blackColor()
        let fontSize : CGFloat = 36
        let buttonSize = CGSize(width: 250, height: 90)
        
        tutorialLabel = SKLabelNode(text: "Tutorial")
        tutorialLabel.fontName = fontName
        tutorialLabel.fontColor = fontColor
        tutorialLabel.fontSize = fontSize
        tutorialLabel.name = "tutorialLabel"
        tutorialLabel.zPosition = 20
        
        if(soundOn){
            soundLabel = SKLabelNode(text: "Sound On")
        }else{
            soundLabel = SKLabelNode(text: "Sound Off")
        }
        soundLabel.fontName = fontName
        soundLabel.fontColor = fontColor
        soundLabel.fontSize = fontSize
        soundLabel.name = "settingsSoundLabel"
        soundLabel.zPosition = 20
        
        tutorialButton = SKSpriteNode(texture: SKTexture(imageNamed: "button_generic"), size: buttonSize)
        tutorialButton.position = CGPoint(x: 0, y: height/2 - 240)
        tutorialButton.name = "settingsTutorialButton"
        tutorialButton.zPosition = 19
        tutorialButton.addChild(tutorialLabel)
        
        soundButton = SKSpriteNode(texture: SKTexture(imageNamed: "button_generic"), size: buttonSize)
        soundButton.position = CGPoint(x: 0, y: height/2 - 380)
        soundButton.name = "settingsSoundButton"
        soundButton.zPosition = 19
        soundButton.addChild(soundLabel)
        
        super.init(texture: nil, color: UIColor.clearColor(), size: CGSize(width: width, height: height))
        super.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        super.position = CGPoint(x: x, y: y)
        
        self.addChild(tutorialButton)
        self.addChild(soundButton)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}