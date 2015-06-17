//
//  Arrow.swift
//  Swipe Hero
//
//  Created by Caio Vinícius Piologo Véras Fernandes on 6/17/15.
//  Copyright (c) 2015 Caio. All rights reserved.
//
import SpriteKit

enum Direction:UInt32 {
    case UP, RIGHT, DOWN, LEFT
}

class Arrow:SKSpriteNode {
    
    var direction:Direction
    
    convenience init(direction:Direction, imageNamed:String) {
        let color = UIColor()
        let texture = SKTexture(imageNamed: imageNamed)
        let size = CGSizeMake(50.0, 50.0)
        self.init(texture: texture, color: color, size: size, direction:direction)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(texture: SKTexture!, color: UIColor!, size: CGSize, direction:Direction) {
        self.direction = direction
        super.init(texture: texture, color: color, size: size)
        self.position = CGPointMake(500, 500)
    }

}
