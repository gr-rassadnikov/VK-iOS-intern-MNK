import Foundation

public struct RandomPlayer : Player {
    public var m, n: Int
    
    public init(m: Int, n: Int) {
        self.m = m
        self.n = n
    }
    
    public func makeMove(position: Position) -> Move {

        while true {
            let move = Move(
                row: Int.random(in: 0..<m),
                col: Int.random(in: 0..<n),
                value: position.getTurn())
            if position.isValid(move: move) {
                return move
            }
        }
    }
}
