//
//  EndGameMenu.swift
//  Swipe Hero
//
//  Created by Andre Sakiyama on 7/2/15.
//  Copyright (c) 2015 Caio. All rights reserved.
//

import Foundation
import SpriteKit

class EndGameMenu: SKSpriteNode {
    
    var playButton : SKSpriteNode!
    var label2 : SKLabelNode!
    var label4 : SKLabelNode!
    
    init(x : CGFloat, y : CGFloat, width : CGFloat, height : CGFloat, score : Int, highScore : Int){
        let fontName = "DisposableDroidBB-Bold"
        let fontSize : CGFloat = 40
        let fontColor : UIColor = UIColor.blackColor()
        let buttonSize = CGSize(width: 300, height: 120)
        
        let label1 : SKLabelNode = SKLabelNode(text: "Score:")
        label1.fontName = fontName
        label1.fontSize = fontSize + 40
        label1.fontColor = fontColor
        label1.position = CGPoint(x: 0, y: height/2-140)
        
        label2 = SKLabelNode(text: String(score))
        label2.fontName = fontName
        label2.fontSize = fontSize + 200
        label2.fontColor = fontColor
        label2.position = CGPoint(x: 0, y: height/2-290)
        
        let label3 : SKLabelNode = SKLabelNode(text: "High Score:")
        label3.fontName = fontName
        label3.fontSize = fontSize
        label3.fontColor = fontColor
        label3.position = CGPoint(x: -40, y: height/2-330)
        
        label4 = SKLabelNode(text: String(highScore))
        label4.horizontalAlignmentMode = .Left
        label4.fontName = fontName
        label4.fontSize = fontSize
        label4.fontColor = fontColor
        label4.position = CGPoint(x: 70, y: height/2-330)
        
        playButton = SKSpriteNode(texture: SKTexture(imageNamed: "button_play_pixelated"), size: buttonSize)
        playButton.position = CGPoint(x: 0, y: height/2 - 440)
        playButton.name = "endGamePlayButton"
        
        super.init(texture: nil, color: UIColor.clearColor(), size: CGSize(width: width, height: height))
        super.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        super.position = CGPoint(x: x, y: y)
        
        self.addChild(label1)
        self.addChild(label2)
        self.addChild(label3)
        self.addChild(label4)
        self.addChild(playButton)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}