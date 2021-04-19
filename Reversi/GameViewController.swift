//
//  GameViewController.swift
//  Reversi
//
//  Created by Vladislav Garifulin on 01.01.2021.
//

import UIKit
import SpriteKit
import GameplayKit

final class GameViewController: UIViewController {
    let scene = GameScene(size: CGSize.zero)
    
    override func loadView() {
        self.view = SKView()
    }
    
    func view() -> SKView {
        return view as! SKView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        scene.anchorPoint = CGPoint(x: 0.0, y: 0.0)
        view().presentScene(scene)
        view().showsFPS = true
        view().showsNodeCount = true
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        scene.size = CGSize(width: view.bounds.size.width, height: view.bounds.size.height)
    }

    override var shouldAutorotate: Bool {
        return true
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .allButUpsideDown
        } else {
            return .all
        }
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
}
