public protocol Player {
    func makeMove(position: Position) -> Move
    
    var m: Int { get }
    var n: Int { get }
    
    init(m: Int, n: Int)
}
