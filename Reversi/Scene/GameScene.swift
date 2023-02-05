//
//  GameScene.swift
//  Reversi
//
//  Created by Vladislav Garifulin on 01.01.2021.
//

import SpriteKit
import GameplayKit

final class GameScene: SKScene {
    override var size: CGSize {
        get {
            return super.size
        }
        set(newSize) {
            super.size = newSize
            let min = size.width < size.height ? size.width : size.height
            self.boardNode.size = CGSize(width: min, height: min)
            self.boardNode.position = CGPoint(x: (size.width - min) / 2.0, y: (size.height - min) / 2.0)
        }
    }
    private var boardNode: SKBoardNode
    private var game: Game
    
    required override init(size: CGSize) {
        let board = Board(rows: 8, cols: 8, defaultValue: .empty)
        let rules = Rules(board: board)
        let blackPlayer = Player(rules: rules)
        let whitePlayer = PlayerMachine(rules: rules, level: .l4)
        self.game = Game(rules: rules, blackPlayer: blackPlayer, whitePlayer: whitePlayer)
        self.boardNode = SKBoardNode(board: board, game: self.game, size: nil)
        super.init(size: size)
        
        self.game.delegate = self
        self.addChild(self.boardNode)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func touchDown(atPoint pos: CGPoint) {

    }
    
    func touchMoved(toPoint pos: CGPoint) {

    }
    
    func touchUp(atPoint pos: CGPoint) {
        guard self.game.waitingForTouch() else { return }
        let bp = self.boardNode.boardPoint(touchPoint: pos)
        if self.game.rules.board.within(bp: bp) && self.game.canTake(move: bp) {
            self.game.take(move: bp)
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {        
        for t in touches { self.touchDown(atPoint: t.location(in: boardNode)) }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchMoved(toPoint: t.location(in: boardNode)) }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchUp(atPoint: t.location(in: boardNode)) }
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchUp(atPoint: t.location(in: boardNode)) }
    }
}

extension GameScene: GameDelegate {
    var animationIsActive: Bool {
        return self.boardNode.animationIsActive
    }
    
    func animate(move: BP, color: Square, completion: @escaping () -> Void) {
        self.boardNode.animate(move: move, color: color, completion: completion)
    }
    
    func didMove() {
        self.boardNode.applyBoard()
    }
}
