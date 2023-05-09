import UIKit

class ViewController: UIViewController {
    private enum Constants {
        static let defaultM = 5
        static let defaultN = 4
        static let defaultK = 3
    }
    private var gameModel = GameModel(
        m: Constants.defaultM, n: Constants.defaultN, k:Constants.defaultK,
        turn: .cross,
        player1: HumanPlayer(m: Constants.defaultM, n: Constants.defaultN),
                                      player2: HumanPlayer(m: Constants.defaultM, n: Constants.defaultN),
                                      board: TicTacBoard(m: Constants.defaultM, n: Constants.defaultN, k: Constants.defaultK))
    private var rangeOfM = [3, 4, 5, 6, 7, 8]
    private var rangeOfN = [3, 4, 5]
    private var rangeOfK = [3, 4]

    private lazy var infoLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.contentMode = .scaleAspectFill
        label.clipsToBounds = true
        label.textAlignment = .center
        label.textColor = UIColor(named: "border")
        label.text = "Выберите высоту, ширину и количество элементов для выигрыша"
        label.numberOfLines = 0
        label.font = UIFont(name: "HelveticaNeue-Bold", size: 20)
        return label
    }()
    
    private lazy var pickerView = {
        let pickerView = UIPickerView()
        pickerView.translatesAutoresizingMaskIntoConstraints = false
        return pickerView
    }()
    
    private lazy var modeLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = UIColor(named: "border")
        label.text = "Режим"
        label.font = UIFont(name: "HelveticaNeue-Bold", size: 20)
        return label
    }()
    
    private lazy var humansPlayerButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Вдвоем", for: .normal)
        button.backgroundColor = UIColor(named: "button")
        button.setTitleColor(UIColor(named: "gray"), for: .normal)
        button.titleLabel?.font = UIFont(name: "HelveticaNeue-Bold", size: 16)
        button.layer.cornerRadius = 10
        button.addTarget(self , action: #selector(didTapHumansPlayerButton), for: .touchUpInside)
        return button
    }()
    
    private lazy var computerPlayerButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("С компьютером", for: .normal)
        button.backgroundColor = UIColor(named: "tup")
        button.setTitleColor(UIColor(named: "gray"), for: .normal)
        button.titleLabel?.font = UIFont(name: "HelveticaNeue-Bold", size: 16)
        button.layer.cornerRadius = 10
        button.addTarget(self , action: #selector(didTapComputerPlayerButton), for: .touchUpInside)
        return button
    }()
    
    private lazy var chooseLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = UIColor(named: "border")
        label.text = "Первым ходит"
        label.font = UIFont(name: "HelveticaNeue-Bold", size: 20)
        return label
    }()
    
    private lazy var chooseCrossButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("X", for: .normal)
        button.backgroundColor = UIColor(named: "button")
        button.setTitleColor(UIColor(named: "cross"), for: .normal)
        button.titleLabel?.font = UIFont(name: "HelveticaNeue-Bold", size: 80)
        button.layer.cornerRadius = 10
        button.addTarget(self , action: #selector(didTapChooseCrossButton), for: .touchUpInside)
        return button
    }()
    
    private lazy var chooseZeroButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("O", for: .normal)
        button.backgroundColor = UIColor(named: "tup")
        button.setTitleColor(UIColor(named: "zero"), for: .normal)
        button.titleLabel?.font = UIFont(name: "HelveticaNeue-Bold", size: 80)
        button.layer.cornerRadius = 10
        button.addTarget(self , action: #selector(didTapChooseZeroButton), for: .touchUpInside)
        return button
    }()
    
    private lazy var startButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Начать", for: .normal)
        button.backgroundColor = UIColor(named: "button")
        button.setTitleColor(UIColor(named: "gray"), for: .normal)
        button.titleLabel?.font = UIFont(name: "HelveticaNeue-Bold", size: 20)
        button.layer.cornerRadius = 10
        button.addTarget(self , action: #selector(didTapStartButton), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(named: "background")
        configurePickerView()
        addSubViews()
        activateConstraints()
    }
    
    private func configurePickerView(){
        pickerView.dataSource = self
        pickerView.delegate =  self
        pickerView.selectRow(2, inComponent: 0, animated: true)
        pickerView.selectRow(1, inComponent: 1, animated: true)
        pickerView.selectRow(0, inComponent: 2, animated: true)
    }
    
    private func addSubViews(){
        view.addSubview(infoLabel)
        view.addSubview(pickerView)
        view.addSubview(modeLabel)
        view.addSubview(humansPlayerButton)
        view.addSubview(computerPlayerButton)
        view.addSubview(chooseLabel)
        view.addSubview(chooseCrossButton)
        view.addSubview(chooseZeroButton)
        view.addSubview(startButton)

    }
    
    private func activateConstraints() {
        NSLayoutConstraint.activate([
            infoLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 30),
            infoLabel.heightAnchor.constraint(equalToConstant: 80),
            infoLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            infoLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            pickerView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            pickerView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40),
            pickerView.topAnchor.constraint(equalTo: infoLabel.topAnchor, constant: 80),
            pickerView.heightAnchor.constraint(equalToConstant: 200),
            
            modeLabel.topAnchor.constraint(equalTo: pickerView.bottomAnchor, constant: 10),
            modeLabel.heightAnchor.constraint(equalToConstant: 30),
            modeLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            modeLabel.widthAnchor.constraint(equalToConstant: 100),
            
            humansPlayerButton.topAnchor.constraint(equalTo: modeLabel.bottomAnchor, constant: 10),
            humansPlayerButton.heightAnchor.constraint(equalToConstant: 50),
            humansPlayerButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            humansPlayerButton.trailingAnchor.constraint(equalTo: view.centerXAnchor, constant: -5),
            
            computerPlayerButton.topAnchor.constraint(equalTo: modeLabel.bottomAnchor, constant: 10),
            computerPlayerButton.heightAnchor.constraint(equalToConstant: 50),
            computerPlayerButton.leadingAnchor.constraint(equalTo: view.centerXAnchor, constant: 5),
            computerPlayerButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            chooseLabel.topAnchor.constraint(equalTo: computerPlayerButton.bottomAnchor, constant: 10),
            chooseLabel.heightAnchor.constraint(equalToConstant: 30),
            chooseLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            chooseLabel.widthAnchor.constraint(equalToConstant: 300),
            
        
            chooseCrossButton.topAnchor.constraint(equalTo: chooseLabel.bottomAnchor, constant: 10),
            chooseCrossButton.heightAnchor.constraint(equalToConstant: 100),
            chooseCrossButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            chooseCrossButton.trailingAnchor.constraint(equalTo: view.centerXAnchor, constant: -5),
            
            chooseZeroButton.topAnchor.constraint(equalTo: chooseLabel.bottomAnchor, constant: 10),
            chooseZeroButton.heightAnchor.constraint(equalToConstant: 100),
            chooseZeroButton.leadingAnchor.constraint(equalTo: view.centerXAnchor, constant: 5),
            chooseZeroButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            
            startButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            startButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            startButton.topAnchor.constraint(equalTo: chooseCrossButton.bottomAnchor, constant: 20),
            startButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    @objc func didTapStartButton() {
        gameModel.board = TicTacBoard(m: gameModel.m, n: gameModel.n, k: gameModel.k)
        let boardVC = BoardViewController(gameModel: gameModel)
        present(boardVC, animated: true, completion: nil)
    }
    
    @objc func didTapHumansPlayerButton() {
        humansPlayerButton.backgroundColor = UIColor(named: "button")
        computerPlayerButton.backgroundColor = UIColor(named: "tup")
        chooseLabel.text = "Первым ходит"
        gameModel.player2 = HumanPlayer(m: gameModel.m, n: gameModel.n)
    }
    
    @objc func didTapComputerPlayerButton() {
        humansPlayerButton.backgroundColor = UIColor(named: "tup")
        computerPlayerButton.backgroundColor = UIColor(named: "button")
        chooseLabel.text = "Играть за"
        gameModel.player2 = RandomPlayer(m: gameModel.m, n: gameModel.n)
    }
    
    @objc func didTapChooseCrossButton() {
        chooseCrossButton.backgroundColor = UIColor(named: "button")
        chooseZeroButton.backgroundColor = UIColor(named: "tup")
        gameModel.turn = .cross
    }
    
    @objc func didTapChooseZeroButton() {
        chooseZeroButton.backgroundColor = UIColor(named: "button")
        chooseCrossButton.backgroundColor = UIColor(named: "tup")
        gameModel.turn = .zero
    }



}

extension ViewController : UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 3
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch component {
        case 0:
            return rangeOfM.count
        case 1:
            return rangeOfN.count
        case 2:
            return rangeOfK.count
        default:
            return 0
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch component {
        case 0:
            return String(rangeOfM[row])
        case 1:
            return String(rangeOfN[row])
        case 2:
            return String(rangeOfK[row])
        default:
            return ""
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        switch component {
        case 0:
            gameModel.m = rangeOfM[row]
        case 1:
            gameModel.n = rangeOfN[row]
        case 2:
            gameModel.k = rangeOfK[row]
        default: break
        }
        updateArrays()
        pickerView.reloadAllComponents()
    }
    
    private func updateArrays(){
        if gameModel.m < gameModel.n {
            gameModel.n  = gameModel.m
        }
        rangeOfN = Array(3...gameModel.m)
        if gameModel.n < gameModel.k {
            gameModel.k = gameModel.n
        }
        rangeOfK = Array(3...gameModel.n)
    }
    
}
