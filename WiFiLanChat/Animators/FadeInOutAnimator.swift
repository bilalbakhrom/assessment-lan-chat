//
//  FadeInOutAnimator.swift
//  WiFiLanChat
//
//  Created by Bilol Mamadjanov on 29/11/21.
//

import UIKit

class FadeInOutAnimator: Animator {
    override func animateView() {
        UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseOut) {
            self.view.alpha = 1.0
        } completion: { _ in
            UIView.animate(withDuration: 0.5, delay: 0.5, options: .curveEaseOut) {
                self.view.alpha = 0.0
            }
        }
    }
}
