import UIKit
import Charts
import TinyConstraints
import RealmSwift
class WeightHistoryViewController: UIViewController, ChartViewDelegate {
    @IBOutlet weak var containerView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        containerView.center = view.center
        view.addSubview(containerView)
        print("progress history viewloaded")

        
    }

    
    
}
