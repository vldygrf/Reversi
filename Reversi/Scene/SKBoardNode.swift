//
//  SKBoardNode.swift
//  Reversi
//
//  Created by Vladislav Garifulin on 05.01.2021.
//

import SpriteKit

final class SKBoardNode: SKNode {
    var size: CGSize? {
        didSet {
            resize()
        }
    }
    
    var board: BoardProtocol {
        didSet {
            resize()
        }
    }
    
    private var squareWidth: CGFloat = 0.0
    private var squareHeight: CGFloat = 0.0
    
    required init(board: Board, size: CGSize?) {
        self.board = board
        super.init()
        self.size = size
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func resize() {
        guard let size = size else { return }
        
        removeAllChildren()
        var x: CGFloat, y: CGFloat = 0.0
            
        squareWidth = size.width / CGFloat(board.cols)
        squareHeight = size.height / CGFloat(board.rows)
            
        var chip: SKChipNode
        for row in 1...board.rows {
            x = 0.0
            for col in 1...board.cols {
                chip = SKChipNode(square: board[row, col])
                chip.size = CGSize(width: squareWidth, height: squareHeight)
                chip.position = CGPoint(x: x + squareWidth / 2.0, y: y + squareHeight / 2.0)
                addChild(chip)
                x += squareWidth
            }
                
            y += squareHeight
        }
    }
    
    func applyBoard() {
        DispatchQueue.main.async { [self] in
            var index = 0
            for row in 1...board.rows {
                for col in 1...board.cols {
                    if let child = children[index] as? SKChipNode/*, child.square != board[row, col]*/ {
                        child.square = board[row, col]
                    }
                        
                    index += 1
                }
            }
        }
    }
    
    subscript(row: Int, col: Int) -> SKChipNode? {
        let index = (row - 1) * board.cols + (col - 1)
        return children[index] as? SKChipNode
    }
    
    func boardPoint(touchPoint: CGPoint) -> BP {
        let bp = BP(Int(touchPoint.y / squareHeight) + 1, Int(touchPoint.x / squareWidth) + 1)
        return bp
    }
}
