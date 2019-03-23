//
//  XAxisLayer.swift
//  Chart
//
//  Created by Vojko Vladimir on 3/20/19.
//  Copyright © 2019 Vojko Vladimir. All rights reserved.
//

import QuartzCore

private let preferredText = "Jan 01"
private let titleSpacing = CGFloat(10)

class XAxisLayer: CALayer {
    private static var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d"
        return formatter
    }()
    
    override var frame: CGRect {
        get {
            return super.frame
        }
        set {
            super.frame = newValue
            textContainer.size = newValue.size
            update()
        }
    }
    
    var textColor: CGColor = UIColor.gray.cgColor {
        didSet {
            textLayers.forEach {
                $0.foregroundColor = textColor
            }
            setNeedsDisplay()
        }
    }
    
    var textSize: CGFloat {
        get {
            return font.pointSize
        }
        set {
            font = UIFont.systemFont(ofSize: newValue)
        }
    }
    
    var chart: Chart = .empty {
        didSet {
            if chart != oldValue {
                titles = chart.xTitles(formatter: XAxisLayer.dateFormatter)
            }
        }
    }
    
    var range: Range<Int> = .zero
    
    private var titles = [String]() {
        didSet {
            updateLayers()
        }
    }
    
    private var textLayers : [CATextLayer] {
        return sublayers as? [CATextLayer] ?? []
    }
    
    private lazy var font = UIFont.systemFont(ofSize: UIFont.systemFontSize)
    
    private var attributes: [NSAttributedString.Key: Any] {
        return [.font: font]
    }
    
    private lazy var textContainer = NSTextContainer(size: frame.size)
    private lazy var layoutManager: NSLayoutManager = {
        let manager = NSLayoutManager()
        manager.addTextContainer(textContainer)
        return manager
    }()

    func preferredFrameHeight() -> CGFloat {
        let textStorage = NSTextStorage(string: preferredText, attributes: attributes)
        textStorage.addLayoutManager(layoutManager)
        let size = textStorage.size()
        textStorage.removeLayoutManager(layoutManager)
        return size.height
    }
    
    private func updateLayers() {
        removeAllSublayers()
        
        var textLayer: CATextLayer!
        
        for title in titles {
            textLayer = CATextLayer()
            textLayer.string = title
            textLayer.rasterizationScale = UIScreen.main.scale
            textLayer.contentsScale = UIScreen.main.scale
            textLayer.alignmentMode = .center
            textLayer.font = font
            textLayer.fontSize = font.pointSize
            textLayer.foregroundColor = textColor
            textLayer.backgroundColor = UIColor.clear.cgColor
            
            addSublayer(textLayer)
        }
    }
    
    func update() {
        guard let maxTitleWidth = titles.compactMap({
            $0.size(in: layoutManager, attributes: attributes).width
        }).max() else { return }
        
        let titleWidth = titleSpacing + maxTitleWidth
        let titlesCount = Int((bounds.width / titleWidth).rounded(.down))
        
        let step = range.step(max: titlesCount)
        
        let space = (bounds.width - titleWidth * CGFloat(step.max)) / CGFloat(step.max - 1)
        
        var position = CGPoint.zero
        
        let size = CGSize(width: titleWidth, height: bounds.height)
        
        position.x = -CGFloat(range.startIndex / step.count) * (titleWidth + space)
        
        for (index, layer) in textLayers.enumerated() {
            if index % step.count == 0 || index == range.endIndex {
                layer.frame = CGRect(origin: position, size: size)
                layer.opacity = 1.0
                
                position.x += titleWidth + space
            
            } else {
                layer.frame = CGRect(origin: position, size: size)
                layer.opacity = 0.0
            }
        }
    }
}

extension String {
    func size(in layoutManager: NSLayoutManager, attributes: [NSAttributedString.Key: Any]) -> CGSize {
        let textStorage = NSTextStorage(string: self, attributes: attributes)
        textStorage.addLayoutManager(layoutManager)
        let size = textStorage.size()
        textStorage.removeLayoutManager(layoutManager)
        return size
    }
}

private extension Date {
    private static let secondInMillisecond = TimeInterval(1000)
    
    init(millisecondsSince1970 milliseconds: Int) {
        self.init(timeIntervalSince1970: TimeInterval(milliseconds) / Date.secondInMillisecond)
    }
    
}

private extension Chart {
    func xTitles(formatter: DateFormatter) -> [String] {
        return x.compactMap { formatter.string(from: Date(millisecondsSince1970: $0)) }
    }
}

private extension Range where Bound == Int {
    func step(max: Int) -> (count: Int, max: Int) {
        guard max < count else { return (1, count) }
        
        var max = max
        
        while (count - max) % (max - 1) != 0 {
            max -= 1
        }
        
        let step = (count - max) / (max - 1) + 1
        return (count: step, max: max)
    }
}
