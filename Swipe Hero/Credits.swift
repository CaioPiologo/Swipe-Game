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
        let fontName = "I-pixel-u"
        let fontSize : CGFloat = 32
        
        let label1 : SKLabelNode = SKLabelNode(text: "Frobenius Team")
        label1.fontName = fontName
        label1.fontSize = 48
        label1.position = CGPoint(x: 0, y: height/2-140)
        
        let label2 : SKLabelNode = SKLabelNode(text: "Name1")
        label2.fontName = fontName
        label2.fontSize = fontSize
        label2.position = CGPoint(x: 0, y: height/2-180)
        
        let label3 : SKLabelNode = SKLabelNode(text: "Name2")
        label3.fontName = fontName
        label3.fontSize = fontSize
        label3.position = CGPoint(x: 0, y: height/2-220)
        
        let label4 : SKLabelNode = SKLabelNode(text: "Name3")
        label4.fontName = fontName
        label4.fontSize = fontSize
        label4.position = CGPoint(x: 0, y: height/2-260)
        
        let label5 : SKLabelNode = SKLabelNode(text: "Sonds Effects from")
        label5.fontName = fontName
        label5.fontSize = fontSize
        label5.position = CGPoint(x: 0, y: height/2-340)
        
        let label6 : SKLabelNode = SKLabelNode(text: "Site1")
        label6.fontName = fontName
        label6.fontSize = fontSize
        label6.position = CGPoint(x: 0, y: height/2-380)
        
        let label7 : SKLabelNode = SKLabelNode(text: "Background music from")
        label7.fontName = fontName
        label7.fontSize = fontSize
        label7.position = CGPoint(x: 0, y: height/2-460)
        
        let label8 : SKLabelNode = SKLabelNode(text: "Site2")
        label8.fontName = fontName
        label8.fontSize = fontSize
        label8.position = CGPoint(x: 0, y: height/2-500)
        
        
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
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}