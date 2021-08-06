//
//  ViewController.swift
//  EggTimer
//
//  Created by 강성수 on 2021/07/21.
//

import UIKit
import AVFoundation
import UserNotifications

class ViewController: UIViewController {
    
    @IBOutlet weak var topLabel: UILabel!
    @IBOutlet weak var progressBar: UIProgressView!
    @IBOutlet weak var stopButton: UIButton!
    @IBOutlet weak var soft: UIButton!
    @IBOutlet weak var medium: UIButton!
    @IBOutlet weak var hard: UIButton!
    @IBOutlet weak var anotherView: UIButton!
    
    let eggTimes = ["Soft": 3, "Medium": 5, "Hard": 10]
    
    var data = ""
    
    var totalTime = 0
    var secondsPassed = 0
    
    var player: AVAudioPlayer!
    
    var timer = Timer() //타이머 인스턴스 생성
    
//    let avc = AnotherViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        print("First : viewDidLoad")
        
        stopButton.isHidden = true
        
        navigationController?.navigationBar.topItem?.title = "FirstView"
        
//        NotificationCenter.default.addObserver(self, selector: #selector(printSome), name: .print, object: nil)
        
        // 알림 권한 요청
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) {
            (result, Error) in
        }
    }
    
    @IBAction func hardnessSelected(_ sender: UIButton) {
        
        timer.invalidate() // 타이머 초기화(기존 타이머를 종료하고, 새로운 타이머 실행)
        
        stopButton.isHidden = false
        
        let hardness = sender.currentTitle!
        
        totalTime = eggTimes[hardness]! //어떤 달걀을 선택하느냐에 따라 총 삶는 시간이 다르기에 버튼을 눌렀을 때 적절히 받아올 수 있도록 해야 함. 단, Attributes Inspector 에 미리 각 달걀에 대한 Title을 "Soft", "Medium", "Hard"로 정의를 한 상태여야 함

        progressBar.progress = 0.0 //아래 progress bar 를 0.0 으로 설정 (Float 타입이라 소수로 적어줘야 함)
        
        secondsPassed = 0 //몇 초가 지났는지 추적하기 위한 변수. Progress bar 를 위해 필요
        
        topLabel.text = hardness + " ("+String(totalTime) + " Seconds)" //어떤 달걀을 눌렀는지에 따라 상단에 Soft, Medium, Hard 가 뜨게함
        
        changedMode(sender)
        
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateCounter), userInfo: nil, repeats: true)
        //아까 선언한 timer 변수를 이용해서 실제 타이머의 세부 내용 정의. 1초 단위로 설정하였음. 1초가 지날 때 마다 updateCounter 함수가 실행될 수 있도록 함. (updateCounter는 사용자 정의 함수)
        
        // 로컬 알람 내용 구성
        let content = UNMutableNotificationContent()
        content.title = "제목"
        content.body = "내용"
        content.badge = 1
        
        // 알람 울릴 시간 설정
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 2, repeats: false)
        
        // 알람 연결
        let request = UNNotificationRequest(identifier: "test", content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
        
    }
    
    // If it changed mode
    func changedMode(_ sender: UIButton? = nil){
        
        soft.backgroundColor = .none
        medium.backgroundColor = .none
        hard.backgroundColor = .none
        
        if let button = sender {
            button.backgroundColor = .systemYellow
        }
        
    }
    
    @objc func updateCounter() {
        if secondsPassed < totalTime {
            secondsPassed += 1
            let progressPercentage = Float(secondsPassed) / Float(totalTime)
            
            progressBar.progress = progressPercentage
            
            topLabel.text = String(totalTime - secondsPassed) + " Seconds"
            
            data = String(totalTime - secondsPassed) + " Seconds"
            
            print(String(totalTime - secondsPassed) + " Seconds")
            
            // 네비 property 방식 => 변화값 계속 전달해서 에러 생김
//            avc.result?.text = data
//            navigationController?.pushViewController(avc, animated: false)
        }
        else {
            done()
        }
    }

    func done() {
        timer.invalidate() //타이머 작동 중지
        topLabel.text = "DONE" //상단 레이블을 DONE으로 표시하게끔 함
        progressBar.progress = 1.0 //진행 바를 100%로 맞춘다

        guard let url = Bundle.main.url(forResource: "alarm_sound", withExtension: "mp3")  else { return }
        //alarm_sound.mp3 라는 음원 파일이 실행될 수 있도록 미리 url 지정
        
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
            try AVAudioSession.sharedInstance().setActive(true)
            
            player = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileType.wav.rawValue)
            //AVAudioPlayer 객체 생성
            
            guard let player = player else {return}
            
            player.volume = 0.5
            player.play() //AVAudioPlayer 재생 시작
        } catch {
            print(error.localizedDescription)
        }
    }
    
    @IBAction func stopButton(_ sender: UIButton) {
        timer.invalidate()
        stopButton.isHidden = true
        progressBar.progress = 0.0
        secondsPassed = 0
        topLabel.text = "How do you like your eggs?"
        
        changedMode()
    }
    
    @IBAction func changeView(_ sender: UIButton) {
        
        let anotherViewController = self.storyboard?.instantiateViewController(withIdentifier: "AnotherViewController") as! AnotherViewController
        
        // 버튼식 (프로퍼티)
        self.present(anotherViewController, animated: true, completion: nil)
        anotherViewController.result.text = data
        
        // 옵셔널 바인딩
//        if let avc = self.storyboard?.instantiateViewController(withIdentifier: "AnotherViewController") {
//            // push controller = navi
//            self.navigationController?.pushViewController(avc, animated: true)
//        }
        
        // 네이게이션바
//        self.navigationController?.pushViewController(anotherViewController, animated: true)
        
        // segue 연결
//        performSegue(withIdentifier: "changeSegue", sender: sender)
        
    }
    
    
    // segue 방식
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if segue.identifier == "changeSegue" {
////        if segue.destination is AnotherViewController {
//            let avc = segue.destination as! AnotherViewController
////            let avc = AnotherViewController()
//            avc.result.text = data
//        }
//    }
    
    // 뷰가 나타나려 할 때마다 호출 (가변성을 가진 작업)
    override func viewWillAppear(_ animated: Bool) {
        print("First : viewWillAppear")
    }
    
    // 뷰가 완전히 나타나고 난 후 호출
    override func viewDidAppear(_ animated: Bool) {
        print("First : viewDidAppear")
//        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
//            NotificationCenter.default.post(name: .print, object: nil)
//        }
    }
    
//    @objc func printSome() {
//        print("백그라운드!!")
//        NotificationCenter.default.removeObserver(self, name: .print, object: nil)
//    }

    // 뷰가 사라지려 할 때 호출
    override func viewWillDisappear(_ animated: Bool) {
        print("First : viewWillDisappear")
    }
    
    // 뷰가 완전히 사라지고 난 후 호출
    override func viewDidDisappear(_ animated: Bool) {
        print("First : viewDidDisappear")
    }

}

//extension Notification.Name {
//    static let print = NSNotification.Name("print")
//}
