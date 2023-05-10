import UIKit

class BoardViewController: UIViewController {
    private enum Constants {
        static let reuseIdentifier = "Cell"

        enum State {
            case cross, zero, empty
        }
    }

    private var gameModel: GameModel
    private var boardState: [Constants.State]
    private var turn: Constants.State
    private var score = (0, 0)
    private var firstTurn: Constants.State
    private var waitNextRound = false

    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = UIColor(named: "background")
        return collectionView
    }()

    private lazy var restartButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = UIColor(named: "button")
        button.setTitle("Начать заново", for: .normal)
        button.setTitleColor(UIColor(named: "gray"), for: .normal)
        button.titleLabel?.font = UIFont(name: "HelveticaNeue-Bold", size: 16)
        button.layer.cornerRadius = 10
        button.addTarget(self, action: #selector(didTapRestartButton), for: .touchUpInside)
        return button
    }()

    private lazy var restartScoreButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = UIColor(named: "button")
        button.setTitle("Обнулить счет", for: .normal)
        button.setTitleColor(UIColor(named: "gray"), for: .normal)
        button.titleLabel?.font = UIFont(name: "HelveticaNeue-Bold", size: 16)
        button.layer.cornerRadius = 10
        button.addTarget(self, action: #selector(didTapRestartScoreButton), for: .touchUpInside)
        return button
    }()

    private lazy var crossScoreLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.contentMode = .scaleAspectFill
        label.clipsToBounds = true
        label.textAlignment = .center
        label.text = "0"
        label.textColor = UIColor(named: "border")
        label.font = UIFont(name: "HelveticaNeue-Bold", size: 50)
        return label
    }()

    private lazy var crossLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.contentMode = .scaleAspectFill
        label.clipsToBounds = true
        label.textAlignment = .center
        label.text = "X"
        label.font = UIFont(name: "HelveticaNeue-Bold", size: 50)
        label.textColor = UIColor(named: "cross")
        return label
    }()

    private lazy var zeroScoreLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.contentMode = .scaleAspectFill
        label.clipsToBounds = true
        label.textAlignment = .center
        label.text = "0"
        label.textColor = UIColor(named: "border")
        label.font = UIFont(name: "HelveticaNeue-Bold", size: 50)
        return label
    }()

    private lazy var zeroLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.contentMode = .scaleAspectFill
        label.clipsToBounds = true
        label.textAlignment = .center
        label.text = "O"
        label.font = UIFont(name: "HelveticaNeue-Bold", size: 50)
        label.textColor = UIColor(named: "zero")
        return label
    }()

    private lazy var nextTurnLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.contentMode = .scaleAspectFill
        label.clipsToBounds = true
        label.textAlignment = .center
        label.font = UIFont(name: "HelveticaNeue-Bold", size: 24)
        return label
    }()

    private lazy var turnLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.contentMode = .scaleAspectFill
        label.clipsToBounds = true
        label.textAlignment = .center
        label.text = "Ходит:"
        label.font = UIFont(name: "HelveticaNeue-Bold", size: 16)
        label.textColor = UIColor(named: "button")
        return label
    }()

    private lazy var wasSelectedLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.contentMode = .scaleAspectFill
        label.clipsToBounds = true
        label.textAlignment = .center
        label.font = UIFont(name: "HelveticaNeue-Bold", size: 16)
        label.textColor = UIColor(named: "button")
        return label
    }()

    init(gameModel: GameModel) {
        self.gameModel = gameModel
        boardState = Array(repeating: Constants.State.empty, count: gameModel.m * gameModel.n)
        switch gameModel.turn {
        case .cross:
            turn = .cross
        case .zero:
            turn = .zero
        }
        firstTurn = turn
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(named: "background")

        configureScore()
        configureTurn()
        configureCollectionView()
        configureButtons()
        congigWasSelected()
        updateNextTurnLabel()
    }

    private func configureCollectionView() {
        collectionView.register(CustomCell.self, forCellWithReuseIdentifier: CustomCell.identifier)
        setCollectionViewDelegates()

        view.addSubview(collectionView)
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: nextTurnLabel.bottomAnchor, constant: 12),
            collectionView.heightAnchor.constraint(equalToConstant: 480),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
        ])
    }

    private func configureButtons() {
        view.addSubview(restartButton)
        view.addSubview(restartScoreButton)
        NSLayoutConstraint.activate([
            restartButton.topAnchor.constraint(equalTo: collectionView.bottomAnchor, constant: 30),
            restartButton.heightAnchor.constraint(equalToConstant: 50),
            restartButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            restartButton.trailingAnchor.constraint(equalTo: view.centerXAnchor, constant: -5),

            restartScoreButton.topAnchor.constraint(equalTo: collectionView.bottomAnchor, constant: 30),
            restartScoreButton.heightAnchor.constraint(equalToConstant: 50),
            restartScoreButton.leadingAnchor.constraint(equalTo: view.centerXAnchor, constant: 5),
            restartScoreButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
        ])
    }

    private func configureScore() {
        view.addSubview(crossLabel)
        view.addSubview(crossScoreLabel)
        view.addSubview(zeroLabel)
        view.addSubview(zeroScoreLabel)
        NSLayoutConstraint.activate([
            crossLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 8),
            crossLabel.widthAnchor.constraint(equalToConstant: 70),
            crossLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 10),
            crossLabel.heightAnchor.constraint(equalToConstant: 70),

            crossScoreLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 10),
            crossScoreLabel.heightAnchor.constraint(equalToConstant: 70),
            crossScoreLabel.trailingAnchor.constraint(equalTo: view.centerXAnchor, constant: -10),
            crossScoreLabel.widthAnchor.constraint(equalToConstant: 70),

            zeroLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -8),
            zeroLabel.widthAnchor.constraint(equalToConstant: 70),
            zeroLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 10),
            zeroLabel.heightAnchor.constraint(equalToConstant: 70),

            zeroScoreLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 10),
            zeroScoreLabel.heightAnchor.constraint(equalToConstant: 70),
            zeroScoreLabel.leadingAnchor.constraint(equalTo: view.centerXAnchor, constant: 10),
            zeroScoreLabel.widthAnchor.constraint(equalToConstant: 70),
        ])
    }

    private func configureTurn() {
        view.addSubview(turnLabel)
        view.addSubview(nextTurnLabel)
        NSLayoutConstraint.activate([
            turnLabel.topAnchor.constraint(equalTo: zeroScoreLabel.bottomAnchor, constant: 8),
            turnLabel.heightAnchor.constraint(equalToConstant: 16),
            turnLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: -12),

            nextTurnLabel.centerYAnchor.constraint(equalTo: turnLabel.centerYAnchor),
            nextTurnLabel.heightAnchor.constraint(equalToConstant: 20),
            nextTurnLabel.leadingAnchor.constraint(equalTo: turnLabel.trailingAnchor, constant: 6),
            nextTurnLabel.widthAnchor.constraint(equalToConstant: 20),
        ])
    }

    private func congigWasSelected() {
        view.addSubview(wasSelectedLabel)
        NSLayoutConstraint.activate([
            wasSelectedLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            wasSelectedLabel.topAnchor.constraint(equalTo: collectionView.bottomAnchor, constant: 4),
            wasSelectedLabel.heightAnchor.constraint(equalToConstant: 16),
        ])
    }

    private func setCollectionViewDelegates() {
        collectionView.delegate = self
        collectionView.dataSource = self
    }

    @objc private func didTapRestartButton() {
        boardState = Array(repeating: Constants.State.empty, count: gameModel.m * gameModel.n)
        collectionView.reloadData()
        gameModel.board = TicTacBoard(m: gameModel.m, n: gameModel.n, k: gameModel.k)
        if gameModel.player1 is HumanPlayer,
           gameModel.player2 is HumanPlayer
        {
            if gameModel.turn == .cross {
                gameModel.turn = .zero
                turn = .zero
            } else {
                gameModel.turn = .cross
                turn = .cross
            }
            updateNextTurnLabel()
        }
        turnLabel.text = "Ходит:"
        waitNextRound = false
    }

    @objc private func didTapRestartScoreButton() {
        score = (0, 0)
        updateScoreLabel()
        didTapRestartButton()
    }

    private func updateScoreLabel() {
        crossScoreLabel.text = String(score.0)
        zeroScoreLabel.text = String(score.1)
    }

    private func updateNextTurnLabel() {
        switch turn {
        case .zero:
            nextTurnLabel.text = "O"
            nextTurnLabel.textColor = UIColor(named: "zero")
        case .cross:
            nextTurnLabel.text = "X"
            nextTurnLabel.textColor = UIColor(named: "cross")
        case .empty:
            break
        }
    }

    private func updateResult(result: GameResult) {
        switch result {
        case .draw:
            turnLabel.text = "  Ничья"
            nextTurnLabel.text = ""
        case .loose:
            turnLabel.text = "Победили:"
            if turn == .zero {
                nextTurnLabel.text = "X"
                nextTurnLabel.textColor = UIColor(named: "cross")
                score.0 += 1
            } else {
                nextTurnLabel.text = "O"
                nextTurnLabel.textColor = UIColor(named: "zero")
                score.1 += 1
            }
            waitNextRound = true
        case .win:
            turnLabel.text = "Победили:"
            if turn == .cross {
                nextTurnLabel.text = "X"
                nextTurnLabel.textColor = UIColor(named: "cross")
                score.0 += 1
            } else {
                nextTurnLabel.text = "O"
                nextTurnLabel.textColor = UIColor(named: "zero")
                score.1 += 1
            }
            waitNextRound = true
        case .unknown:
            nextTurn()
        }
        updateScoreLabel()
    }
}

extension BoardViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_: UICollectionView, numberOfItemsInSection _: Int) -> Int {
        return gameModel.n * gameModel.m
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CustomCell.identifier, for: indexPath)

        guard let cell = cell as? CustomCell else {
            return cell
        }

        switch boardState[indexPath.item] {
        case .empty:
            break
        case .zero:
            cell.showZero(size: gameModel.n)
        case .cross:
            cell.showCross(size: gameModel.n)
        }
        updateNextTurnLabel()
        wasSelectedLabel.text = ""

        return cell
    }

    func collectionView(_: UICollectionView, layout _: UICollectionViewLayout, sizeForItemAt _: IndexPath) -> CGSize {
        return CGSize(width: view.frame.size.width / CGFloat(gameModel.n) - 26 + 2 * CGFloat(gameModel.n),
                      height: view.frame.size.width / CGFloat(gameModel.n) - 26 + 2 * CGFloat(gameModel.n))
    }

    func collectionView(_: UICollectionView, layout _: UICollectionViewLayout, minimumInteritemSpacingForSectionAt _: Int) -> CGFloat {
        return 3
    }

    func collectionView(_: UICollectionView, layout _: UICollectionViewLayout, minimumLineSpacingForSectionAt _: Int) -> CGFloat {
        return 16
    }

    func collectionView(_: UICollectionView, layout _: UICollectionViewLayout, insetForSectionAt _: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 1,
                            left: 1,
                            bottom: 1,
                            right: 1)
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if waitNextRound {
            return
        }
        if boardState[indexPath.item] != .empty {
            wasSelected()
            return
        }
        boardState[indexPath.item] = turn
        collectionView.reloadItems(at: [indexPath])
        makeMove(row: indexPath.item / gameModel.n, col: indexPath.item % gameModel.n)
    }

    private func makeMove(row: Int, col: Int) {
        var player: Player
        var rival: Player
        if turn == .cross && gameModel.turn == .cross
            || turn == .zero && gameModel.turn == .zero
        {
            player = gameModel.player1
            rival = gameModel.player2
        } else {
            player = gameModel.player2
            rival = gameModel.player1
        }
        if var player = player as? HumanPlayer {
            player.updateTurn(row: row, col: col)
            let move = player.makeMove(position: gameModel.board.getPosition())
            let gameResult = gameModel.board.makeMove(move: move)
            updateResult(result: gameResult)

            guard let rival = rival as? RandomPlayer else {
                return
            }
            if waitNextRound {
                return
            }
            let moveRival = rival.makeMove(position: gameModel.board.getPosition())
            let resultRival = gameModel.board.makeMove(move: moveRival)
            let indexPath = IndexPath(item: moveRival.row * gameModel.n + moveRival.col, section: 0)
            boardState[indexPath.item] = turn
            updateResult(result: resultRival)

            updateNextTurnLabel()
            collectionView.reloadItems(at: [indexPath])
            turn = firstTurn
        }
    }

    private func wasSelected() {
        if waitNextRound {
            return
        }
        wasSelectedLabel.text = "Данная клетка уже занята"
    }

    private func nextTurn() {
        if turn == .cross {
            turn = .zero
        } else {
            turn = .cross
        }
        updateNextTurnLabel()
    }
}
