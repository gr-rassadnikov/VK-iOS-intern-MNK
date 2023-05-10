public struct Move {
    private(set) var row: Int
    private(set) var col: Int
    private(set) var value: CellGame

    public init(row: Int, col: Int, value: CellGame) {
        self.row = row
        self.col = col
        self.value = value
    }

    func toString() -> String {
        return "Move \(value) \(row) \(col)}"
    }
}
