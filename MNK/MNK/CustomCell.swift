import UIKit

class CustomCell: UICollectionViewCell {
    static let identifier = "CustomCell"
    
    private lazy var label: UILabel = {
        let label = UILabel()
        label.contentMode = .scaleAspectFill
        label.clipsToBounds = true
        label.backgroundColor = UIColor(named: "tup")
        label.textAlignment = .center
        label.layer.cornerRadius = 12
        label.layer.borderColor = UIColor(named: "border")?.cgColor
        label.layer.borderWidth = 1
        return label
    }()
    
    func showCross(size: Int) {
        label.text = "X"
        label.font = UIFont(name: "HelveticaNeue-Bold", size: CGFloat(220 / size))
        label.textColor = UIColor(named: "cross")
    }
    
    func showZero(size: Int) {
        label.text = "O"
        label.font = UIFont(name: "HelveticaNeue-Bold", size: CGFloat(220 / size))
        label.textColor = UIColor(named: "zero")
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(label)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        label.frame = contentView.bounds
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        label.text = nil
    }
}
