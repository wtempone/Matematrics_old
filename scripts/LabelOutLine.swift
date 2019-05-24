import UIKit
class LabelOutline: UILabel {
    var strokeColor = UIColor()
    var foreColor = UIColor()
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder:aDecoder)
        self.setup()
    }
    
    override init(frame:CGRect) {
        super.init(frame:frame)
        self.setup()
    }
    
    override  func awakeFromNib() {
        super.awakeFromNib()
        self.setup()
    }
    override class func layerClass() -> AnyClass {
        return CATextLayer.self
    }

    func setup() {
        self.text = self.text
        self.textColor = self.textColor
        self.font = self.font
        self.layer.display()
            let shadow : NSShadow = NSShadow()
            
            shadow.shadowColor = UIColor(red: 58/255, green: 35/255, blue: 10/255, alpha: 1)
            let textFontAttributes = [
                NSFontAttributeName : font,
                // Note: SKColor.whiteColor().CGColor breaks this
                NSForegroundColorAttributeName: UIColor.greenColor(),
                NSStrokeColorAttributeName: UIColor.redColor(), // (red: 58/255, green: 35/255, blue: 10/255, alpha: 1),
                // Note: Use negative value here if you want foreground color to show
                NSStrokeWidthAttributeName: -5
            ]
            let myMutableString = NSMutableAttributedString(
                string: String(stringInterpolationSegment: self.text),
                attributes: textFontAttributes)
            self.attributedText = myMutableString
            self.textAlignment = NSTextAlignment.Center
            
    
    }
}