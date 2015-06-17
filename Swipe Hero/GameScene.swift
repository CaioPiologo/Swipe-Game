//
//  GameScene.swift
//  Swipe Hero
//
//  Created by Caio Vinícius Piologo Véras Fernandes on 6/17/15.
//  Copyright (c) 2015 Caio. All rights reserved.
//

import SpriteKit

class GameScene: SKScene {
    
    var arrows: Array<Arrow> = []
    
    override func didMoveToView(view: SKView) {
        /* Setup your scene here */
//        let myLabel = SKLabelNode(fontNamed:"Chalkduster")
//        myLabel.text = "Hello, World!";
//        myLabel.fontSize = 65;
//        myLabel.position = CGPoint(x:CGRectGetMidX(self.frame), y:CGRectGetMidY(self.frame));
//        
//        self.addChild(myLabel)
        let dangerZone = SKShapeNode(rectOfSize: CGSize(width: size.width, height: size.height * 0.1))
        dangerZone.fillColor = SKColor.redColor()
        dangerZone.position = CGPointMake(size.width/2, size.height*0.05)
        self.addChild(dangerZone)
    }
    
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */

    }
    
    
}
