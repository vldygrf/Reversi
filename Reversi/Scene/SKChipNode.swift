//
//  ChipNode.swift
//  Reversi
//
//  Created by Vladislav Garifulin on 01.01.2021.
//

import SpriteKit

final class SKChipNode: SKSpriteNode {
    var square: Square {
        didSet {
            let texture = SKTexture(imageNamed: "chip\(self.square.resource())")
            self.texture = texture
        }
    }
    
    required init(square: Square) {
        self.square = square
        let texture = SKTexture(imageNamed: "chip\(self.square.resource())")
        super.init(texture: texture, color: UIColor.clear, size: texture.size())
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


