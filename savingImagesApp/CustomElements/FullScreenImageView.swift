import UIKit

class FullScreenImageView: UIView {
    @IBOutlet weak var zoomScrollView: ImageZoomView!
    static func instanceFromNib() -> FullScreenImageView {
        guard let view = UINib(nibName: "FullScreenImageView", bundle: nil).instantiate(withOwner: nil, options: nil).first as? FullScreenImageView else { return FullScreenImageView() }
        return view
    }
    
    func configure(with images: AboutImages) {
        zoomScrollView.configure(about: images)
    }
}
