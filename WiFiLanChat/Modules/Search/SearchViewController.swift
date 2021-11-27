//
//  SearchViewController.swift
//  WiFiLanChat
//
//  Created by Bilol Mamadjanov on 26/11/21.
//

import UIKit

class SearchViewController: BaseViewController {
    private(set) var dwgConst = DrawingConstants()
    private let uiConst = UIConstants()
    
    // MARK: - UI Properties
    private(set) lazy var ipField: IPField = {
        let view = IPField()
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
}

// MARK: - Lifecycle
extension SearchViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = uiConst.title
        setup()
    }
}

extension SearchViewController: IPFieldDelegate {
    func didChangeHost(_ host: String) {
        print(host)
    }
    
    func didPasteHost(_ host: String) {
        print(host)
    }
}

extension SearchViewController {
    private struct UIConstants {
        let title = "Search"
    }
}
