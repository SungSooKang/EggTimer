//
//  AnotherViewController.swift
//  EggTimer
//
//  Created by 강성수 on 2021/07/21.
//

import UIKit

class AnotherViewController: UIViewController {
    
    
    @IBOutlet weak var result: UILabel!
        
    var defaultResult : String = "DEFAULT"
    
//    let vc = ViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        print("Second : viewDidLoad")
        
        result?.text = defaultResult
    }
    
    @IBAction func back(_ sender: UIButton) {
        dismiss(animated: false, completion: nil)
    }
    
    // 뷰가 나타나려 할 때마다 호출 (가변성을 가진 작업)
    override func viewWillAppear(_ animated: Bool) {
        print("Second : viewWillAppear")
    }
    
    // 뷰가 완전히 나타나고 난 후 호출
    override func viewDidAppear(_ animated: Bool) {
        print("Second : viewDidAppear")
    }

    // 뷰가 사라지려 할 때 호출
    override func viewWillDisappear(_ animated: Bool) {
        print("Second : viewWillDisappear")
    }
    
    // 뷰가 완전히 사라지고 난 후 호출
    override func viewDidDisappear(_ animated: Bool) {
        print("Second : viewDidDisappear")
    }

}
