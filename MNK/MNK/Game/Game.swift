public struct Game {
    private var board: Board
    private let player1: Player
    private let player2: Player
    
    init(board: Board, player1: Player, player2: Player) {
        self.board = board
        self.player1 = player1
        self.player2 = player2
    }
    
    mutating func play() -> Int {
        while true {
            let result1 = makeMove(player: player1, no: 1)
            if result1 != -1 {
                return result1
            }
            let result2 = makeMove(player: player2, no: 2)
            if result2 != -1 {
                return result2
            }
        }
    }
    
    private mutating func makeMove(player: Player, no: Int) -> Int {
        let move = player.makeMove(position: board.getPosition())
        let gameResult = board.makeMove(move: move)
        print("-----------------")
        print("Player \(no)")
        print(move.toString())
        print(board.toString())
        print("Result \(gameResult)")
    
        
        switch gameResult {
        case .win:
            return no
        case .loose:
            return 3 - no
        case .draw:
            return 0
        case .unknown:
            return -1
        }
    }
}
