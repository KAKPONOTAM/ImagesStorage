import Foundation
import UIKit

class ImageZoomView: UIScrollView, UIScrollViewDelegate {
    
    var image: UIImage? {
        didSet {
            self.imageView.image = image
        }
    }
    
    private var imageView: UIImageView!
    private var gestureRecognizer: UITapGestureRecognizer!
    
    override func awakeFromNib() {
        imageView = UIImageView()
        imageView.frame = bounds
        
        imageView.isUserInteractionEnabled = true
        imageView.contentMode = .scaleToFill
        imageView.frame = CGRect(x: 0, y: 100, width: self.frame.width, height: self.frame.size.height / 2)
        addSubview(imageView)
        
        setupScrollView()
        setupGestureRecognizer()
    }
    
    // Sets the scroll view delegate and zoom scale limits.
    // Change the `maximumZoomScale` to allow zooming more than 2x.
    func setupScrollView() {
        delegate = self
        
        minimumZoomScale = 1.0
        maximumZoomScale = 2.0
    }
    
    // Sets up the gesture recognizer that receives double taps to auto-zoom
    func setupGestureRecognizer() {
        gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleDoubleTap))
        gestureRecognizer.numberOfTapsRequired = 2
        addGestureRecognizer(gestureRecognizer)
    }


    // Handles a double tap by either resetting the zoom or zooming to where was tapped
    @IBAction func handleDoubleTap() {
        if zoomScale == 1 {
            zoom(to: zoomRectForScale(maximumZoomScale, center: gestureRecognizer.location(in: gestureRecognizer.view)), animated: true)
        } else {
            setZoomScale(1, animated: true)
        }
    }


    // Calculates the zoom rectangle for the scale
    func zoomRectForScale(_ scale: CGFloat, center: CGPoint) -> CGRect {
        var zoomRect = CGRect.zero
        zoomRect.size.height = imageView.frame.size.height / scale
        zoomRect.size.width = imageView.frame.size.width / scale
        let newCenter = convert(center, from: imageView)
        zoomRect.origin.x = newCenter.x - (zoomRect.size.width / 2.0)
        zoomRect.origin.y = newCenter.y - (zoomRect.size.height / 2.0)
        return zoomRect
    }
    
    // Tell the scroll view delegate which view to use for zooming and scrolling
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }
    
    func configure(about images: AboutImages) {
        imageView.image = FileManager.loadImage(fileName: images.imageFileName)
    }
}
