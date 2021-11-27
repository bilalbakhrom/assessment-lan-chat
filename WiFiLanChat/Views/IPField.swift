//
//  IPField.swift
//  WiFiLanChat
//
//  Created by Bilol Mamadjanov on 27/11/21.
//

import UIKit

protocol IPFieldDelegate: AnyObject {
    func didChangeHost(_ host: String)
    func didPasteHost(_ host: String)
}

class IPField: UIView {
    private let dwgConst = DrawingConstants()
    weak var delegate: IPFieldDelegate?
    
    private(set) lazy var ipFields: [UITextField] = {
        build(count: 4)
    }()
    
    private lazy var stackView: UIStackView = {
        let view = UIStackView()
        view.axis = .horizontal
        view.distribution = .fillEqually
        view.spacing = dwgConst.inputSpacing
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    // MARK: - Initializers
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init(coder: NSCoder) {
        fatalError()
    }
    
    private var host: String {
        ipFields.compactMap { $0.text }.joined()
    }
    
    func deleteBackward(_ sender: UITextField) {
        guard sender.text == nil || sender.text!.isEmpty else {
            delegate?.didChangeHost(host)
            return
        }
        ipFields[index(before: sender)].text?.removeLast()
        ipFields[index(before: sender)].becomeFirstResponder()
        delegate?.didChangeHost(host)
    }
}

extension IPField: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if string.contains(".") {
            
        }
        
        // If user pressed "delete" button
        if string.isBackSpace {
            return true
        }
        // Get full text
        let text = textField.text ?? ""
        let newString = (text as NSString).replacingCharacters(in: range, with: string)
        let characterSet = CharacterSet(charactersIn: newString)
        // Check if text consists of digits
        guard CharacterSet.decimalDigits.isSuperset(of: characterSet) else { return false }
        update(textField, with: newString)
        // Prompt delegate about code change
        delegate?.didChangeHost(host)
        // Prompt delegate if code is full
        if host.count == ipFields.count {
            delegate?.didPasteHost(host)
        }
        // TextField changed manually
        return false
    }
}

// MARK: - Support
extension IPField {
    var hasFocusedField: Bool {
        !(ipFields.filter { $0.isFirstResponder }.isEmpty)
    }
    
    /// Makes given amount of TextFields
    /// - Parameter count: The count of TextField
    /// - Returns: Returns array of TextFields
    private func build(count: Int) -> [TextField] {
        let range = (0..<count)
        return range.map { _ in
            let textField = TextField()
            textField.font = .systemFont(ofSize: 16)
            textField.textColor = .primaryTextColor
            textField.keyboardType = .numberPad
            textField.textAlignment = .center
            textField.backgroundColor = .primaryBackgroundColor
            textField.layer.borderWidth = 1.0
            textField.layer.borderColor = UIColor.white.cgColor
            textField.layer.cornerRadius = 8
            textField.delegate = self
            textField.translatesAutoresizingMaskIntoConstraints = false
            textField.onDeleteBackward = { [weak self] sender in
                self?.deleteBackward(sender)
            }
            
            return textField
        }
    }
    
    /// Fills TextField text with given code
    /// - Parameter code: The text code
    private func fill(with code: String) {
        let digits = Array(code).map { String($0) }
        digits.enumerated().forEach { index, digit in
            ipFields[index].text = digit
        }
    }
    
    /// Returns the position immediately before the given textField
    /// - Parameter textField: Instance of TextField
    /// - Returns: The index immediately before textField
    private func index(before textField: UITextField) -> Int {
        // Get index of current TextField
        let i = ipFields.firstIndex(of: textField)!
        // Previous index
        return (i == ipFields.startIndex) ? i : ipFields.index(before: i)
    }
    
    /// Returns the position immediately after the given textField
    /// - Parameter textField: Instance of TextField
    /// - Returns: The index immediately after textField
    private func index(after textField: UITextField) -> Int {
        // Get current TextField index
        let i = ipFields.firstIndex(of: textField)!
        // Get next TextField index
        return (i == ipFields.count-1) ? i : ipFields.index(after: i)
    }
    
    /// Updates text in cubic fields
    /// - Parameters:
    ///   - textField: The expected TextField to be updated
    ///   - text: The text to update
    private func update(_ textField: UITextField, with text: String) {
        if text.count <= 3 {
            textField.text = text
        }
        else {
            let index = index(after: textField)
            // Update next TextField text
            ipFields[index].text = String(text.last!)
        }
        
        if text.count == 3 {
            updateFirstResponderField()
        }
    }
    
    /// Updates first responder TextField
    private func updateFirstResponderField() {
        // Should get TextField with empty text
        let textField = ipFields.first { $0.text == nil || $0.text!.isEmpty }
        // Store last TextField
        let lastField = ipFields.last!
        
        // Check if textField exists
        if let textField = textField {
            textField.becomeFirstResponder()
        } else {
            lastField.becomeFirstResponder()
        }
    }
    
    private func canBecomeFocusedField(_ textField: UITextField) -> Bool {
        // Should get TextField with empty text
        let emptyField = ipFields.first { $0.text == nil || $0.text!.isEmpty }
        // Store last TextField
        let lastField = ipFields.last!
        
        if let emptyField = emptyField {
            return emptyField == textField
        } else {
            return lastField == textField
        }
    }
}

// MARK: - Constants

extension IPField {
    private struct DrawingConstants {
        let inputSpacing: CGFloat = 8
        let boxSize = CGSize(width: 60, height: 36)
    }
}

// MARK: - Layout
extension IPField {
    private func setup() {
        embedSubviews()
        setSubviewsConstraints()
    }
    
    private func embedSubviews() {
        addSubview(stackView)
        ipFields.forEach { stackView.addArrangedSubview($0) }
    }
    
    private func setSubviewsConstraints() {
        setIPFieldsConstraints()
        setStackViewConstraints()
    }
    
    private func setIPFieldsConstraints() {
        ipFields.forEach {
            NSLayoutConstraint.activate([
                $0.heightAnchor.constraint(equalToConstant: dwgConst.boxSize.height),
                $0.widthAnchor.constraint(equalToConstant: dwgConst.boxSize.width)
            ])
        }
    }
    
    private func setStackViewConstraints() {
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: topAnchor),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}
