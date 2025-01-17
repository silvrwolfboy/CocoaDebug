//
//  Example
//  man
//
//  Created by man on 11/11/2018.
//  Copyright © 2018 man. All rights reserved.
//

import UIKit

class AppInfoViewController: UITableViewController, UIAlertViewDelegate {
    
    @IBOutlet weak var labelVersionNumber: UILabel!
    @IBOutlet weak var labelBuildNumber: UILabel!
    @IBOutlet weak var labelBundleName: UILabel!
    @IBOutlet weak var labelScreenResolution: UILabel!
    @IBOutlet weak var labelScreenSize: UILabel!
    @IBOutlet weak var labelDeviceModel: UILabel!
    @IBOutlet weak var labelCrashCount: UILabel!
    @IBOutlet weak var labelBundleID: UILabel!
    @IBOutlet weak var labelignoredURLs: UILabel!
    @IBOutlet weak var labelserverURL: UILabel!
    @IBOutlet weak var labelIOSVersion: UILabel!
    @IBOutlet weak var labelHtml: UILabel!
    @IBOutlet weak var crashSwitch: UISwitch!
    @IBOutlet weak var logSwitch: UISwitch!
    @IBOutlet weak var networkSwitch: UISwitch!
    @IBOutlet weak var webViewSwitch: UISwitch!
    
    
    //MARK: - init
    override func viewDidLoad() {
        super.viewDidLoad()
        
        labelCrashCount.frame.size = CGSize(width: 30, height: 20)

        labelVersionNumber.text = AppInfo.versionNumber
        labelBuildNumber.text = AppInfo.buildNumber
        labelBundleName.text = AppInfo.bundleName

        labelScreenResolution.text = Device.screenResolution
        labelScreenSize.text = "\(Device.screenSize)"
        labelDeviceModel.text = "\(Device.deviceModel)"
        
        labelBundleID.text = Bundle.main.bundleIdentifier
        labelignoredURLs.text = String(CocoaDebugSettings.shared.ignoredURLs?.count ?? 0)
        
        labelserverURL.text = CocoaDebugSettings.shared.serverURL
        labelIOSVersion.text = UIDevice.current.systemVersion
        
        if UIScreen.main.bounds.size.width == 320 {
            labelHtml.font = UIFont.systemFont(ofSize: 15)
        }
        
        crashSwitch.isOn = CocoaDebugSettings.shared.enableCrashRecording
        logSwitch.isOn = !CocoaDebugSettings.shared.disableLogMonitoring
        networkSwitch.isOn = !CocoaDebugSettings.shared.disableNetworkMonitoring
        webViewSwitch.isOn = CocoaDebugSettings.shared.enableWebViewMonitoring

        crashSwitch.addTarget(self, action: #selector(crashSwitchChanged), for: UIControl.Event.valueChanged)
        logSwitch.addTarget(self, action: #selector(logSwitchChanged), for: UIControl.Event.valueChanged)
        networkSwitch.addTarget(self, action: #selector(networkSwitchChanged), for: UIControl.Event.valueChanged)
        webViewSwitch.addTarget(self, action: #selector(webViewSwitchChanged), for: UIControl.Event.valueChanged)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let count = UserDefaults.standard.integer(forKey: "crashCount_CocoaDebug")
        labelCrashCount.text = "\(count)"
        labelCrashCount.textColor = count > 0 ? .red : .white
    }
    
    //MARK: - target action
    @objc func crashSwitchChanged(sender: UISwitch) {
        CocoaDebugSettings.shared.enableCrashRecording = crashSwitch.isOn
        UIAlertView.init(title: "", message: "You must restart APP to ensure the changes take effect", delegate: self, cancelButtonTitle: "Restart now", otherButtonTitles: "Restart later").show()
    }
    
    @objc func logSwitchChanged(sender: UISwitch) {
        CocoaDebugSettings.shared.disableLogMonitoring = !logSwitch.isOn
        UIAlertView.init(title: "", message: "You must restart APP to ensure the changes take effect", delegate: self, cancelButtonTitle: "Restart now", otherButtonTitles: "Restart later").show()
    }
    
    @objc func networkSwitchChanged(sender: UISwitch) {
        CocoaDebugSettings.shared.disableNetworkMonitoring = !networkSwitch.isOn
        UIAlertView.init(title: "", message: "You must restart APP to ensure the changes take effect", delegate: self, cancelButtonTitle: "Restart now", otherButtonTitles: "Restart later").show()
    }
    
    @objc func webViewSwitchChanged(sender: UISwitch) {
        CocoaDebugSettings.shared.enableWebViewMonitoring = webViewSwitch.isOn
        UIAlertView.init(title: "", message: "You must restart APP to ensure the changes take effect", delegate: self, cancelButtonTitle: "Restart now", otherButtonTitles: "Restart later").show()
    }
}

//MARK: - UIAlertViewDelegate
extension AppInfoViewController {
    func alertView(_ alertView: UIAlertView, clickedButtonAt buttonIndex: Int) {
        if buttonIndex == 0 {
            #if DEBUG
                exit(0)
            #endif
        }
    }
}

//MARK: - UITableViewDelegate
extension AppInfoViewController {
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat
    {
        if section == 0 {
            return 56
        }
        return 38
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        if indexPath.section == 1 && indexPath.row == 4 {
            if labelserverURL.text == nil || labelserverURL.text == "" {
                return 0
            }
        }
        if indexPath.section == 2 && indexPath.row == 1 {
            if labelScreenSize.text == "0.0" {
                return 0
            }
        }
        if indexPath.section == 4 && indexPath.row == 0 {
            if labelignoredURLs.text == "0" {
                if UIScreen.main.scale == 3 {
                    return 1.5//plus,iPhone X
                }
                return 0.5//iphone 5,6,6s,7,8
            }
        }
        return 44
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if indexPath.section == 1 && indexPath.row == 2 {
            UIPasteboard.general.string = AppInfo.bundleName
            
            let alert = UIAlertController.init(title: "copied bundle name to clipboard", message: nil, preferredStyle: .alert)
            let action = UIAlertAction.init(title: "OK", style: .cancel, handler: nil)
            alert.addAction(action)
            if #available(iOS 13, *) {alert.modalPresentationStyle = .fullScreen}
            self.present(alert, animated: true, completion: nil)
        }
        
        if indexPath.section == 1 && indexPath.row == 3 {
            UIPasteboard.general.string = Bundle.main.bundleIdentifier
            
            let alert = UIAlertController.init(title: "copied bundle id to clipboard", message: nil, preferredStyle: .alert)
            let action = UIAlertAction.init(title: "OK", style: .cancel, handler: nil)
            alert.addAction(action)
            if #available(iOS 13, *) {alert.modalPresentationStyle = .fullScreen}
            self.present(alert, animated: true, completion: nil)
        }
        
        if indexPath.section == 1 && indexPath.row == 4 {
            if labelserverURL.text == nil || labelserverURL.text == "" {
                return
            }
            
            UIPasteboard.general.string = CocoaDebugSettings.shared.serverURL
            
            let alert = UIAlertController.init(title: "copied server to clipboard", message: nil, preferredStyle: .alert)
            let action = UIAlertAction.init(title: "OK", style: .cancel, handler: nil)
            alert.addAction(action)
            if #available(iOS 13, *) {alert.modalPresentationStyle = .fullScreen}
            self.present(alert, animated: true, completion: nil)
        }
    }
}
