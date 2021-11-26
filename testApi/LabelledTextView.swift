//
//  LabelledTextView.swift
//  MDB Social
//
//  Created by Michael Lin on 2/25/21.
//

import UIKit

fileprivate let DEFAULT_FONT_SIZE: CGFloat = 15.0

final class LabelledTextView: UIView {

    let textField: UITextView = {
        let tf = UITextView()
        tf.backgroundColor = UIColor(hex: "#f7f7f7")
        tf.textColor = .primaryText
        tf.font = .systemFont(ofSize: DEFAULT_FONT_SIZE, weight: .medium)
        tf.autocorrectionType = .no
        tf.autocapitalizationType = .none
        
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }()
    
    let titleLabel: UILabel = {
        let lbl = UILabel()
        lbl.textColor = .secondaryText
        lbl.numberOfLines = 1
        lbl.textAlignment = .left
        lbl.font = .systemFont(ofSize: DEFAULT_FONT_SIZE-2, weight: .semibold)
        
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()
    
    var text: String? {
        get {
            return textField.text
        }
    }
    
    private var textFieldHeightConstraint: NSLayoutConstraint!
    
    init(frame: CGRect = .zero, title: String,lines: CGFloat) {
        super.init(frame: frame)
        setTitle(title: title)
        configure(lines: lines)
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        configure(lines: 1)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configure(lines: 1)
    }
    
    func setTitle(title: String) {
        titleLabel.text = title.uppercased()
        titleLabel.sizeToFit()
        
    }
    
    private func configure(lines: CGFloat) {

        addSubview(titleLabel)
        addSubview(textField)

        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            titleLabel.topAnchor.constraint(equalTo: topAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            textField.leadingAnchor.constraint(equalTo: leadingAnchor),
            textField.trailingAnchor.constraint(equalTo: trailingAnchor),
            textField.bottomAnchor.constraint(equalTo: bottomAnchor),
            titleLabel.bottomAnchor.constraint(equalTo: textField.topAnchor, constant: -5)
        ])
        
        let height = DEFAULT_FONT_SIZE * lines + 15
        textFieldHeightConstraint = textField.heightAnchor.constraint(
            equalToConstant: height)
        textFieldHeightConstraint.isActive = true
        textField.layer.cornerRadius = 15
    }
    
    private class TextField: UITextField {
        override func editingRect(forBounds bounds: CGRect) -> CGRect {
            return bounds.insetBy(dx: 20, dy: 0)
        }
        
        override func textRect(forBounds bounds: CGRect) -> CGRect {
            return bounds.insetBy(dx: 20, dy: 0)
        }
    }
}
