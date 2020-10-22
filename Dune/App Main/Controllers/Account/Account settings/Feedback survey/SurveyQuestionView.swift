//
//  SurveyQuestionView.swift
//  Dune
//
//  Created by Waylan Sands on 14/9/20.
//  Copyright © 2020 Waylan Sands. All rights reserved.
//

import UIKit

enum QuestionType {
    case multipleChoice
    case ordered
}

class SurveyQuestionView: UIStackView {
    
    var questionType: QuestionType
    var question: String
    var answers: [String]
    var info: String?
    
    var answerLabels = [UILabel]()
    var answerButtons = [UIButton]()
    
    var answerSelected: (() -> Void)?
    
    var selection: String?
        
    let questionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: .bold)
        label.textColor = CustomStyle.primaryBlack
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        return label
    }()
    
    let infoLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: .light)
        label.textColor = CustomStyle.primaryBlack
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        return label
    }()
    
    var orderedButton: UIButton = {
        let button = UIButton()
        button.titleLabel?.font = UIFont.systemFont(ofSize: 10, weight: .medium)
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 6
        button.backgroundColor = CustomStyle.thirdShade
        return button
    }()
    
    var answerView: UIView = {
        let view = UIView()
        view.backgroundColor = .blue
        return view
    }()
        
    
    init(question: String, info: String?, type: QuestionType, answers: [String]) {
        self.question = question
        self.questionType = type
        self.answers = answers
        self.info = info
        super.init(frame: .zero)
        self.axis = .vertical
        self.spacing = 14
        configureQuestion()
        configureViews()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func configureQuestion() {
        questionLabel.text = question
        questionLabel.addLineSpacingIndented()

        infoLabel.text = info
        infoLabel.addLineSpacing()
    }
    
    func configureViews() {
        self.addArrangedSubview(questionLabel)
        self.addArrangedSubview(infoLabel)

        for eachAnswer in answers {
            var button: UIButton
            if questionType == .multipleChoice {
                button = multipleButtonCreator()
            } else {
                button = multipleButtonCreator()
            }
            let answerLabel = answerCreator(answer: eachAnswer)
            let answer = answerView(button: button, label: answerLabel)
//            answer.backgroundColor = .red
            
            self.addArrangedSubview(answer)
        }
        
        self.setCustomSpacing(5, after: questionLabel)
        self.setCustomSpacing(10, after: infoLabel)
    }
    
    func multipleButtonCreator() -> UIButton {
        let button = UIButton()
        button.addTarget(self, action: #selector(buttonSelected(_:)), for: .touchUpInside)
        button.layer.cornerRadius = 8
        button.backgroundColor = CustomStyle.thirdShade
        answerButtons.append(button)
        return button
    }
    
    func answerCreator(answer: String) -> UILabel {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        label.textColor = CustomStyle.primaryBlack
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        label.text = answer
        answerLabels.append(label)
        return label
    }
    
    func answerView(button: UIButton, label: UILabel) -> UIView {
        let view = UIStackView()
        view.axis = .horizontal
        view.alignment = .center
        view.spacing = 10
        view.layoutMargins = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 0)
        view.isLayoutMarginsRelativeArrangement = true
        
        let gestureTap = UITapGestureRecognizer(target: self, action: #selector(labelTap))
        label.addGestureRecognizer(gestureTap)
        label.isUserInteractionEnabled = true
        
        view.addArrangedSubview(button)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.heightAnchor.constraint(equalToConstant: 16).isActive = true
        button.widthAnchor.constraint(equalToConstant: 16).isActive = true
        
        view.addArrangedSubview(label)
        return view
    }
    
    @objc func labelTap(_ gesture: UITapGestureRecognizer) {
        let view = gesture.view
        let label = view as! UILabel
        guard let selection = answerLabels.first(where: { $0.text == label.text }) else { return }
        guard let buttonIndex = answerLabels.firstIndex(of: selection) else { return }
        let button = answerButtons[buttonIndex]
        self.selection = selection.text
        answerSelected!()
        for each in answerButtons {
            if each != button {
                each.backgroundColor = CustomStyle.thirdShade
            } else {
                each.backgroundColor = CustomStyle.primaryBlue
            }
        }
    }
    
    
    @objc func buttonSelected(_ sender: UIButton) {
        guard let index = answerButtons.firstIndex(of: sender) else { return }
        let selection = answerLabels[index]
        self.selection = selection.text
        answerSelected!()
        for each in answerButtons {
            if each != sender {
                each.backgroundColor = CustomStyle.thirdShade
            } else {
                each.backgroundColor = CustomStyle.primaryBlue
            }
        }
    }
    
    func clearAnswer() {
        selection = nil
        for each in answerButtons {
            each.backgroundColor = CustomStyle.thirdShade
        }
    }

}
