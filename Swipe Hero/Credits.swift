//
//  Credits.swift
//  Swipe Hero
//
//  Created by Andre Sakiyama on 6/30/15.
//  Copyright (c) 2015 Caio. All rights reserved.
//

import Foundation
import SpriteKit

class Credits: SKSpriteNode {
    
    init(x : CGFloat, y : CGFloat, width : CGFloat, height : CGFloat){
        let fontName = "DisposableDroidBB-Bold"
        let fontSize : CGFloat = 40
        let fontColor = UIColor.whiteColor()
        
        let label1 : SKLabelNode = SKLabelNode(text: "Frobenius Team")
        label1.fontName = fontName
        label1.fontSize = fontSize + 16
        label1.fontColor = fontColor
        label1.position = CGPoint(x: 0, y: height/2-140)
        
        let label2 : SKLabelNode = SKLabelNode(text: "AAA: Andre Tsuyoshi Sakiyama")
        label2.fontName = fontName
        label2.fontSize = fontSize
        label2.fontColor = fontColor
        label2.horizontalAlignmentMode = .Left
        label2.position = CGPoint(x: -width/2 + 75, y: height/2-200)
        
        let label3 : SKLabelNode = SKLabelNode(text: "123: Caio Piologo Fernandes")
        label3.fontName = fontName
        label3.fontSize = fontSize
        label3.fontColor = fontColor
        label3.horizontalAlignmentMode = .Left
        label3.position = CGPoint(x: -width/2 + 75, y: height/2-240)
        
        let label4 : SKLabelNode = SKLabelNode(text: "RZC: Ricardo Zaiderman Charf")
        label4.fontName = fontName
        label4.fontSize = fontSize
        label4.fontColor = fontColor
        label4.horizontalAlignmentMode = .Left
        label4.position = CGPoint(x: -width/2 + 75, y: height/2-280)
        
        let label5 : SKLabelNode = SKLabelNode(text: "Sounds Effects from")
        label5.fontName = fontName
        label5.fontSize = fontSize
        label5.fontColor = fontColor
        label5.position = CGPoint(x: 0, y: height/2-340)
        
        let label6 : SKLabelNode = SKLabelNode(text: "bfxr.net")
        label6.fontName = fontName
        label6.fontSize = fontSize
        label6.fontColor = fontColor
        label6.position = CGPoint(x: 0, y: height/2-380)
        
        let label7 : SKLabelNode = SKLabelNode(text: "Background music from")
        label7.fontName = fontName
        label7.fontSize = fontSize
        label7.fontColor = fontColor
        label7.position = CGPoint(x: 0, y: height/2-440)
        
        let label8 : SKLabelNode = SKLabelNode(text: "Incompetech")
        label8.fontName = fontName
        label8.fontSize = fontSize
        label8.fontColor = fontColor
        label8.position = CGPoint(x: 0, y: height/2-480)
        
        let label9 : SKLabelNode = SKLabelNode(text: "WorthyKeygenMusic")
        label9.fontName = fontName
        label9.fontSize = fontSize
        label9.fontColor = fontColor
        label9.position = CGPoint(x: 0, y: height/2 - 520)
        
        
        super.init(texture: nil, color: UIColor.clearColor(), size: CGSize(width: width, height: height))
        super.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        super.position = CGPoint(x: x, y: y)
        
        self.addChild(label1)
        self.addChild(label2)
        self.addChild(label3)
        self.addChild(label4)
        self.addChild(label5)
        self.addChild(label6)
        self.addChild(label7)
        self.addChild(label8)
        self.addChild(label9)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}