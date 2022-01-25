//
//  TicToeGameControl.swift
//  Lab1_HarpreetKaur_C0636891_iOS
//
//  Created by Harpreet on 18/01/22.
//

import Foundation

class ScoreManager {
    
    //MARK:- If Game is Draw
    private var markedCount = 0
    private var scoreList = [Game.Player.O: Score(), Game.Player.X: Score()]
    
    //MARK:- Current Move is winning move
    func isWinningMove(player: Game.Player, position pos: (x: Int, y: Int)) -> Game.Status {
        markedCount += 1

        if checkHAndVWins(in: scoreList[player] ?? Score(), pos: pos)
            || checkDiagonalWins(in: scoreList[player] ?? Score(), pos: pos) {
            return Game.Status.Won
        }
        //MARK:- check if game is a draw
        if markedCount > 8 {
            return Game.Status.Draw
        }
        
        return Game.Status.Active
    }
    
    //MARK:- reset scores
    func reset() {
        markedCount = 0
        for scoreItem in scoreList.values {
            scoreItem.reset()
        }
    }
   
    private func checkHAndVWins(in score: Score, pos:(x: Int, y: Int)) -> Bool {
        score.column[pos.x] = (score.column[pos.x] ?? 0) + 1
        score.row[pos.y] = (score.row[pos.y] ?? 0) + 1
        
        guard let col = score.column[pos.x], col < Game.Board.Size, let row = score.row[pos.y], row < Game.Board.Size else {
            return true
        }
        
        return false
    }
    
   
    private func checkDiagonalWins(in score: Score, pos:(x: Int, y: Int)) -> Bool {
        score.diagonal[0] = (score.diagonal[0] ?? 0)
        score.diagonal[1] = (score.diagonal[1] ?? 0)
        
        if pos.x == pos.y {
            score.diagonal[0] = (score.diagonal[0] ?? 0) + 1
        }
        if (Game.Board.Size - pos.x - 1) == pos.y { 
            score.diagonal[1] = (score.diagonal[1] ?? 0) + 1
        }
        
        guard let diagOne = score.diagonal[0], diagOne < Game.Board.Size, let diagTwo = score.diagonal[1], diagTwo < Game.Board.Size else {
            return true
        }
        
        return false
    }
}

class GameManager {
    
    private let gameBoard = GameBoard()
    private let scoreManager = ScoreManager()
    private var gameStatus = Game.Status.Active
    private(set) public var currentPlayer = Game.Player.O
    private(set) public var session = GameSession()
    
    //MARK:- CallBacks Function
    var onGameStatusUpdate: (Game.Status)->() = { status in
        print(status)
    }
    
    func startNewGame() {
        gameBoard.reset()
        scoreManager.reset()
        currentPlayer = currentPlayer.flip()
        gameStatus = Game.Status.Active
        onGameStatusUpdate(gameStatus)
    }
    func ResetSingleVlaue(){
       
    }
    
    func makeMove(at index: Int) -> Bool {
        
        guard gameStatus == .Active else {
            return false
        }
        
        if gameBoard.markGridItem(at: index, with: currentPlayer) {
            let position = gameBoard.get2DPosition(from: index)
            gameStatus = scoreManager.isWinningMove(player: currentPlayer, position: position)
            updateSession(status: gameStatus)
            onGameStatusUpdate(gameStatus)
            return true
        }
        
        return false
    }
    
    private func updateSession(status: Game.Status) {
        switch status {
        case .Draw:
            session.draws += 1
        case .Won:
            session.wins[currentPlayer]? += 1
        case .Active:
            currentPlayer = currentPlayer.flip()
            return
        }
    }
}
