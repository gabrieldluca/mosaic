import UIKit

class CircularProgressView: UIView {
    
    var endAngle:CGFloat = CGFloat(0.0) {
        didSet {
            self.createArc()
            self.setNeedsDisplay()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    private func createArc() {
        // MARK: Removing sublayers
        if let sublayers = self.layer.sublayers {
            for sub in sublayers {
                sub.removeFromSuperlayer()
            }
        }
        
        // MARK: Adding path
        let circleLayer = CAShapeLayer()
        let path = UIBezierPath()
        path.addArc(withCenter: self.center, radius: CGFloat(20.0), startAngle: CGFloat(0.0), endAngle: self.endAngle, clockwise: true)
        
        // MARK: Customizing circle
        circleLayer.lineWidth = 5.0
        circleLayer.path = path.cgPath
        circleLayer.strokeColor = UIColor(red:0.57, green:0.36, blue:0.97, alpha:1.0).cgColor
        circleLayer.fillColor = UIColor.clear.cgColor
        self.layer.addSublayer(circleLayer)
    }
}
