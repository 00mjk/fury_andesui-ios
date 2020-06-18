//
//  AndesCaheckbox.swift
//  AndesUI
//
//  Created by Rodrigo Pintos Costa on 6/15/20.
//

import Foundation
import UIKit

@objc public class AndesCheckbox: UIView {
    internal var contentView: AndesCheckboxView!

    /// Sets the title of the AndesCheckbox
    @IBInspectable public var title: String? {
        didSet {
            self.updateContentView()
        }
    }

    /// Sets the type of the AndesCaheckbox , default idle
    @IBInspectable public var type: AndesCheckboxType = .idle {
        didSet {
            self.updateContentView()
        }
    }

    /// Sets the slign of the AndesCaheckbox , default left
    @IBInspectable public var align: AndesCheckboxAlign = .left {
        didSet {
            self.updateContentView()
        }
    }

    /// Sets the status of the AndesCaheckbox , default unselected
    @IBInspectable public var status: AndesCheckboxStatus = .unselected {
        didSet {
            self.updateContentView()
        }
    }

    /// Callback invoked when dismiss button is tapped
    internal var didTapped: ((AndesCheckbox) -> Void)?

    /// Set dismiss callback to be invoked when dismiss button is pressed
    @objc public func setCheckboxTapped(callback: @escaping ((AndesCheckbox) -> Void)) {
        self.didTapped = callback
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }

    public override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    @objc public init(type: AndesCheckboxType, align: AndesCheckboxAlign, status: AndesCheckboxStatus, title: String) {
        super.init(frame: .zero)
        self.title = title
        self.type = type
        self.align = align
        self.status = status
        setup()
    }

    public func setup() {
        translatesAutoresizingMaskIntoConstraints = false
        self.backgroundColor = .clear
        let config = AndesCheckboxViewConfig(for: self)
        contentView = AndesCheckboxDefaultView(withConfig: config)
        self.addSubview(contentView)
        contentView.pinToSuperview()
        contentView.delegate = self
    }

    private func updateContentView() {
        let config = AndesCheckboxViewConfig(for: self)
        contentView.update(withConfig: config)
    }
}

extension AndesCheckbox: AndesCheckboxViewDelegate {
    func checkboxTapped() {
        guard let callback = self.didTapped else {
            return
        }
        switch self.type {
        case .error:
            self.type = AndesCheckboxType.idle
            self.status = AndesCheckboxStatus.selected
        case .idle:
            if self.status == AndesCheckboxStatus.selected {
                self.status = AndesCheckboxStatus.unselected
            } else if self.status == AndesCheckboxStatus.unselected ||                   self.status == AndesCheckboxStatus.undefined {
                self.status = AndesCheckboxStatus.selected
            }
        case .disabled:
            //Never happend
            return
        }
        setup()
        callback(self)
    }
}

// MARK: - IB interface
public extension AndesCheckbox {
    @available(*, unavailable, message: "This property is reserved for Interface Builder. Use 'type' instead.")
    @IBInspectable var ibType: String {
        set(val) {
            self.type = AndesCheckboxType.checkValidEnum(property: "IB type", key: val)
        }
        get {
            return self.type.toString()
        }
    }

    @available(*, unavailable, message: "This property is reserved for Interface Builder. Use 'status' instead.")
    @IBInspectable var ibStatus: String {
        set(val) {
            self.status = AndesCheckboxStatus.checkValidEnum(property: "IB status", key: val)
        }
        get {
            return self.status.toString()
        }
    }

    @available(*, unavailable, message: "This property is reserved for Interface Builder. Use 'align' instead.")
    @IBInspectable var ibAlign: String {
        set(val) {
            self.align = AndesCheckboxAlign.checkValidEnum(property: "IB align", key: val)
        }
        get {
            return self.align.toString()
        }
    }
}