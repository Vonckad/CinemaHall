//
//  TabView.swift
//  CinemaHall
//
//  Created by Vlad Ralovich on 2.02.22.
//

import UIKit

class TabView: UIView {

    var backgaundView: UIView!
    var button1: UIButton!
    var button2: UIButton!
    var button3: UIButton!
    var button4: UIButton!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgaundView = UIView(frame: CGRect(x: 8, y: 6, width: 80, height: 52))
        backgaundView.translatesAutoresizingMaskIntoConstraints = false
        backgaundView.layer.cornerRadius = 26
        addSubview(backgaundView)
        backgaundView.backgroundColor = UIColor.init(red: 161/255, green: 43/255, blue: 52/255, alpha: 1)
            
        let stacView = UIStackView()
        stacView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(stacView)
        stacView.distribution = .fillEqually
        
        button1 = UIButton()
        button1.setImage(UIImage(named: "home"), for: .normal)
        button1.addTarget(self, action: #selector(action1), for: .touchUpInside)
        button1.translatesAutoresizingMaskIntoConstraints = false
        button1.tintColor = .white
        stacView.addArrangedSubview(button1)
        
        button2 = UIButton()
        button2.setImage(UIImage(named: "play"), for: .normal)
        button2.addTarget(self, action: #selector(action2), for: .touchUpInside)
        button2.translatesAutoresizingMaskIntoConstraints = false
        button2.tintColor = .white
        stacView.addArrangedSubview(button2)
        
        button3 = UIButton()
        button3.setImage(UIImage(named: "bookmark"), for: .normal)
        button3.addTarget(self, action: #selector(action3), for: .touchUpInside)
        button3.translatesAutoresizingMaskIntoConstraints = false
        button3.tintColor = .white
        stacView.addArrangedSubview(button3)
        
        button4 = UIButton()
        button4.setImage(UIImage(named: "user"), for: .normal)
        button4.addTarget(self, action: #selector(action4), for: .touchUpInside)
        button4.translatesAutoresizingMaskIntoConstraints = false
        button4.tintColor = .white
        stacView.addArrangedSubview(button4)
        
        NSLayoutConstraint.activate([
            stacView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 8),
            stacView.topAnchor.constraint(equalTo: self.topAnchor, constant: 4),
            stacView.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -8),
            stacView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -4)
        ])
        
        fillButton(button1)
    }
    @objc func action1() {
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveLinear, animations: {
            self.backgaundView.frame.origin.x = 8
            self.fillButton(self.button1)
        })
    }
    @objc func action2() {
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveLinear, animations: {
            self.backgaundView.frame.origin.x = self.button2.frame.width + 8
            self.fillButton(self.button2)
        })
    }
    @objc func action3() {
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveLinear, animations: {
            self.backgaundView.frame.origin.x = self.button3.frame.width * 2 + 8
            self.fillButton(self.button3)
        })
    }
    @objc func action4() {
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveLinear, animations: {
            self.backgaundView.frame.origin.x = self.button4.frame.width * 3 + 8
            self.fillButton(self.button4)
        })
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func fillButton(_ currentButton: UIButton) {
        switch currentButton {
        case button1:
            self.button1.setImage(UIImage(named: "home-2"), for: .normal)
            self.button2.setImage(UIImage(named: "play"), for: .normal)
            self.button3.setImage(UIImage(named: "bookmark"), for: .normal)
            self.button4.setImage(UIImage(named: "user"), for: .normal)
        case button2:
            self.button2.setImage(UIImage(named: "play-2"), for: .normal)
            self.button1.setImage(UIImage(named: "home"), for: .normal)
            self.button3.setImage(UIImage(named: "bookmark"), for: .normal)
            self.button4.setImage(UIImage(named: "user"), for: .normal)
        case button3:
            self.button3.setImage(UIImage(named: "bookmarkFill"), for: .normal)
            self.button1.setImage(UIImage(named: "home"), for: .normal)
            self.button2.setImage(UIImage(named: "play"), for: .normal)
            self.button4.setImage(UIImage(named: "user"), for: .normal)
        case button4:
            self.button4.setImage(UIImage(named: "user-2"), for: .normal)
            self.button1.setImage(UIImage(named: "home"), for: .normal)
            self.button2.setImage(UIImage(named: "play"), for: .normal)
            self.button3.setImage(UIImage(named: "bookmark"), for: .normal)
        default:
            break
        }
    }
}
