struct GameModel {
    enum StartTurn {
        case cross, zero
    }

    var m, n, k: Int
    var turn: StartTurn
    var player1, player2: Player
    var board: TicTacBoard
}
