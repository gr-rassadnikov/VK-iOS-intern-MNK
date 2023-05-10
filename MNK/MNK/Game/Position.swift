public protocol Position {
    func getTurn() -> CellGame

    func isValid(move: Move) -> Bool
}
