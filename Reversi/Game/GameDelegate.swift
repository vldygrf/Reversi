//
//  GameDelegate.swift
//  Reversi
//
//  Created by Vladislav Garifulin on 19.04.2021.
//

import Foundation

protocol GameDelegate: AnyObject {
    func animate(move: BP, color: Square, completion: @escaping () -> Void)
    func didMove()
    var animationIsActive: Bool { get }
}
