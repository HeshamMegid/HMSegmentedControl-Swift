//
//  HMSegmentedControl.swift
//  HMSegmentedControl
//
//  Created by Hesham Abd-Elmegid on 8/24/16.
//  Copyright © 2016 Tinybits. All rights reserved.
//

import UIKit

// TODO:
//  * Add IBInspectable stuff
//  * UIAppearance support
//  * Handler for index change
//  * Set index change manually

class HMSegmentedControl: UIControl {
    enum SelectionIndicatorPosition {
        case Top
        case Bottom
    }
    
    var items: [String]
    private var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.distribution = .fillEqually
        
        return stackView
    }()
    
    lazy var selectionIndicator: UIView = {
        let selectionIndicator = UIView()
        selectionIndicator.backgroundColor = self.selectionIndicatorColor
        selectionIndicator.translatesAutoresizingMaskIntoConstraints = false
        return selectionIndicator
    }()
    
    private var selectionIndicatorLeadingConstraint: NSLayoutConstraint?
    
    // Looks customization
    
    var selectionIndicatorHeight: CGFloat = 5.0
    var selectionIndicatorPosition: SelectionIndicatorPosition = .Bottom
    var selectionIndicatorColor: UIColor = .black {
        didSet {
            self.selectionIndicator.backgroundColor = selectionIndicatorColor
        }
    }
//    var titleTextAttributes: Dictionary
//    var selectedTitleTextAttributes: Dictionary
    
    var indexChangedHandler: ((index: Int) -> (Void))?
    var selectedSegmentIndex: Int = 0
    
    init(items: [String]) {
        self.items = items
        
        super.init(frame: CGRect.zero)
        
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.items = []
        
        super.init(coder: aDecoder)
        commonInit()
    }
    
    func commonInit() {
        addSubview(stackView)
        addSubview(selectionIndicator)
        bringSubview(toFront: selectionIndicator)
        
        addButtonsForItems(items: items)
    }
    
    override func updateConstraints() {
        NSLayoutConstraint.activate([
            stackView.widthAnchor.constraint(equalTo: widthAnchor),
            stackView.heightAnchor.constraint(equalTo: heightAnchor),
            stackView.centerXAnchor.constraint(equalTo: centerXAnchor),
            stackView.centerYAnchor.constraint(equalTo: centerYAnchor)
            ])

        selectionIndicatorLeadingConstraint = selectionIndicator.leadingAnchor.constraint(equalTo: stackView.leadingAnchor)
        
        let selectionIndicatorPositionConstraint: NSLayoutConstraint
        
        if selectionIndicatorPosition == .Top {
            selectionIndicatorPositionConstraint = selectionIndicator.topAnchor.constraint(equalTo: stackView.topAnchor)
        } else {
            selectionIndicatorPositionConstraint = selectionIndicator.bottomAnchor.constraint(equalTo: stackView.bottomAnchor)
        }
        
        NSLayoutConstraint.activate([
            selectionIndicator.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 1.0 / CGFloat(items.count), constant: 0),
            selectionIndicator.heightAnchor.constraint(equalToConstant: selectionIndicatorHeight),
            selectionIndicatorPositionConstraint,
            selectionIndicatorLeadingConstraint!
            ])
        
        super.updateConstraints()
    }
    
    func addButtonsForItems(items: [String]) {
        for (index, item) in items.enumerated() {
            let button = buttonForItem(item: item, atIndex: index)
            stackView.addArrangedSubview(button)
        }
    }
    
    func buttonForItem(item: String, atIndex index: Int) -> UIButton {
        let button = UIButton()
        button.setTitle(item, for: .normal)
        button.addTarget(self, action: #selector(HMSegmentedControl.tappedSegmentButton), for: .touchUpInside)
        // TODO: Set button title text attributes to a dictionary property set by the developer
        button.tag = index
        button.setTitleColor(.black, for: .normal)
        return button
    }
    
    func tappedSegmentButton(sender: UIButton) {
        let indexChanged: Bool = sender.tag != selectedSegmentIndex
        selectedSegmentIndex = sender.tag
        
        if let indexChangedHandler = indexChangedHandler, indexChanged == true {
            indexChangedHandler(index: selectedSegmentIndex)
        }
        
        let segmentWidth = stackView.frame.size.width / CGFloat(items.count)
        selectionIndicatorLeadingConstraint?.constant = segmentWidth * CGFloat(sender.tag)
        
        UIView.animate(withDuration: 0.25, animations: {
            self.layoutIfNeeded()
        })
    }
    
}
