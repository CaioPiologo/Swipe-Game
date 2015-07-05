//
//  PauseMenu.swift
//  Swipe Hero
//
//  Created by Andre Sakiyama on 7/2/15.
//  Copyright (c) 2015 Caio. All rights reserved.
//

import Foundation
import SpriteKit

class PauseMenu: SKSpriteNode {
    
    var mainMenuButton : SKSpriteNode!
    var soundButton : SKSpriteNode!

    var mainMenuLabel : SKLabelNode!
    var soundLabel : SKLabelNode!
    
    init(x : CGFloat, y : CGFloat, width : CGFloat, height : CGFloat, soundOn : Bool){
        
        let fontName = "DisposableDroidBB-Bold"
        let fontColor = UIColor.blackColor()
        let fontSize : CGFloat = 36
        let buttonSize = CGSize(width: 250, height: 90)
        
        mainMenuLabel = SKLabelNode(text: "Main Menu")
        mainMenuLabel.fontName = fontName
        mainMenuLabel.fontColor = fontColor
        mainMenuLabel.fontSize = fontSize
        mainMenuLabel.name = "mainMenuLabel"
        mainMenuLabel.zPosition = 20
        
        if(soundOn){
            soundLabel = SKLabelNode(text: "Sound On")
        }else{
            soundLabel = SKLabelNode(text: "Sound Off")
        }
        soundLabel.fontName = fontName
        soundLabel.fontColor = fontColor
        soundLabel.fontSize = fontSize
        soundLabel.name = "pauseSoundLabel"
        soundLabel.zPosition = 20
        
        mainMenuButton = SKSpriteNode(texture: SKTexture(imageNamed: "button_generic"), size: buttonSize)
        mainMenuButton.position = CGPoint(x: 0, y: height/2 - 240)
        mainMenuButton.name = "mainMenuButton"
        mainMenuButton.zPosition = 19
        mainMenuButton.addChild(mainMenuLabel)
        
        soundButton = SKSpriteNode(texture: SKTexture(imageNamed: "button_generic"), size: buttonSize)
        soundButton.position = CGPoint(x: 0, y: height/2 - 380)
        soundButton.name = "pauseSoundButton"
        soundButton.zPosition = 19
        soundButton.addChild(soundLabel)
        
        super.init(texture: nil, color: UIColor.clearColor(), size: CGSize(width: width, height: height))
        super.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        super.position = CGPoint(x: x, y: y)

        self.addChild(mainMenuButton)
        self.addChild(soundButton)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}