//
//  MainViewController.swift
//  GaryCam
//
//  Created by 정종문 on 2021/01/21.
//

import UIKit

class MainViewController: UIViewController {

    var info: MemberTempInfo?
    
    @IBOutlet weak var nameView: UILabel!
    @IBOutlet weak var tidView: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let info = info {
            self.nameView.text = info.name
            self.tidView.text = info.tid?.braketText
        } else {
            self.nameView.isHidden = true
            self.tidView.isHidden = true
        }
    }
    
    @IBAction func moveCameraView(_ sender: UIButton) {
        guard let cameraView = self.storyboard?.instantiateViewController(identifier: "CameraView") else {
            return
        }
        self.present(cameraView, animated: true)
    }
}
