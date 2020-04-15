//
//  CustomDatePicker.swift
//  Dune
//
//  Created by Waylan Sands on 9/4/20.
//  Copyright © 2020 Waylan Sands. All rights reserved.
//

import UIKit

class CustomDatePicker: UIView {
    
    let windowView = UIApplication.shared.windows.last
    let blackView = UIView()
    var delegate: CustomDatePickerDelegate?
    
    let selectButton: UIButton = {
        let button = UIButton()
        button.setTitle("Confirm", for: .normal)
        button.backgroundColor = CustomStyle.primaryBlue
        button.setTitleColor( .white, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        button.isEnabled = true
        return button
    }()
    
    let datePicker: UIDatePicker = {
        let picker = UIDatePicker()
        picker.datePickerMode = .date
        picker.backgroundColor = .white
        return picker
    }()
    
    func presentDatePicker() {
        if let window =  UIApplication.shared.keyWindow {
            blackView.backgroundColor = UIColor.black.withAlphaComponent(0.8)
            blackView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handelDismiss)))
            
            window.addSubview(blackView)
            blackView.frame = window.frame
            blackView.alpha = 0
            
            window.addSubview(datePicker)
            datePicker.translatesAutoresizingMaskIntoConstraints = false
            datePicker.centerYAnchor.constraint(equalTo: window.centerYAnchor).isActive = true
            datePicker.leadingAnchor.constraint(equalTo: window.leadingAnchor, constant: 30).isActive = true
            datePicker.trailingAnchor.constraint(equalTo: window.trailingAnchor, constant: -30).isActive = true
            
            window.addSubview(selectButton)
            selectButton.translatesAutoresizingMaskIntoConstraints = false
            selectButton.topAnchor.constraint(equalTo: datePicker.bottomAnchor).isActive = true
            selectButton.leadingAnchor.constraint(equalTo: datePicker.leadingAnchor).isActive = true
            selectButton.trailingAnchor.constraint(equalTo: datePicker.trailingAnchor).isActive = true
            selectButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
            selectButton.addTarget(self, action: #selector(updateDateLabel), for: .touchUpInside)
            
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                self.blackView.alpha = 1
                self.datePicker.alpha = 1
                self.selectButton.alpha = 1
            }, completion: nil)
        }
    }
    
    @objc func handelDismiss() {
        UIView.animate(withDuration: 0.5) {
            self.blackView.alpha = 0
            self.datePicker.alpha = 0
            self.selectButton.alpha = 0
        }
    }
    
    @objc func updateDateLabel() {
        print("hit")
        delegate?.confirmDateSelected(date: datePicker.date)
        handelDismiss()
    }
}

protocol CustomDatePickerDelegate {
    func confirmDateSelected(date: Date)
}

