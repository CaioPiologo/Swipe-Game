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
    var type:Int
    
    convenience init(direction:Direction, type:Int, imageNamed:String) {
        let color = UIColor()
        let texture = SKTexture(imageNamed: imageNamed)
        //TODO: ajustar tamanho da seta
        let size = CGSizeMake(texture.size().width/2, texture.size().height/2)
        self.init(texture: texture, color: color, size: size, direction:direction, type:type)
        self.physicsBody = SKPhysicsBody(rectangleOfSize: self.size)
        self.physicsBody!.categoryBitMask = PhysicsCategory.arrow
        self.physicsBody!.contactTestBitMask = PhysicsCategory.dangerZone | PhysicsCategory.endZone
        self.physicsBody!.collisionBitMask = 0
        self.physicsBody!.dynamic = false
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(texture: SKTexture!, color: UIColor!, size: CGSize, direction:Direction, type:Int) {
        self.direction = direction
        self.type = type
        super.init(texture: texture, color: color, size: size)
    }
    
    func update(speed:CGFloat, queue:Queue<Arrow>){
        self.position.y -= speed * self.size.height
    /*    if(self.position.y < self.size.height * 0.5){
            var destroy = SKAction.removeFromParent()
            self.runAction(destroy)
            queue.pop()
        }*/
    }
}
