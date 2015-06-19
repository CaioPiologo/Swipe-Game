//
//  Arrow.swift
//  Swipe Hero
//
//  Created by Caio Vinícius Piologo Véras Fernandes on 6/17/15.
//  Copyright (c) 2015 Caio. All rights reserved.
//
import SpriteKit
import UIKit

enum Direction:UInt32 {
    case UP, RIGHT, DOWN, LEFT
}

class Arrow:SKSpriteNode {
    
    var direction:Direction
    
    convenience init(direction:Direction, imageNamed:String) {
        let color = UIColor()
        let texture = SKTexture(imageNamed: imageNamed)
        //TODO: ajustar tamanho da seta
        let size = CGSizeMake(texture.size().width/3.5, texture.size().height/3.5)
        self.init(texture: texture, color: color, size: size, direction:direction)
        self.physicsBody = SKPhysicsBody(rectangleOfSize: self.size)
        self.physicsBody!.categoryBitMask = PhysicsCategory.arrow
        self.physicsBody!.contactTestBitMask = PhysicsCategory.dangerZone | PhysicsCategory.endZone
        self.physicsBody!.collisionBitMask = 0
        self.physicsBody!.dynamic = false
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(texture: SKTexture!, color: UIColor!, size: CGSize, direction:Direction) {
        self.direction = direction
        super.init(texture: texture, color: color, size: size)
    }
    
    func update(speed:CGFloat){
        self.position.y -= speed * self.size.height
        if(self.position.y < -self.size.height){
            var destroy = SKAction.removeFromParent()
            self.runAction(destroy)
        }
    }
}
