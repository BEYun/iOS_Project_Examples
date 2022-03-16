//
//  ViewController.swift
//  pomodoro
//
//  Created by 윤병은 on 2022/03/16.
//

import UIKit
import AudioToolbox

// 타이머의 상태를 지니는 열거형
enum TimerStatus {
    case start
    case pause
    case end
}

class ViewController: UIViewController {
    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var progressView: UIProgressView!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var toggleButton: UIButton!
    
    var duration = 60
    var timerStatus: TimerStatus = .end
    var timer: DispatchSourceTimer?
    var currentSeconds = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureToggleButton()
    }

    @IBAction func tapCancelButton(_ sender: UIButton) {
        switch self.timerStatus {
        case .start, .pause:
            self.stopTimer()
        default:
            break
        }
    }
    
    // 타이머의 상태에 따라 timerLabel과 progressView의 isHidden 속성을 변경해주는 메소드 구현
    func setTimerInfoViewVisible(isHidden: Bool) {
        self.timerLabel.isHidden = isHidden
        self.progressView.isHidden = isHidden
    }
    
    // 버튼의 초기상태(.normal)이면 타이틀이 "시작"으로, .selected 상태이면 타이틀이 "일시정지"로 변환되게 하는 메소드
    func configureToggleButton() {
        self.toggleButton.setTitle("시작", for: .normal)
        self.toggleButton.setTitle("일시정지", for: .selected)
    }
    
    func startTimer() {
        if self.timer == nil {
            // queue는 어느 스레드에서 작업을 수행할 것인지에 대한 여부로, UI 상에서 timerLabel과 progressView에 업데이트를 해줘야 하므로 .main 스레드에 할당
            self.timer = DispatchSource.makeTimerSource(flags: [], queue: .main)
            // deadline 파라미터는 시작점을, repeating 파라미터는 X초 마다 반복할 것인지를 나타냄
            self.timer?.schedule(deadline: .now(), repeating: 1)
            // 타이머가 동작할 때 마다 handler 파라미터의 클로저가 실행됨
            self.timer?.setEventHandler(handler: { [weak self] in
                guard let self = self else { return }
                self.currentSeconds -= 1
                let hour = self.currentSeconds / 3600
                let minutes = (self.currentSeconds % 3600) / 60
                let seconds = (self.currentSeconds % 3600) % 60
                // String() 메소드를 이용화여 format 파라미터는 자리수와 구분 값인 콜론을 설정, arguments 파라미터는 가변변수들(hour, minutes, seconds)를 설정
                self.timerLabel.text = String(format: "%02d:%02d:%02d", hour, minutes, seconds)
                // 총 시간인 duration 프로퍼티를 현재 시간인 currentSeconds 프로퍼티로 나누어 progressView에 0 ~ 1 사이의 값으로 할당
                self.progressView.progress = Float(self.currentSeconds) / Float(self.duration)
                // imageView를 .pi 값(180도), .pi * 2(360도) 회전 애니메이션 구현
                UIView.animate(withDuration: 0.5, delay: 0, animations: {
                    self.imageView.transform = CGAffineTransform(rotationAngle: .pi)
                })
                UIView.animate(withDuration: 0.5, delay: 0.5, animations: {
                    self.imageView.transform = CGAffineTransform(rotationAngle: .pi * 2)
                })
                
                if self.currentSeconds <= 0 {
                    // currentSeconds가 0보다 같거나 작다면 타이머 종료
                    self.stopTimer()
                    // inSystemSoundID는 iphonedev.wiki 사이트에서 확인 가능, 1005번은 alarm 사운드
                    AudioServicesPlaySystemSound(1005)
                }
            })
            self.timer?.resume()
        }
    }
    
    func stopTimer() {
        // timer가 suspend() 메소드를 실행했을 시에 nil을 할당하면 런타임 오류 발생, resume() 메소드를 할당하여 오류 방지
        if self.timerStatus == .pause {
            self.timer?.resume()
        }
        self.timerStatus = .end
        self.cancelButton.isEnabled = false
        UIView.animate(withDuration: 0.5, animations: {
            self.timerLabel.alpha = 0
            self.progressView.alpha = 0
            self.datePicker.alpha = 1
            // imageView 원상태 복구
            self.imageView.transform = .identity
        })
        self.toggleButton.isSelected = false
        self.timer?.cancel()
        self.timer = nil
    }
    
    @IBAction func tapToggleButton(_ sender: UIButton) {
        // countDownDuration 프로퍼티를 이용하여 datePicker의 시간을 초 단위로 가져올 수 있음
        self.duration = Int(self.datePicker.countDownDuration)
        switch self.timerStatus {
        // .end 상태를 지니고 있을 시, 상태를 .start로 설정, timerLabel과 progressView를 표시하고, datePicker는 hidden,
        // toggleButton은 .selected 상태로, cancel은 isEnabled 상태로 전환
        case .end:
            self.currentSeconds = self.duration
            self.timerStatus = .start
            // withDuration 파라미터의 시간만큼 animations 파라미터의 클로저의 내용이 초깃값 -> 결과값으로 진행됨
            UIView.animate(withDuration: 0.5, animations: {
                self.timerLabel.alpha = 1
                self.progressView.alpha = 1
                self.datePicker.alpha = 0
            })
            self.toggleButton.isSelected = true
            self.cancelButton.isEnabled = true
            self.startTimer()
        case .start:
            self.timerStatus = .pause
            self.toggleButton.isSelected = false
            // 타이머 일시정지
            self.timer?.suspend()
        case .pause:
            self.timerStatus = .start
            self.toggleButton.isSelected = true
            // 타이머 재시작
            self.timer?.resume()
        }
    }
}

