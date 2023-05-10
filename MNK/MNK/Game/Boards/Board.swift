public protocol Board {
    func getPosition() -> Position

    mutating func makeMove(move: Move) -> GameResult

    func toString() -> String
}
