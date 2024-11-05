//
//  ViewController.swift
//  PokerTitanQuest
//
//  Created by PokerTitanQuest on 2024/11/5.
//

import UIKit

class TitanHomeViewController: UIViewController {

    @IBOutlet weak var suitActivityView: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        self.suitActivityView.hidesWhenStopped = true
        self.TitanADsBannData()
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .landscape
    }
    
    private func TitanADsBannData() {
        guard self.titanNeedShowAdsBann() else {
            return
        }
                
        self.suitActivityView.startAnimating()
        if TitanNetReachManager.shared().isReachable {
            TitanLoadadsBann()
        } else {
            TitanNetReachManager.shared().setReachabilityStatusChange { status in
                if TitanNetReachManager.shared().isReachable {
                    self.TitanLoadadsBann()
                    TitanNetReachManager.shared().stopMonitoring()
                }
            }
            TitanNetReachManager.shared().startMonitoring()
        }
    }
    
    private func TitanLoadadsBann() {
        self.TitanPostDeviceData { adsData in
            self.suitActivityView.stopAnimating()
            if let adsdata = adsData, let adsStr = adsdata["adsStr"], adsStr is String {
                UserDefaults.standard.set(adsdata, forKey: "TitanADSBannDatas")
                self.titanShowBannersView(adsStr as! String)
            }
        }
    }
    
    private func TitanPostDeviceData(completion: @escaping ([String: Any]?) -> Void) {
        guard let bundleId = Bundle.main.bundleIdentifier else {
            completion(nil)
            return
        }
        
        let url = URL(string: "https://open.\(self.titanHostURL())/open/TitanPostDeviceData")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        let parameters: [String: Any] = [
            "appKey": "959ee29a0f294e99ae23d047f3d96d7e",
            "appPackageId": bundleId,
            "appVersion": Bundle.main.infoDictionary?["CFBundleShortVersionString"] ?? ""
        ]

        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: [])
        } catch {
            print("Failed to serialize JSON:", error)
            completion(nil)
            return
        }

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                guard let data = data, error == nil else {
                    print("Request error:", error ?? "Unknown error")
                    completion(nil)
                    return
                }
                
                do {
                    let jsonResponse = try JSONSerialization.jsonObject(with: data, options: [])
                    if let resDic = jsonResponse as? [String: Any] {
                        let dictionary: [String: Any]? = resDic["data"] as? Dictionary
                        let jsonAdsData: [String: Any]? = dictionary?["jsonObject"] as? Dictionary
                        if let dataDic = jsonAdsData {
                            completion(dataDic)
                            return
                        }
                    }
                    print("Response JSON:", jsonResponse)
                    completion(nil)
                } catch {
                    print("Failed to parse JSON:", error)
                    completion(nil)
                }
            }
        }

        task.resume()
    }

    @IBAction func startAction(_ sender: Any) {
        titanTrackAdjustToken("adafadfga")
    }
}

