//
//  WeekdayPicker.swift
//  WeatherApp
//
//  Created by Eugene Kiselev on 20.08.2020.
//  Copyright © 2020 Eugene Kiselev. All rights reserved.
//

import UIKit

enum Day: Int {
    
    case monday
    case tuesday
    case wednesday
    case thursday
    case friday
    case saturday
    case sunday
    
    static let allDay: [Day] = [monday, tuesday, wednesday, thursday, friday, saturday, sunday]
    
    var title: String {
        
        switch self {
            case .monday: return "ПН"
            case .tuesday: return "ВТ"
            case .wednesday: return "СР"
            case .thursday: return "ЧТ"
            case .friday: return "ПТ"
            case .saturday: return "СБ"
            case .sunday: return "ВС"
        }
    }
}

@IBDesignable class WeekdayPicker: UIControl {

    var selectedDay: Day? {
        didSet {
            self.updateSelectedDay​()
            self.sendActions(for: .valueChanged)
        }
    }
    
    private var buttons: [UIButton] = []
    private var stackView: UIStackView!
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        stackView.frame = bounds
    }
    
    private func setupView​() {
    
        for day in Day.allDay {
            let button = UIButton(type: .system)
            button.setTitle(day.title, for: .normal)
            button.setTitleColor(.lightGray, for: .normal)
            button.setTitleColor(.white, for: .selected)
            button.addTarget(self, action: #selector(selectDay​(_:)), for: .touchUpInside)
            self.buttons.append(button)
        }
        
        stackView = UIStackView(arrangedSubviews: self.buttons)
        
        self.addSubview(stackView)
        
        stackView.spacing = 8
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.distribution = .fillEqually
    }
    
    private func updateSelectedDay​() {
        
        for (index, button) in self.buttons.enumerated() {
            
            guard let day = Day(rawValue: index) else { continue }
            button.isSelected = day == self.selectedDay
        }
    }
    
    @objc private func selectDay​(_ sender: UIButton) {

        guard let index = self.buttons.firstIndex(of: sender) else { return }
        guard let day = Day(rawValue: index) else { return }
        self.selectedDay = day
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.setupView​()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        self.setupView​()
    }
}
