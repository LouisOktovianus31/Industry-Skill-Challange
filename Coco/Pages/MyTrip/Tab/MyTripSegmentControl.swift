//
//  MyTripSegmentControl.swift
//  Coco
//
//  Created by Arin Juan Sari on 18/08/25.
//

import UIKit

extension UISegmentedControl {
    
    private var underlineWidth: CGFloat { 100 }
    
    private var underlineHeight: CGFloat { 2 }
    
    private var segmentWidth: CGFloat {
         bounds.width / CGFloat(numberOfSegments)
    }
    
    private var segmentMinX: CGFloat {
        segmentWidth * CGFloat(selectedSegmentIndex)
    }
    
    private var underlineMinX: CGFloat {
        segmentMinX + (segmentWidth/2) - (underlineWidth/2)
    }
    
    private var underlineMinY: CGFloat {
        bounds.height + 2.0
    }
    
    func setup() {
        style()
        transparentBackground()
        addUnderline()
    }
    
    func style() {
        clipsToBounds = false
        tintColor = .clear
        backgroundColor = .clear
        if #available(iOS 13.0, *) {
            selectedSegmentTintColor = .clear
        }
        selectedSegmentIndex = 0
        setTitleTextAttributes([.font: UIFont.boldSystemFont(ofSize: 18), .foregroundColor: UIColor(Token.mainColorPrimary.toColor())], for: .selected)
        setTitleTextAttributes([.font: UIFont.systemFont(ofSize: 16), .foregroundColor: UIColor.black], for: .normal)
        sizeToFit()
    }

//    func transparentBackground() {
//        let backgroundImage = UIImage.coloredRectangleImageWith(color: UIColor.clear.cgColor, andSize: self.bounds.size)
//        let dividerImage = UIImage.coloredRectangleImageWith(color: UIColor.clear.cgColor, andSize: CGSize(width: 1, height: self.bounds.height))
//        setBackgroundImage(backgroundImage, for: .normal, barMetrics: .default)
//        setBackgroundImage(backgroundImage, for: .selected, barMetrics: .default)
//        setBackgroundImage(backgroundImage, for: .highlighted, barMetrics: .default)
//        setDividerImage(dividerImage, forLeftSegmentState: .normal, rightSegmentState: .normal, barMetrics: .default)
//    }
    
    // sementara
    func transparentBackground() {
        let bg = UIImage.coloredRectangle(color: .clear, size: bounds.size, opaque: false)
        let divider = UIImage.coloredRectangle(color: .clear, size: CGSize(width: 1, height: bounds.height), opaque: false)

        setBackgroundImage(bg, for: .normal, barMetrics: .default)
        setBackgroundImage(bg, for: .selected, barMetrics: .default)
        setBackgroundImage(bg, for: .highlighted, barMetrics: .default)
        setDividerImage(divider, forLeftSegmentState: .normal, rightSegmentState: .normal, barMetrics: .default)
    }

    func addUnderline() {
        let underlineFrame = CGRect(x: underlineMinX, y: underlineMinY, width: underlineWidth, height: underlineHeight)
        let underline = UIView(frame: underlineFrame)
        underline.backgroundColor = UIColor(Token.mainColorPrimary.toColor())
        underline.tag = 1
        self.addSubview(underline)
    }
    
    func setSelectedSegmentUnderline() {
        guard let underline = self.viewWithTag(1) else {return}
        UIView.animate(withDuration: 0.1, animations: {
            underline.frame.origin.x = self.underlineMinX
        })
    }
}

// MARK: - UIImage extension
//extension UIImage {
//    class func coloredRectangleImageWith(color: CGColor, andSize size: CGSize) -> UIImage {
//        UIGraphicsBeginImageContextWithOptions(size, false, 0.0)
//        let graphicsContext = UIGraphicsGetCurrentContext()
//        graphicsContext?.setFillColor(color)
//        let rectangle = CGRect(x: 0.0, y: 0.0, width: size.width, height: size.height)
//        graphicsContext?.fill(rectangle)
//        let rectangleImage = UIGraphicsGetImageFromCurrentImageContext()
//        UIGraphicsEndImageContext()
//        return rectangleImage!
//    }
//
//}

// sementara
extension UIImage {
    static func coloredRectangle(color: UIColor, size: CGSize,
                                 opaque: Bool = false,
                                 scale: CGFloat = UIScreen.main.scale) -> UIImage {
        let format = UIGraphicsImageRendererFormat()
        format.opaque = opaque
        format.scale = scale

        let renderer = UIGraphicsImageRenderer(size: size, format: format)
        return renderer.image { ctx in
            color.setFill()
            ctx.fill(CGRect(origin: .zero, size: size))
        }
    }
}
