import UIKit
import WebKit

class PrivacyPolicyViewController: UIViewController {
    @IBOutlet weak var privacyPolicyWebView: WKWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let url = Bundle.main.url(forResource: "privacy_policy",
                                     withExtension: "html") {
            let request = URLRequest(url: url)
            privacyPolicyWebView.load(request)
        }
    }
    
    @IBAction func close() {
        dismiss(animated: true, completion: nil)
    }
}
