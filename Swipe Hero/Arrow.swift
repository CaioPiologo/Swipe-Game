//
//  Arrow.swift
//  Swipe Hero
//
//  Created by Caio Vinícius Piologo Véras Fernandes on 6/17/15.
//  Copyright (c) 2015 Caio. All rights reserved.
//

import SpriteKit

enum Direction:Int {
    case UP = 0, RIGHT, DOWN, LEFT
}

class Arrow:SKNode {
    let direction:Direction
    
    init(direction:Direction) {
        self.direction = direction
        super.init()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

}
