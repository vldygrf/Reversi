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
            self.resize()
        }
    }
    
    private var board: BoardProtocol {
        didSet { 
            self.resize()
        }
    }
    
    private var game: GameProtocol
    private var chips: [SKChipNode] = []
    private var squareWidth: CGFloat = 0.0
    private var squareHeight: CGFloat = 0.0
    private var animationTextures: [SKTexture] = []
    private(set) var animationIsActive = false
    
    required init(board: Board, game: GameProtocol, size: CGSize?) {
        self.board = board
        self.game = game
        for i in 0..<36 {
            self.animationTextures.append(SKTexture(imageNamed: "achip\(i)"))
        }
        super.init()
        self.size = size
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func removeAllChildren() {
        super.removeAllChildren()
        self.chips.removeAll()
    }
    
    @discardableResult private func addChip(square: Square, position: CGPoint) -> SKChipNode {
        let chip = SKChipNode(square: square)
        chip.size = CGSize(width: self.squareWidth, height: self.squareHeight)
        chip.position = CGPoint(x: position.x + self.squareWidth / 2.0, y: position.y + self.squareHeight / 2.0)
        self.addChild(chip)
        return chip
    }

    func resize() {
        guard let size = self.size else { return }
        
        self.removeAllChildren()
        var x: CGFloat, y: CGFloat = 0.0
            
        self.squareWidth = size.width / CGFloat(self.board.cols)
        self.squareHeight = size.height / CGFloat(self.board.rows)
            
        let rows = self.board.rows
        for _ in 1...rows {
            x = 0.0
            let cols = self.board.cols
            for _ in 1...cols {
                self.addChip(square: .empty, position: CGPoint(x: x, y: y))
                let chip = self.addChip(square: .empty, position: CGPoint(x: x, y: y))
                self.chips.append(chip)
                x += self.squareWidth
            }
            y += self.squareHeight
        }
        
        self.applyBoard()
    }
    
    func animate(move: BP, color: Square, completion: @escaping () -> Void) {
        let chipsToAnimate = self.game.toTake(move: move, color: color)
        self.animationIsActive = chipsToAnimate.count > 0
        guard self.animationIsActive else {
            completion()
            return
        }
        
        self.board[move.row, move.col] = color
        self.applyBoard()
        
        for chip in chipsToAnimate {
            self[chip.row, chip.col]?.run(SKAction.animate(with: color == .black ? self.animationTextures.reversed() : self.animationTextures, timePerFrame: 0.03), completion: { [weak self] in
                guard let self = self, chip == chipsToAnimate.last else { return }
                self.animationIsActive = false
                completion()
            })
        }
    }
    
    func applyBoard() {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            var index = 0
            let rows = self.board.rows
            for row in 1...rows {
                let cols = self.board.cols
                for col in 1...cols {
                    if self.board[row, col] == .empty {
                        self.chips[index].square = self.game.canTake(move: BP(row, col)) && self.game.playerToMove().touchable() ? self.game.moveColor.possible() : .empty
                    } else {
                        self.chips[index].square = self.board[row, col]
                    }
                    index += 1
                }
            }
        }
    }
    
    subscript(row: Int, col: Int) -> SKChipNode? {
        let index = (row - 1) * self.board.cols + (col - 1)
        guard index >= 0, self.chips.count > index else { return nil }
        return self.chips[index]
    }
    
    func boardPoint(touchPoint: CGPoint) -> BP {
        let bp = BP(Int(touchPoint.y / self.squareHeight) + 1, Int(touchPoint.x / self.squareWidth) + 1)
        return bp
    }
}
