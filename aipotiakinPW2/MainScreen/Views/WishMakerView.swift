//
//  WishMakerView.swift
//  aipotiakinPW2
//
//  Created by Arseniy on 28.10.2024.
//

import Foundation
import UIKit

class WishMakerView: UIView {
    // MARK: - Constants
    private enum Constants {
        // general to buttons
        static let buttonBorderWidth: CGFloat = 1.0
        static let buttonBorderColor: CGColor = UIColor.black.cgColor
        static let buttonCornerRadius: CGFloat = 15
        
        // general to stacks
        static let stackCornerRadius: CGFloat = 20
        static let stackSpacing: CGFloat = 10
        
        // titleLabel
        static let titleText: String = "WishMaker"
        static let titleTextColor: UIColor = .black
        static let titleTextFontSize: CGFloat = 32
        static let titleTextAlignment: NSTextAlignment = .center
        static let titleLeadingIndent: CGFloat = 20
        static let titleTopIndent: CGFloat = 30
        
        // descriptionLabel
        static let descriptionText: String = "This app will bring you joy and will fulfill three of your wishes!\n\t· The first wish is to change the background color."
        static let descriptionTextColor: UIColor = .black
        static let descriptionTextFontSize: CGFloat = 16
        static let descriptionTextAlignment: NSTextAlignment = .left
        static let descriptionLeadingIndent: CGFloat = 10
        static let descriptionTopIndent: CGFloat = 20
        static let descriptionNumberOfLines: Int = 10
        
        // slider
        static let sliderMin: Double = 0.0
        static let sliderMax: Double = 1.0
        static let red: String = "Red"
        static let green: String = "Green"
        static let blue: String = "Blue"
        static let backgroundAlphaTransparency: Double = 1.0
        
        // slidersStack
        static let slidersStackAxis: NSLayoutConstraint.Axis = .vertical
        static let slidersStackBottomIndent: CGFloat = 40
        static let slidersStackLeadingIndent: CGFloat = 20
        
        // hexLabel
        static let hexLabelText: String = "#FFFFFF"
        static let hexLabelTextColor: UIColor = .black
        static let hexLabelTextFontSize: CGFloat = 20
        static let hexLabelTextAlignment: NSTextAlignment = .center
        static let hexLabelLeadingIndent: CGFloat = 20
        static let hexLabelBottomIndent: CGFloat = 10
        
        // hexDescriptionLabel
        static let hexDescriptionLabelText: String = "Current HEX-code is"
        static let hexDescriptionLabelTextColor: UIColor = .black
        static let hexDescriptionLabelTextFontSize: CGFloat = 14
        static let hexDescriptionLabelTextAlignment: NSTextAlignment = .center
        static let hexDescriptionLabelLeadingIndent: CGFloat = 20
        static let hexDescriptionLabelBottomIndent: CGFloat = 5
        
        // menuButtonsStack
        static let menuButtonsStackAxis: NSLayoutConstraint.Axis = .horizontal
        static let menuButtonsStackDistribution: UIStackView.Distribution = .fillEqually
        static let menuButtonsStackLeadingIndent: CGFloat = 20
        static let menuButtonsStackBottomIndent: CGFloat = 10
        
        // menuHexButton
        static let menuHexButtonText: String = "HEX"
        static let menuHexButtonTextColor: UIColor = .black
        
    }
    
    // MARK: - Variables
    private var slidersStackBottomConstraint: NSLayoutConstraint!
    
    // MARK: - UI Components
    let titleLabel = UILabel()
    let descriptionLabel = UILabel()
    
    let hideButton = UIButton()
    let showButton = UIButton()
    
    let menuButtonsStack = UIStackView()
    let menuHexButton = UIButton()
    let menuPickColorButton = UIButton()
    let menuRandomColorButton = UIButton()
    
    let rgbButtonsStack = UIStackView()
    let redButton = UIButton()
    let greenButton = UIButton()
    let blueButton = UIButton()
    
    let randomColorButton = UIButton()
    
    let hexDescriptionLabel = UILabel()
    let hexLabel = UILabel()
    
    
    let slidersStack = UIStackView()
    let sliderRed = CustomSlider(title: Constants.red, min: Constants.sliderMin, max: Constants.sliderMax)
    let sliderGreen = CustomSlider(title: Constants.green, min: Constants.sliderMin, max: Constants.sliderMax)
    let sliderBlue = CustomSlider(title: Constants.blue, min: Constants.sliderMin, max: Constants.sliderMax)
    
    // MARK: - Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Methods
// Этот метод нарушает YAGNI, но этот метод необходим для архитектуры MVC впоследствии
//    func configure(with data: MODELNAME) {
//        // тут меняем поля вью на новые данные из модели
//    }
    
    // MARK: - Private methods
    // Disables all buttons from the list
    private func disableButtons(_ buttons: [UIButton]) {
        for button in buttons {
            button.isEnabled = false
        }
    }
    
    // Enables all buttons from the list
    private func enableButtons(_ buttons: [UIButton]) {
        for button in buttons {
            button.isEnabled = true
        }
    }
    
    // Updates backgroung color based on the given argument
    private func updateBackgroundColor(to updateType: String) {
        switch updateType {
        case "Red":
            self.sliderRed.slider.value = Float(Constants.sliderMax)
            self.sliderGreen.slider.value = Float(Constants.sliderMin)
            self.sliderBlue.slider.value = Float(Constants.sliderMin)
        case "Green":
            self.sliderRed.slider.value = Float(Constants.sliderMin)
            self.sliderGreen.slider.value = Float(Constants.sliderMax)
            self.sliderBlue.slider.value = Float(Constants.sliderMin)
        case "Blue":
            self.sliderRed.slider.value = Float(Constants.sliderMin)
            self.sliderGreen.slider.value = Float(Constants.sliderMin)
            self.sliderBlue.slider.value = Float(Constants.sliderMax)
        case "Random":
            self.sliderRed.slider.value = Float.random(in: 0.0...1.0)
            self.sliderBlue.slider.value = Float.random(in: 0.0...1.0)
            self.sliderGreen.slider.value = Float.random(in: 0.0...1.0)
        default:
            fatalError("Unhandled case in switch updateType")
        }
        self.backgroundColor = UIColor(
            red: CGFloat(self.sliderRed.slider.value),
            green: CGFloat(self.sliderGreen.slider.value),
            blue: CGFloat(self.sliderBlue.slider.value),
            alpha: Constants.backgroundAlphaTransparency
        )
        updateHexLabelCode()
    }
    
    // Updates hexLabel hex-code value to actual
    func updateHexLabelCode() {
        let red = CGFloat(self.sliderRed.slider.value)
        let green = CGFloat(self.sliderGreen.slider.value)
        let blue = CGFloat(self.sliderBlue.slider.value)
        
        self.hexLabel.text = rgbToHex(red: red, green: green, blue: blue)
    }

    // Converts RGB values (0.0 to 1.0) to HEX-code (00 - FF)
    private func rgbToHex(red: CGFloat, green: CGFloat, blue: CGFloat) -> String {
        let r = Int(red * 255)
        let g = Int(green * 255)
        let b = Int (blue * 255)
        return String(format: "#%02X%02X%02X", r, g, b)
    }
    
    private func configureUI() {
        backgroundColor = .white
        
        configureTitle()
        configureSliders()
        configureButtons()
        configureLabels()
        configureRGBButtonsStack()
    }
    
    private func configureTitle() {
        addSubview(titleLabel)
        
        titleLabel.text = Constants.titleText
        titleLabel.textColor = Constants.titleTextColor
        titleLabel.font = UIFont.systemFont(ofSize: Constants.titleTextFontSize)
        titleLabel.textAlignment = Constants.titleTextAlignment
        
        titleLabel.pinCenterX(to: centerXAnchor)
        titleLabel.pinLeft(to: leadingAnchor, Constants.titleLeadingIndent)
        titleLabel.pinTop(to: safeAreaLayoutGuide.topAnchor, Constants.titleTopIndent)
    }
    
    private func configureLabels() {
        // descriptionLabel
        addSubview(descriptionLabel)
        
        descriptionLabel.text = Constants.descriptionText
        descriptionLabel.textColor = Constants.descriptionTextColor
        descriptionLabel.font = UIFont.systemFont(ofSize: Constants.descriptionTextFontSize)
        descriptionLabel.textAlignment = Constants.descriptionTextAlignment
        descriptionLabel.numberOfLines = Constants.descriptionNumberOfLines
        
        descriptionLabel.pinCenterX(to: centerXAnchor)
        descriptionLabel.pinLeft(to: leadingAnchor, Constants.descriptionLeadingIndent)
        descriptionLabel.pinTop(to: titleLabel.bottomAnchor, Constants.descriptionTopIndent)
        
        // hexLabel
        addSubview(hexLabel)
        
        hexLabel.text = Constants.hexLabelText
        hexLabel.textColor = Constants.hexLabelTextColor
        hexLabel.font = UIFont.systemFont(ofSize: Constants.hexLabelTextFontSize)
        hexLabel.textAlignment = Constants.hexLabelTextAlignment
        
        hexLabel.pinCenterX(to: centerXAnchor)
        hexLabel.pinLeft(to: leadingAnchor, Constants.hexLabelLeadingIndent)
        hexLabel.pinBottom(to: showButton.topAnchor, Constants.hexLabelBottomIndent)
        
        // currentHexColorLabel
        addSubview(hexDescriptionLabel)
        
        hexDescriptionLabel.text = Constants.hexDescriptionLabelText
        hexDescriptionLabel.textColor = Constants.hexDescriptionLabelTextColor
        hexDescriptionLabel.font = UIFont.systemFont(ofSize: Constants.hexDescriptionLabelTextFontSize)
        hexDescriptionLabel.textAlignment = Constants.hexDescriptionLabelTextAlignment
        
        hexDescriptionLabel.pinCenterX(to: centerXAnchor)
        hexDescriptionLabel.pinLeft(to: leadingAnchor, Constants.hexDescriptionLabelLeadingIndent)
        hexDescriptionLabel.pinBottom(to: hexLabel.topAnchor, Constants.hexDescriptionLabelBottomIndent)
    }
    
    private func configureSliders() {
        addSubview(slidersStack)
        
        slidersStack.axis = Constants.slidersStackAxis
        slidersStack.layer.cornerRadius = Constants.stackCornerRadius
        slidersStack.clipsToBounds = true
        slidersStack.layer.borderColor = Constants.buttonBorderColor
        slidersStack.layer.borderWidth = Constants.buttonBorderWidth
        
        for slider in [sliderRed, sliderGreen, sliderBlue] {
            slidersStack.addArrangedSubview(slider)
            slider.slider.value = Float(Constants.sliderMax)
        }
        
        slidersStack.pinCenterX(to: centerXAnchor)
        slidersStack.pinLeft(to: leadingAnchor, Constants.slidersStackLeadingIndent)
        slidersStackBottomConstraint = slidersStack.pinBottom(to: safeAreaLayoutGuide.bottomAnchor, Constants.slidersStackBottomIndent)
        
        sliderRed.valueChanged = { [weak self] value in
            self?.backgroundColor = UIColor(
                red: CGFloat(value),
                green: CGFloat(self?.sliderGreen.slider.value ?? Float(Constants.sliderMin)),
                blue: CGFloat(self?.sliderBlue.slider.value ?? Float(Constants.sliderMin)),
                alpha: Constants.backgroundAlphaTransparency
            )
            self?.updateHexLabelCode()
        }
        
        sliderGreen.valueChanged = { [weak self] value in
            self?.backgroundColor = UIColor(
                red: CGFloat(self?.sliderRed.slider.value ?? Float(Constants.sliderMin)),
                green: CGFloat(value),
                blue: CGFloat(self?.sliderBlue.slider.value ?? Float(Constants.sliderMin)),
                alpha: Constants.backgroundAlphaTransparency
            )
            self?.updateHexLabelCode()
        }
        
        sliderBlue.valueChanged = { [weak self] value in
            self?.backgroundColor = UIColor(
                red: CGFloat(self?.sliderRed.slider.value ?? Float(Constants.sliderMin)),
                green: CGFloat(self?.sliderGreen.slider.value ?? Float(Constants.sliderMin)),
                blue: CGFloat(value),
                alpha: Constants.backgroundAlphaTransparency
            )
            self?.updateHexLabelCode()
        }
    }
    
    private func configureButtons() {
        // menuButtonsStack
        addSubview(menuButtonsStack)
        
        menuButtonsStack.axis = Constants.menuButtonsStackAxis
        menuButtonsStack.layer.cornerRadius = Constants.stackCornerRadius
        menuButtonsStack.clipsToBounds = true
        menuButtonsStack.spacing = Constants.stackSpacing
        menuButtonsStack.distribution = Constants.menuButtonsStackDistribution
        
        menuButtonsStack.pinLeft(to: leadingAnchor, Constants.menuButtonsStackLeadingIndent)
        menuButtonsStack.pinBottom(to: slidersStack.topAnchor, Constants.menuButtonsStackBottomIndent)
        menuButtonsStack.pinCenterX(to: centerXAnchor)
        
        // menuHexButton
        menuHexButton.setTitle(Constants.menuHexButtonText, for: .normal)
        menuHexButton.setTitleColor(Constants.menuHexButtonTextColor, for: .normal)
        menuHexButton.layer.cornerRadius = Constants.buttonCornerRadius
        menuHexButton.layer.borderColor = Constants.buttonBorderColor
        menuHexButton.layer.borderWidth = Constants.buttonBorderWidth
        menuHexButton.addTarget(self, action: #selector(showHEXstackView), for: .touchUpInside)
        
        // menuPickColorButton
        menuPickColorButton.setTitle("Pick", for: .normal)
        menuPickColorButton.backgroundColor = .white
        menuPickColorButton.setTitleColor(.black, for: .normal)
        menuPickColorButton.layer.cornerRadius = 15
        menuPickColorButton.layer.borderColor = UIColor.black.cgColor
        menuPickColorButton.layer.borderWidth = 1.0
        menuPickColorButton.addTarget(self, action: #selector(showPickColorStackView), for: .touchUpInside)
        
        menuRandomColorButton.setTitle("Random", for: .normal)
        menuRandomColorButton.backgroundColor = .white
        menuRandomColorButton.setTitleColor(.black, for: .normal)
        menuRandomColorButton.layer.cornerRadius = 15
        menuRandomColorButton.layer.borderColor = UIColor.black.cgColor
        menuRandomColorButton.layer.borderWidth = 1.0
        menuRandomColorButton.addTarget(self, action: #selector(showSetRandomColorButtom), for: .touchUpInside)
        
        for button in [menuHexButton, menuPickColorButton, menuRandomColorButton] {
            menuButtonsStack.addArrangedSubview(button)
            button.addTarget(self, action: #selector(buttonTouchedDown), for: .touchDown)
            button.addTarget(self, action: #selector(buttonTouchedUp), for: .touchUpInside)
            button.addTarget(self, action: #selector(buttonTouchedUp), for: .touchUpOutside)
        }
        
        // hideButton
        addSubview(hideButton)
        
        hideButton.setTitle("↓ Hide StackView", for: .normal)
        hideButton.backgroundColor = .white
        hideButton.setTitleColor(.black, for: .normal)
        hideButton.pinBottom(to: menuButtonsStack.topAnchor, 10)
        hideButton.pinCenterX(to: centerXAnchor)
        hideButton.pinLeft(to: leadingAnchor, 20)
        hideButton.layer.cornerRadius = 15
        hideButton.layer.borderColor = UIColor.black.cgColor
        hideButton.layer.borderWidth = 1.0
        hideButton.addTarget(self, action: #selector(buttonTouchedDown), for: .touchDown)
        hideButton.addTarget(self, action: #selector(buttonTouchedUp), for: .touchUpInside)
        hideButton.addTarget(self, action: #selector(buttonTouchedUp), for: .touchUpOutside)
        hideButton.addTarget(self, action: #selector(hideStackView), for: .touchUpInside)
        
        // showButton
        addSubview(showButton)
        
        showButton.alpha = 0.0
        showButton.setTitle("↑ Show StackView", for: .normal)
        showButton.backgroundColor = .white
        showButton.setTitleColor(.black, for: .normal)
        showButton.pinCenterX(to: centerXAnchor)
        showButton.pinCenterY(to: centerYAnchor)
        showButton.pinLeft(to: leadingAnchor, 20)
        showButton.layer.cornerRadius = 15
        showButton.layer.borderColor = UIColor.black.cgColor
        showButton.layer.borderWidth = 1.0
        showButton.addTarget(self, action: #selector(buttonTouchedDown), for: .touchDown)
        showButton.addTarget(self, action: #selector(buttonTouchedUp), for: .touchUpInside)
        showButton.addTarget(self, action: #selector(buttonTouchedUp), for: .touchUpOutside)
        showButton.addTarget(self, action: #selector(showStackView), for: .touchUpInside)
        
        // randomColorButton
        addSubview(randomColorButton)
        randomColorButton.setTitle("FEEL THE POWER OF RANDOMNESS", for: .normal)
        randomColorButton.backgroundColor = .white
        randomColorButton.setTitleColor(.black, for: .normal)
        randomColorButton.layer.borderColor = UIColor.black.cgColor
        randomColorButton.layer.borderWidth = 1.0
        randomColorButton.alpha = 0.0
        randomColorButton.layer.cornerRadius = 20
        randomColorButton.addTarget(self, action: #selector(setRandomColor), for: .touchUpInside)
        randomColorButton.addTarget(self, action: #selector(buttonTouchedDown), for: .touchDown)
        randomColorButton.addTarget(self, action: #selector(buttonTouchedUp), for: .touchUpInside)
        randomColorButton.addTarget(self, action: #selector(buttonTouchedUp), for: .touchUpOutside)
        
        randomColorButton.pinCenterX(to: slidersStack.centerXAnchor)
        randomColorButton.pinCenterY(to: slidersStack.centerYAnchor)
        randomColorButton.pinLeft(to: slidersStack.leadingAnchor)
        randomColorButton.pinTop(to: slidersStack.topAnchor)
    }
    
    private func configureRGBButtonsStack() {
        addSubview(rgbButtonsStack)
        
        rgbButtonsStack.axis = .horizontal
        rgbButtonsStack.clipsToBounds = true
        rgbButtonsStack.distribution = .fillEqually
        rgbButtonsStack.spacing = 10
        rgbButtonsStack.pinCenterX(to: slidersStack.centerXAnchor)
        rgbButtonsStack.pinCenterY(to: slidersStack.centerYAnchor)
        rgbButtonsStack.pinLeft(to: slidersStack.leadingAnchor)
        rgbButtonsStack.pinTop(to: slidersStack.topAnchor)
        rgbButtonsStack.alpha = 0.0
        
        redButton.backgroundColor = .red
        redButton.layer.cornerRadius = 20
        redButton.layer.borderColor = UIColor.black.cgColor
        redButton.layer.borderWidth = 1.0
        redButton.addTarget(self, action: #selector(setRedBackground), for: .touchUpInside)
        
        greenButton.backgroundColor = .green
        greenButton.layer.cornerRadius = 20
        greenButton.layer.borderColor = UIColor.black.cgColor
        greenButton.layer.borderWidth = 1.0
        greenButton.addTarget(self, action: #selector(setGreenBackground), for: .touchUpInside)
        
        blueButton.backgroundColor = .blue
        blueButton.layer.cornerRadius = 20
        blueButton.layer.borderColor = UIColor.black.cgColor
        blueButton.layer.borderWidth = 1.0
        blueButton.addTarget(self, action: #selector(setBlueBackground), for: .touchUpInside)
        
        for button in [redButton, greenButton, blueButton] {
            rgbButtonsStack.addArrangedSubview(button)
            button.addTarget(self, action: #selector(buttonTouchedDown), for: .touchDown)
            button.addTarget(self, action: #selector(buttonTouchedUp), for: .touchUpInside)
            button.addTarget(self, action: #selector(buttonTouchedUp), for: .touchUpOutside)
        }
    }
    
    // MARK: - objc
    @objc
    private func hideStackView() {
        UIView.animate(withDuration: 1, animations: {
            self.slidersStackBottomConstraint.constant = self.frame.height
            self.showButton.alpha = 1.0
            self.layoutIfNeeded()
            self.showButton.isEnabled = false
            self.hideButton.isEnabled = false
        }, completion: { _ in
            self.showButton.isEnabled = true
            self.hideButton.isEnabled = true
            })
    }
    
    @objc
    private func showStackView() {
        UIView.animate(withDuration: 1, animations: {
            self.slidersStackBottomConstraint = self.slidersStack.pinBottom(to: self.safeAreaLayoutGuide.bottomAnchor, Constants.slidersStackBottomIndent)
            self.showButton.alpha = 0.0
            self.layoutIfNeeded()
            self.showButton.isEnabled = false
            self.hideButton.isEnabled = false
        }, completion: { _ in
            self.showButton.isEnabled = true
            self.hideButton.isEnabled = true
            })
    }
    
    @objc
    private func showHEXstackView() {
        UIView.animate(withDuration: 0.5, animations: {
            self.rgbButtonsStack.alpha = 0.0
            self.randomColorButton.alpha = 0.0
            self.layoutIfNeeded()
            
            self.disableButtons([self.menuHexButton, self.menuPickColorButton, self.menuRandomColorButton])
        }, completion: { _ in
            UIView.animate(withDuration: 0.5, animations: {
                self.slidersStack.alpha = 1.0
                self.layoutIfNeeded()
                }, completion: { _ in
                    self.enableButtons([self.menuHexButton, self.menuPickColorButton, self.menuRandomColorButton])
                    })
            })
    }
    
    @objc
    private func showPickColorStackView() {
        UIView.animate(withDuration: 0.5, animations: {
            self.slidersStack.alpha = 0.0
            self.randomColorButton.alpha = 0.0
            self.layoutIfNeeded()
            
            self.disableButtons([self.menuHexButton, self.menuPickColorButton, self.menuRandomColorButton])
        }, completion: { _ in
            UIView.animate(withDuration: 0.5, animations: {
                self.rgbButtonsStack.alpha = 1.0
                self.layoutIfNeeded()
                }, completion: { _ in
                    self.enableButtons([self.menuHexButton, self.menuPickColorButton, self.menuRandomColorButton])
                    })
            })
    }
    
    @objc
    private func showSetRandomColorButtom() {
        UIView.animate(withDuration: 0.5, animations: {
            self.slidersStack.alpha = 0.0
            self.rgbButtonsStack.alpha = 0.0
            self.layoutIfNeeded()
            
            self.disableButtons([self.menuHexButton, self.menuPickColorButton, self.menuRandomColorButton])
        }, completion: { _ in
            UIView.animate(withDuration: 0.5, animations: {
                self.randomColorButton.alpha = 1.0
                self.layoutIfNeeded()
                }, completion: { _ in
                    
                    self.enableButtons([self.menuHexButton, self.menuPickColorButton, self.menuRandomColorButton])
                    })
            })
    }
    
    @objc
    private func setRandomColor() {
        updateBackgroundColor(to: "Random")
    }
    
    @objc
    private func setRedBackground() {
        updateBackgroundColor(to: "Red")
    }
    
    @objc
    private func setGreenBackground() {
        updateBackgroundColor(to: "Green")
    }
    
    @objc
    private func setBlueBackground() {
        updateBackgroundColor(to: "Blue")
    }
    
    @objc
    private func buttonTouchedDown(sender: UIButton) {
        sender.alpha = 0.6
    }
    
    @objc
    private func buttonTouchedUp(sender: UIButton) {
        sender.alpha = 1
    }
}
