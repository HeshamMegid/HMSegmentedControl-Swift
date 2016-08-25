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
//  * Set proper access control for propeties and functions
//  * Add scroll view
//  * Ability to add and remove items after initialization

class HMSegmentedControl: UIControl {
    enum SelectionIndicatorPosition {
        case Top
        case Bottom
    }
    
    var stackView: UIStackView = {
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
    
    var selectionIndicatorLeadingConstraint: NSLayoutConstraint?
    var items: [String]
    
    /// Height of the selection indicator stripe.
    var selectionIndicatorHeight: CGFloat = 5.0
    
    /// Position of the selection indicator stripe.
    var selectionIndicatorPosition: SelectionIndicatorPosition = .Bottom
    
    /// Color of the selection indicator stripe.
    var selectionIndicatorColor: UIColor = .black {
        didSet {
            self.selectionIndicator.backgroundColor = selectionIndicatorColor
        }
    }
    
    /// Text attributes to apply to labels of the unselected segments
    var titleTextAttributes: [String:AnyObject]? {
        didSet {
            if let titleTextAttributes = titleTextAttributes {
                setTitleAttributes(attributes: titleTextAttributes, forControlState: .normal)
            }
        }
    }
    
    /// Text attributes to apply to labels of the selected segments
    var selectedTitleTextAttributes: [String:AnyObject]? {
        didSet {
            if let selectedTitleTextAttributes = selectedTitleTextAttributes {
                setTitleAttributes(attributes: selectedTitleTextAttributes, forControlState: .selected)
            }
        }
    }
    
    var indexChangedHandler: ((index: Int) -> (Void))?
    private(set) var selectedSegmentIndex: Int = 0 {
        didSet {
            for button in stackView.arrangedSubviews {
                if let button = button as? UIButton {
                    button.isSelected = false
                }
            }
            
            let selectedButton = stackView.arrangedSubviews[selectedSegmentIndex] as! UIButton
            selectedButton.isSelected = true
        }
    }
    
    init(items: [String]) {
        self.items = items
        
        super.init(frame: CGRect.zero)
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.items = []
        
        super.init(coder: aDecoder)
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
    
    override func willMove(toSuperview newSuperview: UIView?) {
        addSubview(stackView)
        addSubview(selectionIndicator)
        bringSubview(toFront: selectionIndicator)
        
        addButtonsForItems(items: items)
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
        
        if let titleTextAttributes = titleTextAttributes {
            let attributedTitle = NSAttributedString(string: item, attributes: titleTextAttributes)
            button.setAttributedTitle(attributedTitle, for: .normal)
        } else {
            button.setTitleColor(.black, for: .normal)
        }
        
        if let selectedTitleTextAttributes = selectedTitleTextAttributes {
            let attributedTitle = NSAttributedString(string: item, attributes: selectedTitleTextAttributes)
            button.setAttributedTitle(attributedTitle, for: .selected)
        }
        
        button.tag = index
        return button
    }
    
    func tappedSegmentButton(sender: UIButton) {
        let newIndex = sender.tag
        let indexChanged: Bool = newIndex != selectedSegmentIndex
        selectedSegmentIndex = newIndex
        
        if let indexChangedHandler = indexChangedHandler, indexChanged == true {
            indexChangedHandler(index: selectedSegmentIndex)
        }
        
        setSelectedSegmentIndex(index: newIndex, animated: true)
    }
    
    func setTitleAttributes(attributes: [String:AnyObject], forControlState state: UIControlState) {
        for button in stackView.arrangedSubviews {
            if let button = button as? UIButton, let title = button.title(for: state) {
                let attributedTitle = NSAttributedString(string: title, attributes: attributes)
                button.setAttributedTitle(attributedTitle, for: state)
            }
        }
    }
    
    /**
     Changes the currently selected segment index.
     
     - parameter index: Index of the segment to select.
     - parameter animated: A boolean to specify whether the change should be animated or not
     */
    public func setSelectedSegmentIndex(index: Int, animated: Bool) {
        assert(index < items.count, "Attempting to set index to a segment that does not exist.")
        
        let segmentWidth = stackView.frame.size.width / CGFloat(items.count)
        selectionIndicatorLeadingConstraint?.constant = segmentWidth * CGFloat(index)
        
        if animated {
            UIView.animate(withDuration: 0.25, animations: {
                self.layoutIfNeeded()
            })
        } else {
            self.layoutIfNeeded()
        }
    }
}
