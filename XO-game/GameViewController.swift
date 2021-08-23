//
//  GameViewController.swift
//  XO-game
//
//  Created by Evgeny Kireev on 25/02/2019.
//  Copyright © 2019 plasmon. All rights reserved.
//

import UIKit

class GameViewController: UIViewController {

    @IBOutlet var gameboardView: GameboardView!
    @IBOutlet var firstPlayerTurnLabel: UILabel!
    @IBOutlet var secondPlayerTurnLabel: UILabel!
    @IBOutlet var winnerLabel: UILabel!
    @IBOutlet var restartButton: UIButton!
    
    var counter = 0
    var fiveMovesCounter = 0
    private let gameBoard = Gameboard()
    private lazy var referee = Referee(gameboard: gameBoard)
    
    private var currentState: PlayGameState! {
        didSet {
            currentState.begin()
        }
    }
    
    var computerIsSecondPlayer = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        firstPlayerTurn()
        if computerIsSecondPlayer {
            gameboardView.isComputerPlaying = true
        }
        
        gameboardView.onSelectPosition = { [weak self] position in
            guard let self = self else { return }
            
            self.fiveMovesCounter += 1
            
            self.currentState.addSign(at: position)
            self.counter += 1

            
            if self.currentState.isMoveCompleted {
                if !self.computerIsSecondPlayer {
                    self.nextPlayerTurn()
                } else {
                    self.nextComputerTurn()
                }
                
            }
        }
    }
    
    @IBAction func restartButtonTapped(_ sender: UIButton) {
        Logger.shared.log(action: .restartGame)
        
        gameboardView.clear()
        gameBoard.clear()
        counter = 0
        
        firstPlayerTurn()
    }
    
    private func firstPlayerTurn() {
        let firstPlayer: Player = .first
        
        let markView = getMarkView(player: firstPlayer)
        if computerIsSecondPlayer {
            currentState = PlayerGameState(player: firstPlayer,
                                           gameViewController: self,
                                           gameBoard: gameBoard,
                                           gameBoardView: gameboardView, markView: markView)
        } else {
            currentState = PlayersFiveMoveState(player: firstPlayer,
                                           gameViewController: self,
                                           gameBoard: gameBoard,
                                           gameBoardView: gameboardView, markView: markView)
        }
        
    }
    
    private func nextPlayerTurn() {
        if let winner = referee.determineWinner() {
            currentState = GameEndState(winnerPlayer: winner, gameViewController: self)
            return
        }
        
        if counter >= 9 {
            Logger.shared.log(action: .gameFinished(won: nil))
            currentState = GameEndState(winnerPlayer: nil, gameViewController: self)
            return
        }
        
        if let playerState = currentState as? PlayersFiveMoveState {
            let next = playerState.player.nextWithSecondPlayer
            let markView = getMarkView(player: next)
            currentState = PlayersFiveMoveState(player: next, gameViewController: self,
                                           gameBoard: gameBoard, gameBoardView: gameboardView, markView: markView)
        }
        
    }
    
    func nextComputerTurn() {
        if let winner = referee.determineWinner() {
            currentState = GameEndState(winnerPlayer: winner, gameViewController: self)
            return
        }

        if counter >= 9 {
            Logger.shared.log(action: .gameFinished(won: nil))
            currentState = GameEndState(winnerPlayer: nil, gameViewController: self)
            return
        }

        if let playerState = currentState as? PlayerGameState {
            let next = playerState.player.nextWithComputer
            let markView = getMarkView(player: next)
            currentState = PlayerGameState(player: next, gameViewController: self,
                                           gameBoard: gameBoard, gameBoardView: gameboardView, markView: markView)
        }
    }
    
    private func getMarkView(player: Player) -> MarkView {
        switch player {
        case .first:
            return XView()
        case .second:
            return OView()
        case .computer:
            return OView()
        }
    }
}

