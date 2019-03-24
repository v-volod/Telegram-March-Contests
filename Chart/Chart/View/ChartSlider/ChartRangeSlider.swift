//
//  ChartRangeSlider.swift
//  Chart
//
//  Created by Vojko Vladimir on 3/15/19.
//  Copyright © 2019 Vojko Vladimir. All rights reserved.
//

import UIKit
import QuartzCore

private let defaultMinimumValue: CGFloat = 0.0
private let defaultMaximumValue: CGFloat = 1.0

private let trackOffset: CGFloat = 1.0
private let touchOffset: CGFloat = 10

private let minThumbBorderWidth: CGFloat = 1.0
private let maxThumbBorderWidth: CGFloat = 4.0

private let minThumbHandleWidth: CGFloat = minThumbBorderWidth
private let maxThumbHandleWidth: CGFloat = 20.0

private let defaultThumbColor = UIColor.black.withAlphaComponent(0.5)
private let defaultThumbArrowColor = UIColor.white.withAlphaComponent(0.5)

@IBDesignable
open class ChartRangeSlider: UIControl {
    open override var frame: CGRect {
        didSet {
            updateLayerFrames()
        }
    }
    
    var chartLayer = ChartLayer()
    var trackLayer = CAShapeLayer()
    var thumbLayer = ThumbLayer()
    
    @IBInspectable public var trackColor: UIColor = .clear {
        didSet {
            trackLayer.fillColor = trackColor.cgColor
            trackLayer.setNeedsDisplay()
        }
    }
    
    @IBInspectable public var thumbColor: UIColor = defaultThumbColor {
        didSet {
            thumbLayer.fillColor = thumbColor.cgColor
            thumbLayer.setNeedsDisplay()
        }
    }
    
    @IBInspectable public var thumbArrowColor: UIColor = defaultThumbArrowColor {
        didSet {
            thumbLayer.arrowColor = thumbArrowColor.cgColor
            thumbLayer.setNeedsDisplay()
        }
    }
    
    private var _thumbBorderWidth: CGFloat = minThumbBorderWidth {
        didSet {
            updateLayerFrames()
        }
    }
    @IBInspectable public var thumbBorderWidth: CGFloat {
        get {
            return _thumbBorderWidth
        }
        set {
            _thumbBorderWidth = bound(newValue, min: minThumbBorderWidth, max: maxThumbBorderWidth)
        }
    }
    private var _thumbHandleWidth: CGFloat = minThumbHandleWidth {
        didSet {
            updateLayerFrames()
        }
    }
    @IBInspectable public var thumbHandleWidth: CGFloat {
        get {
            return _thumbHandleWidth
        }
        set {
            _thumbHandleWidth = bound(newValue, min: minThumbHandleWidth, max: maxThumbHandleWidth)
        }
    }
    
    private var _thumbHandleCornerRadius: CGFloat = 0 {
        didSet {
            updateLayerFrames()
        }
    }
    @IBInspectable public var thumbHandleCornerRadius: CGFloat {
        get {
            return _thumbHandleCornerRadius
        }
        set {
            _thumbHandleCornerRadius = bound(newValue, min: 0, max: maxThumbHandleWidth / 2)
        }
    }
    
    private var _minimumValue: CGFloat = defaultMinimumValue {
        didSet {
            updateThumbFrameIfNeeded()
        }
    }
    @IBInspectable public var minimumValue: CGFloat {
        get {
            return _minimumValue
        }
        set {
            _minimumValue = max(defaultMinimumValue, newValue)
            lowerValue = _lowerValue
        }
    }
    private var _maximumValue: CGFloat = defaultMaximumValue {
        didSet {
            updateThumbFrameIfNeeded()
        }
    }
    @IBInspectable public var maximumValue: CGFloat {
        get {
            return _maximumValue
        }
        set {
            _maximumValue = min(defaultMaximumValue, newValue)
            upperValue = _upperValue
        }
    }
    private var _lowerValue: CGFloat = defaultMinimumValue {
        didSet {
            updateThumbFrameIfNeeded()
        }
    }
    @IBInspectable public var lowerValue: CGFloat {
        get {
            return _lowerValue
        }
        set {
            // TODO: Add valiation.
            _lowerValue = max(minimumValue, min(_upperValue, round(value: newValue)))
        }
    }
    private var _upperValue: CGFloat = defaultMaximumValue {
        didSet {
            updateThumbFrameIfNeeded()
        }
    }
    @IBInspectable public var upperValue: CGFloat {
        get {
            return _upperValue
        }
        set {
            // TODO: Add valiation.
            _upperValue = min(maximumValue, max(_lowerValue, round(value: newValue)))
        }
    }
    
    private var _isStepped: Bool = true
    @IBInspectable public var isStepped: Bool {
        get {
            return _isStepped && chart.x.count > 0
        }
        set {
            _isStepped = newValue
            
            updateRangeStep()
        }
    }
    
    @IBInspectable public var isContinuous: Bool = true
    
    private var rangeStep: CGFloat = 0 {
        didSet {
            upperValue = _upperValue
            lowerValue = _lowerValue
        }
    }
    
    public var chart: Chart = .empty {
        didSet {
            chartLayer.setChart(chart)
            
            updateRangeStep()
        }
    }
    
    public var range: Range<Int> {
        get {
            let count = CGFloat(chart.x.count)
            let startIndex = (lowerValue * count).rounded(.toNearestOrAwayFromZero)
            let endIndex = (upperValue * count).rounded(.toNearestOrAwayFromZero)
            return Int(startIndex) ..< Int(endIndex)
        }
        set {
            let count = CGFloat(chart.x.count)
            lowerValue = round(value: CGFloat(newValue.startIndex) / count)
            upperValue = round(value: CGFloat(newValue.endIndex) / count)
        }
    }
    
    public var trackingType = TrackingType.nothing
    
    private var previousLocation = CGPoint()
    private lazy var previousLowerValue = self.lowerValue
    private lazy var previousUpperValue = self.upperValue
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        
        initLayers()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        initLayers()
    }
    
    private func initLayers() {
        layer.addSublayer(chartLayer)
        layer.addSublayer(trackLayer)
        layer.addSublayer(thumbLayer)
        
        chartLayer.borderColor = UIColor.blue.cgColor
        chartLayer.lineWidth = 1.0
    }
    
    open override func layoutSubviews() {
        super.layoutSubviews()
        
        updateLayerFrames()
    }

    private func updateLayerFrames() {
        let trackOrigin = CGPoint(x: 0, y: thumbBorderWidth)
        let trackSize = CGSize(width: frame.width, height: frame.height - 2 * thumbBorderWidth)
        let trackFrame = CGRect(origin: trackOrigin, size: trackSize)
        
        trackLayer.frame = trackFrame
        
        let chartOffset = trackOffset + thumbBorderWidth
        let chartOrigin = CGPoint(x: 0, y: trackOrigin.y + chartOffset)
        let chartSize = CGSize(width: trackSize.width, height: trackSize.height - 2 * chartOffset)
        let chartFrame = CGRect(origin: chartOrigin, size: chartSize)
        chartLayer.frame = chartFrame
        
        updateThumbLayerFrame()
    }
    
    private func updateThumbFrameIfNeeded() {
        if (!isTracking) {
            updateThumbLayerFrame()
        }
    }
    
    private func updateThumbLayerFrame(resize: Bool = true) {
        let thumbWidth = bounds.width * (_upperValue - _lowerValue)
        let thumbPosition = CGPoint(x: bounds.width * _lowerValue, y: 0)
        let thumbSize = CGSize(width: thumbWidth, height: frame.height)

        trackLayer.setTrack(x: thumbPosition.x, width: thumbWidth)
        
        if (resize) {
            thumbLayer.setSize(thumbSize,
                               border: thumbBorderWidth,
                               handle: thumbHandleWidth,
                               corner: thumbHandleCornerRadius)
        }
        
        thumbLayer.position = thumbPosition
    }
    
    private func updateRangeStep() {
        rangeStep = chart.x.count == 0 ? 0 : CGFloat(1) / CGFloat(chart.x.count)
    }
    
    open override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        
        chart = .interfaceBuilderChart
    }
    
    public func update() {
        chartLayer.update()
    }
    
}

// Mark - Touch events

extension ChartRangeSlider {
    open override func beginTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
        previousLowerValue = lowerValue
        previousUpperValue = upperValue
        
        previousLocation = touch.location(in: self)
        
        let x = previousLocation.x
        
        let lowerRangeStart = thumbLayer.frame.minX - touchOffset
        var lowerRangeEnd = thumbLayer.frame.minX + thumbHandleWidth
        
        var upperRangeStart = thumbLayer.frame.maxX - thumbHandleWidth
        let upperRangeEnd = thumbLayer.frame.maxX + touchOffset
        
        if (lowerRangeEnd + touchOffset < upperRangeStart - touchOffset) {
            lowerRangeEnd += touchOffset
            upperRangeStart -= touchOffset
        }
        
        let lowerRange = lowerRangeStart ..< lowerRangeEnd
        let upperRange = upperRangeStart ..< upperRangeEnd
        
        let thumbRange = (lowerRange.upperBound ..< upperRange.lowerBound)
        
        if (lowerRange.contains(x)) {
            trackingType = .lower
        } else if (upperRange.contains(x)) {
            trackingType = .upper
        } else if (thumbRange.contains(x)) {
            trackingType = .position
        } else {
            trackingType = .nothing
        }
        
        return trackingType != .nothing
    }
    
    open override func continueTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
        let location = touch.location(in: self)
        
        let deltaX = location.x - previousLocation.x
        var deltaValue = (maximumValue - minimumValue) * deltaX / bounds.width
        deltaValue = round(value: deltaValue)
        
        previousLocation = location
        
        let newLowerValue = _lowerValue + deltaValue
        let newUpperValue = _upperValue + deltaValue
        
        let widthValue = (2 * thumbHandleWidth + touchOffset) / frame.width
        
        switch trackingType {
        case .position:
            let width = _upperValue - _lowerValue
            
            if (deltaValue < 0) {
                _lowerValue = max(_minimumValue, newLowerValue)
                _upperValue = max(_lowerValue + width, newUpperValue)
            } else {
                _upperValue = min(_maximumValue, newUpperValue)
                _lowerValue = min(_upperValue - width, newLowerValue)
            }
            
        case .lower:
            _lowerValue = bound(newLowerValue, min: _minimumValue, max: _upperValue - widthValue)
            
        case .upper:
            _upperValue = bound(newUpperValue, min: _lowerValue + widthValue, max: _maximumValue)
            
        default:
            return true
        }

        CATransaction.begin()
        CATransaction.setDisableActions(true)
        
        updateThumbLayerFrame(resize: trackingType != .position)
        
        CATransaction.commit()
        
        if (isContinuous) {
            sendActions(for: .valueChanged)
        }
        
        return true
    }
    
    open override func endTracking(_ touch: UITouch?, with event: UIEvent?) {
        trackingType = .nothing
        
        if (lowerValue != previousLowerValue || upperValue != previousUpperValue) {
            sendActions(for: .valueChanged)
        }
    }
    
    open override func cancelTracking(with event: UIEvent?) {
    }
}

// Mark - Stepped Value -

extension ChartRangeSlider {
    func round(value: CGFloat) -> CGFloat {
        return isStepped ? rangeStep * (value / rangeStep).rounded(.toNearestOrAwayFromZero) : value
    }
}
