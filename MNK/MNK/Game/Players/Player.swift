public protocol Player {
    func makeMove(position: Position) -> Move

    var m: Int { get set }
    var n: Int { get set }

    init(m: Int, n: Int)
}
