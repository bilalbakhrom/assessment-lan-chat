//
//  BoxView.swift
//  WiFiLanChat
//
//  Created by Bilol Mamadjanov on 29/11/21.
//

import UIKit

class BoxView: UIView {
    private(set) var dwgConst = DrawingConstants()
    
    // MARK: - UI Properties
    private(set) lazy var textLabel: UILabel = {
        let view = UILabel()
        view.font = .systemFont(ofSize: 16, weight: .semibold)
        view.textColor = .white
        view.textAlignment = .center
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    // MARK: - Initializers
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = UIColor.black.withAlphaComponent(0.33)
        layer.cornerRadius = dwgConst.cornerRadius
        setupSubviews()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    func setTitle(_ title: String) {
        textLabel.text = title
    }
}
