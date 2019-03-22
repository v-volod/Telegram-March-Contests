//
//  XAxisLayer.swift
//  Chart
//
//  Created by Vojko Vladimir on 3/20/19.
//  Copyright © 2019 Vojko Vladimir. All rights reserved.
//

import QuartzCore

private let preferredText = "Jan 01"
private let titlesSpacing = CGFloat(10)

class XAxisLayer: CALayer {
    private var textLayers = [CATextLayer]()
    
    override var frame: CGRect {
        get {
            return super.frame
        }
        set {
            super.frame = newValue
            textContainer.size = newValue.size
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
    
    func update(titles: [String]) {
        removeAllSublayers()
        
        textLayers.removeAll()
        
        guard titles.count > 0 else { return }
        
        let titleWidths = titles.compactMap { $0.size(in: layoutManager, attributes: attributes).width }
        let maxTitleWidth = titleWidths.max() ?? 0
        
        let extraWidth = bounds.width + 2 * titlesSpacing
        let extraTitleWidth = maxTitleWidth + titlesSpacing

        let maxTitlesCount = Int((extraWidth / extraTitleWidth).rounded(.down))
        
        var textLayer: CATextLayer!
        
        var position = CGPoint.zero
        
        let step = titles.count.step(max: maxTitlesCount)
        
        var x: CGFloat = 0
        var size: CGSize = .zero
        let titleWidth = bounds.width / CGFloat(titles.count / step)

        var title: String!
        
        var index: Int!
        
        for offset in stride(from: 0, to: titles.count + step, by: step) {
            index = offset / step
            
            guard index < titles.count else { break }
            
            title = titles[index]
            
            x = CGFloat(index) * titleWidth

            textLayer = CATextLayer()
            textLayer.rasterizationScale = UIScreen.main.scale
            textLayer.contentsScale = UIScreen.main.scale
            textLayer.font = font
            textLayer.fontSize = font.pointSize
            textLayer.string = title
            textLayer.foregroundColor = textColor
            
            size = textLayer.preferredFrameSize()
            
            x += (titleWidth - size.width) / 2
            
            position = CGPoint(x: x, y: position.y)
            
            textLayer.frame = CGRect(origin: position, size: size)
            
            addSublayer(textLayer)
            
            textLayers.append(textLayer)
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
