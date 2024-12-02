//
//  WishMakerView.swift
//  aipotiakinPW2
//
//  Created by Arseniy on 28.10.2024.
//

import Foundation
import UIKit

// Протокол делегата для передачи событий
protocol WishMakerViewDelegate: AnyObject {
    func didAddWishButtonPressed()
    func didScheduleWishButtonPressed()
}

final class WishMakerView: UIView {
    // MARK: - Constants
    private enum Constants {
        // animations
        static let hideMenuAnimationDuration: TimeInterval = 1
        static let showMenuAnimationDuration: TimeInterval = 1
        static let showHexStackViewAnimationDuration: TimeInterval = 0.5
        static let showPickColorStackViewAnimationDuration: TimeInterval = 0.5
        static let showSetRandomColorButtonAnimationDuration: TimeInterval = 0.5
        
        // general to all UI components
        static let minAlpha: CGFloat = 0.0
        static let maxAlpha: CGFloat = 1.0
        
        // general to buttons
        static let buttonBorderWidth: CGFloat = 1.0
        static let buttonBorderColor: CGColor = UIColor.black.cgColor
        static let buttonCornerRadius: CGFloat = 15
        static let buttonBackgroundColor: UIColor = .clear
        static let buttonTitleColor: UIColor = .black
        
        static let buttonTouchedDownAlpha: CGFloat = 0.6
        static let buttonTouchedUpAlpha: CGFloat = 1
        
        // general to stacks
        static let stackCornerRadius: CGFloat = 20
        static let stackSpacing: CGFloat = 10
        static let stackBackgroundColor: UIColor = .clear
        
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
        static let sliderBackgroundColor: UIColor = .clear
        static let sliderMin: Double = 0.0
        static let sliderMax: Double = 1.0
        static let red: String = "Red"
        static let green: String = "Green"
        static let blue: String = "Blue"
        static let backgroundAlphaTransparency: Double = 1.0
        
        // slidersStack
        static let slidersStackAxis: NSLayoutConstraint.Axis = .vertical
        static let slidersStackBottomIndent: CGFloat = 10
        static let slidersStackLeadingIndent: CGFloat = 20
        static let slidersStackBackgroundColor: UIColor = .clear
        
        // hexLabel
        static let hexLabelText: String = "#FFFFFF"
        static let hexLabelTextColor: UIColor = .black
        static let hexLabelTextFontSize: CGFloat = 20
        static let hexLabelTextAlignment: NSTextAlignment = .center
        static let hexLabelLeadingIndent: CGFloat = 20
        
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
        static let menuHexButtonTitle: String = "HEX"
        
        // menuPickColorButton
        static let menuPickColorButtonTitle: String = "Pick"
        
        // menuRandomColorButton
        static let menuRandomColorButtonTitle: String = "Random"
        
        // hideButton
        static let hideButtonTitle: String = "↓ Hide menu"
        static let hideButtonBottomIndent: CGFloat = 10
        static let hideButtonLeadingIndent: CGFloat = 20
        
        // showButton
        static let showButtonTitle: String = "↑ Show menu"
        static let showButtonLeadingIndent: CGFloat = 20
        
        // randomColorButton
        static let randomColorButtonTitle: String = "FEEL THE POWER OF RANDOMNESS"
        
        // rgbButtonsStack
        static let rgbButtonsStackAxis: NSLayoutConstraint.Axis = .horizontal
        static let rgbButtonsStackDistribution: UIStackView.Distribution = .fillEqually
        
        // redButton
        static let redButtonBackgroundColor: UIColor = .red
        
        // greenButton
        static let greenButtonBackgroundColor: UIColor = .green
        
        // blueButton
        static let blueButtonBackgroundColor: UIColor = .blue
        
        // addWishButton
        static let addWishButtonBottomIndent: CGFloat = 10
        static let addWishButtonLeadingIndent: CGFloat = 20
        static let addWishButtonTitleColor: UIColor = .systemPink
        static let addWishButtonTitle: String = "My wishes"
        
        // scheduleWishButton
        static let scheduleWishButtonBottomIndent: CGFloat = 40
        static let scheduleWishButtonLeadingIndent: CGFloat = 20
        static let scheduleWishButtonTitleColor: UIColor = .systemPink
        static let scheduleWishButtonTitle: String = "Schedule wish granting"
    }
    
    // MARK: - Variables
    private var scheduleWishButtonConstraint: NSLayoutConstraint!
    var currentBackgroundColor: UIColor {
        getCurrentBackgroundColor()
    }
    weak var delegate: WishMakerViewDelegate?
    
    // MARK: - UI Components
    private let titleLabel: UILabel = UILabel()
    private let descriptionLabel: UILabel = UILabel()
    
    private let hideButton: UIButton = UIButton(type: .system)
    private let showButton: UIButton = UIButton(type: .system)
    
    private let menuButtonsStack: UIStackView = UIStackView()
    private let menuHexButton: UIButton = UIButton(type: .system)
    private let menuPickColorButton: UIButton = UIButton(type: .system)
    private let menuRandomColorButton: UIButton = UIButton(type: .system)
    
    private let rgbButtonsStack: UIStackView = UIStackView()
    private let redButton: UIButton = UIButton(type: .system)
    private let greenButton: UIButton = UIButton(type: .system)
    private let blueButton: UIButton = UIButton(type: .system)
    
    private let randomColorButton: UIButton = UIButton(type: .system)
    
    private let hexDescriptionLabel: UILabel = UILabel()
    private let hexLabel: UILabel = UILabel()
    
    private let addWishButton: UIButton = UIButton(type: .system)
    private let scheduleWishButton: UIButton = UIButton(type: .system)
    
    
    private let slidersStack: UIStackView = UIStackView()
    private let sliderRed: CustomSlider = CustomSlider(title: Constants.red, min: Constants.sliderMin, max: Constants.sliderMax)
    private let sliderGreen: CustomSlider = CustomSlider(title: Constants.green, min: Constants.sliderMin, max: Constants.sliderMax)
    private let sliderBlue: CustomSlider = CustomSlider(title: Constants.blue, min: Constants.sliderMin, max: Constants.sliderMax)
    
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
// This method violates YAGNI, but it's necessary for working with the model in the future according to MVC architecture
//    func configure(with data: MODELNAME) {
//        // Here we change view data to new data from the model
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
            self.sliderRed.slider.value = Float(Double.random(in: Constants.sliderMin...Constants.sliderMax))
            self.sliderBlue.slider.value = Float(Double.random(in: Constants.sliderMin...Constants.sliderMax))
            self.sliderGreen.slider.value = Float(Double.random(in: Constants.sliderMin...Constants.sliderMax))
        default:
            fatalError("Unhandled case in switch updateType")
        }
        let newBackgroundColor: UIColor = UIColor(
            red: CGFloat(self.sliderRed.slider.value),
            green: CGFloat(self.sliderGreen.slider.value),
            blue: CGFloat(self.sliderBlue.slider.value),
            alpha: Constants.backgroundAlphaTransparency
        )
        self.backgroundColor = newBackgroundColor
        updateHexLabelCode()
    }
    
    private func getCurrentBackgroundColor() -> UIColor {
        return UIColor(
            red: CGFloat(self.sliderRed.slider.value),
            green: CGFloat(self.sliderGreen.slider.value),
            blue: CGFloat(self.sliderBlue.slider.value),
            alpha: Constants.backgroundAlphaTransparency
        )
    }
    
    // Updates hexLabel hex-code value to actual
    private func updateHexLabelCode() {
        let red = CGFloat(self.sliderRed.slider.value)
        let green = CGFloat(self.sliderGreen.slider.value)
        let blue = CGFloat(self.sliderBlue.slider.value)
        
        self.hexLabel.text = rgbToHex(red: red, green: green, blue: blue)
    }

    // Converts RGB values (0.0 to 1.0) to HEX-code (00 - FF)
    private func rgbToHex(red: CGFloat, green: CGFloat, blue: CGFloat) -> String {
        let hexMultiplier: CGFloat = 255
        let r: Int = Int(red * hexMultiplier)
        let g: Int = Int(green * hexMultiplier)
        let b: Int = Int (blue * hexMultiplier)
        let hexFormat: String = "#%02X%02X%02X"
        return String(format: hexFormat, r, g, b)
    }
    
    private func configureUI() {
        backgroundColor = .white
        configureScheduleWishButton()
        configureAddWishButton()
        configureTitle()
        configureSliders()
        configureButtons()
        configureLabels()
        configureRGBButtonsStack()
    }
    
    private func configureAddWishButton() {
        addSubview(addWishButton)
        addWishButton.pinBottom(to: scheduleWishButton.topAnchor, Constants.addWishButtonBottomIndent)
        addWishButton.pinCenterX(to: centerXAnchor)
        addWishButton.pinLeft(to: leadingAnchor, Constants.addWishButtonLeadingIndent)
        
        addWishButton.backgroundColor = Constants.buttonBackgroundColor
        addWishButton.setTitleColor(Constants.addWishButtonTitleColor, for: .normal)
        addWishButton.setTitle(Constants.addWishButtonTitle, for: .normal)
        
        addWishButton.layer.cornerRadius = Constants.buttonCornerRadius
        addWishButton.layer.borderWidth = Constants.buttonBorderWidth
        addWishButton.layer.borderColor = Constants.buttonBorderColor
        addWishButton.addTarget(self, action: #selector(addWishButtonPressed), for: .touchUpInside)
    }
    
    private func configureScheduleWishButton() {
        addSubview(scheduleWishButton)
        scheduleWishButtonConstraint = scheduleWishButton.pinBottom(to: safeAreaLayoutGuide.bottomAnchor, Constants.scheduleWishButtonBottomIndent)
        scheduleWishButton.pinCenterX(to: centerXAnchor)
        scheduleWishButton.pinLeft(to: leadingAnchor, Constants.scheduleWishButtonLeadingIndent)
        
        scheduleWishButton.backgroundColor = Constants.buttonBackgroundColor
        scheduleWishButton.setTitleColor(Constants.scheduleWishButtonTitleColor, for: .normal)
        scheduleWishButton.setTitle(Constants.scheduleWishButtonTitle, for: .normal)
        
        scheduleWishButton.layer.cornerRadius = Constants.buttonCornerRadius
        scheduleWishButton.layer.borderWidth = Constants.buttonBorderWidth
        scheduleWishButton.layer.borderColor = Constants.buttonBorderColor
        scheduleWishButton.addTarget(self, action: #selector(scheduleWishButtonPressed), for: .touchUpInside)
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
        
        hexLabel.pinLeft(to: leadingAnchor, Constants.hexLabelLeadingIndent)
        hexLabel.pinCenterX(to: centerXAnchor)
        hexLabel.pinCenterY(to: centerYAnchor)
        
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
        slidersStack.backgroundColor = Constants.slidersStackBackgroundColor
        slidersStack.clipsToBounds = true
        slidersStack.layer.borderColor = Constants.buttonBorderColor
        slidersStack.layer.borderWidth = Constants.buttonBorderWidth
        
        for slider in [sliderRed, sliderGreen, sliderBlue] {
            slidersStack.addArrangedSubview(slider)
            slider.backgroundColor = Constants.sliderBackgroundColor
            slider.slider.value = Float(Constants.sliderMax)
        }
        
        slidersStack.pinCenterX(to: centerXAnchor)
        slidersStack.pinLeft(to: leadingAnchor, Constants.slidersStackLeadingIndent)
        slidersStack.pinBottom(to: addWishButton.topAnchor, Constants.slidersStackBottomIndent)
        
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
        menuButtonsStack.layer.cornerRadius = Constants.buttonCornerRadius
        menuButtonsStack.clipsToBounds = true
        menuButtonsStack.spacing = Constants.stackSpacing
        menuButtonsStack.distribution = Constants.menuButtonsStackDistribution
        
        menuButtonsStack.pinLeft(to: leadingAnchor, Constants.menuButtonsStackLeadingIndent)
        menuButtonsStack.pinBottom(to: slidersStack.topAnchor, Constants.menuButtonsStackBottomIndent)
        menuButtonsStack.pinCenterX(to: centerXAnchor)
        
        // menuHexButton
        menuHexButton.setTitle(Constants.menuHexButtonTitle, for: .normal)
        menuHexButton.setTitleColor(Constants.buttonTitleColor, for: .normal)
        menuHexButton.backgroundColor = Constants.buttonBackgroundColor
        menuHexButton.layer.cornerRadius = Constants.buttonCornerRadius
        menuHexButton.layer.borderColor = Constants.buttonBorderColor
        menuHexButton.layer.borderWidth = Constants.buttonBorderWidth
        menuHexButton.addTarget(self, action: #selector(showHexStackView), for: .touchUpInside)
        
        // menuPickColorButton
        menuPickColorButton.setTitle(Constants.menuPickColorButtonTitle, for: .normal)
        menuPickColorButton.backgroundColor = Constants.buttonBackgroundColor
        menuPickColorButton.setTitleColor(Constants.buttonTitleColor, for: .normal)
        menuPickColorButton.layer.cornerRadius = Constants.buttonCornerRadius
        menuPickColorButton.layer.borderColor = Constants.buttonBorderColor
        menuPickColorButton.layer.borderWidth = Constants.buttonBorderWidth
        menuPickColorButton.addTarget(self, action: #selector(showPickColorStackView), for: .touchUpInside)
        
        // menuRandomColorButton
        menuRandomColorButton.setTitle(Constants.menuRandomColorButtonTitle, for: .normal)
        menuRandomColorButton.backgroundColor = Constants.buttonBackgroundColor
        menuRandomColorButton.setTitleColor(Constants.buttonTitleColor, for: .normal)
        menuRandomColorButton.layer.cornerRadius = Constants.buttonCornerRadius
        menuRandomColorButton.layer.borderColor = Constants.buttonBorderColor
        menuRandomColorButton.layer.borderWidth = Constants.buttonBorderWidth
        menuRandomColorButton.addTarget(self, action: #selector(showSetRandomColorButtom), for: .touchUpInside)
        
        for button in [menuHexButton, menuPickColorButton, menuRandomColorButton] {
            menuButtonsStack.addArrangedSubview(button)
        }
        
        // hideButton
        addSubview(hideButton)
        
        hideButton.setTitle(Constants.hideButtonTitle, for: .normal)
        hideButton.backgroundColor = Constants.buttonBackgroundColor
        hideButton.setTitleColor(Constants.buttonTitleColor, for: .normal)
        hideButton.pinBottom(to: menuButtonsStack.topAnchor, Constants.hideButtonBottomIndent)
        hideButton.pinCenterX(to: centerXAnchor)
        hideButton.pinLeft(to: leadingAnchor, Constants.hideButtonLeadingIndent)
        hideButton.layer.cornerRadius = Constants.buttonCornerRadius
        hideButton.layer.borderColor = Constants.buttonBorderColor
        hideButton.layer.borderWidth = Constants.buttonBorderWidth
        hideButton.addTarget(self, action: #selector(hideStackView), for: .touchUpInside)
        
        // showButton
        addSubview(showButton)
        
        showButton.alpha = Constants.minAlpha
        showButton.setTitle(Constants.showButtonTitle, for: .normal)
        showButton.backgroundColor = Constants.buttonBackgroundColor
        showButton.setTitleColor(Constants.buttonTitleColor, for: .normal)
        showButton.pinCenterX(to: centerXAnchor)
        showButton.pinLeft(to: leadingAnchor, Constants.showButtonLeadingIndent)
        showButton.pinBottom(to: safeAreaLayoutGuide.bottomAnchor, 40)
        showButton.layer.cornerRadius = Constants.buttonCornerRadius
        showButton.layer.borderColor = Constants.buttonBorderColor
        showButton.layer.borderWidth = Constants.buttonBorderWidth
        showButton.addTarget(self, action: #selector(showStackView), for: .touchUpInside)
        
        // randomColorButton
        addSubview(randomColorButton)
        randomColorButton.setTitle(Constants.randomColorButtonTitle, for: .normal)
        randomColorButton.backgroundColor = Constants.buttonBackgroundColor
        randomColorButton.setTitleColor(Constants.buttonTitleColor, for: .normal)
        randomColorButton.layer.borderColor = Constants.buttonBorderColor
        randomColorButton.layer.borderWidth = Constants.buttonBorderWidth
        randomColorButton.alpha = Constants.minAlpha
        // button have the same sizes as stack, so make edges like in stack
        randomColorButton.layer.cornerRadius = Constants.stackCornerRadius
        randomColorButton.addTarget(self, action: #selector(setRandomColor), for: .touchUpInside)
        
        randomColorButton.pinCenterX(to: slidersStack.centerXAnchor)
        randomColorButton.pinCenterY(to: slidersStack.centerYAnchor)
        randomColorButton.pinLeft(to: slidersStack.leadingAnchor)
        randomColorButton.pinTop(to: slidersStack.topAnchor)
    }
    
    private func configureRGBButtonsStack() {
        // rgbButtonsStack
        addSubview(rgbButtonsStack)
        
        rgbButtonsStack.axis = Constants.rgbButtonsStackAxis
        rgbButtonsStack.clipsToBounds = true
        rgbButtonsStack.distribution = Constants.rgbButtonsStackDistribution
        rgbButtonsStack.spacing = Constants.stackSpacing
        rgbButtonsStack.pinCenterX(to: slidersStack.centerXAnchor)
        rgbButtonsStack.pinCenterY(to: slidersStack.centerYAnchor)
        rgbButtonsStack.pinLeft(to: slidersStack.leadingAnchor)
        rgbButtonsStack.pinTop(to: slidersStack.topAnchor)
        rgbButtonsStack.alpha = Constants.minAlpha
        
        redButton.backgroundColor = Constants.redButtonBackgroundColor
        redButton.layer.cornerRadius = Constants.stackCornerRadius
        redButton.layer.borderColor = Constants.buttonBorderColor
        redButton.layer.borderWidth = Constants.buttonBorderWidth
        redButton.addTarget(self, action: #selector(setRedBackground), for: .touchUpInside)
        
        greenButton.backgroundColor = Constants.greenButtonBackgroundColor
        greenButton.layer.cornerRadius = Constants.stackCornerRadius
        greenButton.layer.borderColor = Constants.buttonBorderColor
        greenButton.layer.borderWidth = Constants.buttonBorderWidth
        greenButton.addTarget(self, action: #selector(setGreenBackground), for: .touchUpInside)
        
        blueButton.backgroundColor = Constants.blueButtonBackgroundColor
        blueButton.layer.cornerRadius = Constants.stackCornerRadius
        blueButton.layer.borderColor = Constants.buttonBorderColor
        blueButton.layer.borderWidth = Constants.buttonBorderWidth
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
    private func addWishButtonPressed() {
        delegate?.didAddWishButtonPressed()
    }
    
    @objc
    private func scheduleWishButtonPressed() {
        delegate?.didScheduleWishButtonPressed()
    }
    
    @objc
    private func hideStackView() {
        UIView.animate(withDuration: Constants.hideMenuAnimationDuration, animations: {
            let newScheduleWishButtonPosition = self.frame.height
            self.scheduleWishButtonConstraint.constant = newScheduleWishButtonPosition
            self.showButton.alpha = Constants.maxAlpha
            self.layoutIfNeeded()
            
            self.disableButtons([self.showButton, self.hideButton])
        }, completion: { _ in
            self.enableButtons([self.showButton, self.hideButton])
            })
    }
    
    @objc
    private func showStackView() {
        UIView.animate(withDuration: Constants.showMenuAnimationDuration, animations: {
            // set slidersStack to default position
            self.scheduleWishButtonConstraint = self.scheduleWishButton.pinBottom(to: self.safeAreaLayoutGuide.bottomAnchor, Constants.scheduleWishButtonBottomIndent)
            self.showButton.alpha = Constants.minAlpha
            self.layoutIfNeeded()
            
            self.disableButtons([self.showButton, self.hideButton])
        }, completion: { _ in
            self.enableButtons([self.showButton, self.hideButton])
            })
    }
    
    @objc
    private func showHexStackView() {
        UIView.animate(withDuration: Constants.showHexStackViewAnimationDuration, animations: {
            self.rgbButtonsStack.alpha = Constants.minAlpha
            self.randomColorButton.alpha = Constants.minAlpha
            self.layoutIfNeeded()
            
            self.disableButtons([self.menuHexButton, self.menuPickColorButton, self.menuRandomColorButton])
        }, completion: { _ in
            UIView.animate(withDuration: Constants.showMenuAnimationDuration, animations: {
                self.slidersStack.alpha = Constants.maxAlpha
                self.layoutIfNeeded()
                }, completion: { _ in
                    self.enableButtons([self.menuHexButton, self.menuPickColorButton, self.menuRandomColorButton])
                    })
            })
    }
    
    @objc
    private func showPickColorStackView() {
        UIView.animate(withDuration: Constants.showPickColorStackViewAnimationDuration, animations: {
            self.slidersStack.alpha = Constants.minAlpha
            self.randomColorButton.alpha = Constants.minAlpha
            self.layoutIfNeeded()
            
            self.disableButtons([self.menuHexButton, self.menuPickColorButton, self.menuRandomColorButton])
        }, completion: { _ in
            UIView.animate(withDuration: Constants.showPickColorStackViewAnimationDuration, animations: {
                self.rgbButtonsStack.alpha = Constants.maxAlpha
                self.layoutIfNeeded()
                }, completion: { _ in
                    self.enableButtons([self.menuHexButton, self.menuPickColorButton, self.menuRandomColorButton])
                    })
            })
    }
    
    @objc
    private func showSetRandomColorButtom() {
        UIView.animate(withDuration: Constants.showSetRandomColorButtonAnimationDuration, animations: {
            self.slidersStack.alpha = Constants.minAlpha
            self.rgbButtonsStack.alpha = Constants.minAlpha
            self.layoutIfNeeded()
            
            self.disableButtons([self.menuHexButton, self.menuPickColorButton, self.menuRandomColorButton])
        }, completion: { _ in
            UIView.animate(withDuration: Constants.showSetRandomColorButtonAnimationDuration, animations: {
                self.randomColorButton.alpha = Constants.maxAlpha
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
        sender.alpha = Constants.buttonTouchedDownAlpha
    }
    
    @objc
    private func buttonTouchedUp(sender: UIButton) {
        sender.alpha = Constants.buttonTouchedUpAlpha
    }
}
