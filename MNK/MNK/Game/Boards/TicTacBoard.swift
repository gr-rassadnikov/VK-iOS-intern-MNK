public struct TicTacBoard: Board, Position {
    private var field: [[CellGame]]
    private var turn: CellGame
    private let m: Int
    private let n: Int
    private let k: Int
    private var cntEmpty: Int

    public init(m: Int, n: Int, k: Int) {
        field = [[CellGame]](repeating: Array(repeating: CellGame.e, count: n), count: m)
        turn = CellGame.x
        self.m = m
        self.n = n
        self.k = k
        cntEmpty = m * n
    }

    public func getTurn() -> CellGame {
        return turn
    }

    public func getPosition() -> Position {
        return self
    }

    public mutating func makeMove(move: Move) -> GameResult {
        if !isValid(move: move) {
            return .loose
        }
        field[move.row][move.col] = move.value
        cntEmpty -= 1
        if cntEmpty <= 0 {
            return .draw
        }
        if checkWin(move: move) {
            return .win
        }
        turn = turn == .x ? .o : .x
        return .unknown
    }

    public func isValid(move: Move) -> Bool {
        return move.row >= 0 && move.row < m
            && move.col >= 0 && move.col < n
            && field[move.row][move.col] == .e
            && move.value == turn
    }

    private func checkWin(move: Move) -> Bool {
        return checkIsRowWin(move: move)
            || checkIsColWin(move: move)
            || checkIsDiagNormalWin(move: move)
            || checkIsDiagUnNormalWin(move: move)
    }

    private func checkIsRowWin(move: Move) -> Bool {
        var cntRow = -1
        for i in move.row ..< m {
            if field[i][move.col] != turn {
                break
            }
            cntRow += 1
        }
        for i in stride(from: move.row, through: 0, by: -1) {
            if field[i][move.col] != turn {
                break
            }
            cntRow += 1
        }
        return cntRow >= k
    }

    private func checkIsColWin(move: Move) -> Bool {
        var cntCol = -1
        for i in move.col ..< n {
            if field[move.row][i] != turn {
                break
            }
            cntCol += 1
        }
        for i in stride(from: move.col, through: 0, by: -1) {
            if field[move.row][i] != turn {
                break
            }
            cntCol += 1
        }
        return cntCol >= k
    }

    private func checkIsDiagNormalWin(move: Move) -> Bool {
        var cntDiagNormal = -1
        var i = 0
        while move.row + i < m, move.col + i < n {
            if field[move.row + i][move.col + i] != turn {
                break
            }
            cntDiagNormal += 1
            i += 1
        }
        i = 0
        while move.row - i >= 0, move.col - i >= 0 {
            if field[move.row - i][move.col - i] != turn {
                break
            }
            cntDiagNormal += 1
            i += 1
        }
        return cntDiagNormal >= k
    }

    private func checkIsDiagUnNormalWin(move: Move) -> Bool {
        var cntDiagUnNormal = -1
        var i = 0
        while move.row + i < m, move.col - i >= 0 {
            if field[move.row + i][move.col - i] != turn {
                break
            }
            cntDiagUnNormal += 1
            i += 1
        }
        i = 0
        while move.row - i >= 0, move.col + i < n {
            if field[move.row - i][move.col + i] != turn {
                break
            }
            cntDiagUnNormal += 1
            i += 1
        }
        return cntDiagUnNormal >= k
    }

    public func toString() -> String {
        var str = ""
        for line in field {
            for e in line {
                str = str + e.rawValue
            }
            str += "\n"
        }
        return str
    }
}
