import Foundation

public struct HumanPlayer: Player {
    public var m, n: Int
    var row = -1
    var col = -1

    public init(m: Int, n: Int) {
        self.m = m
        self.n = n
    }

    mutating func updateTurn(row: Int, col: Int) {
        self.row = row
        self.col = col
    }

    public func makeMove(position: Position) -> Move {
        let move = Move(
            row: row,
            col: col,
            value: position.getTurn()
        )
        return move
    }
}
