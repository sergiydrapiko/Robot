//
//  FooBar.swift
//  Playground
//
//  Created by Sergiy Drapiko on 31.01.20.
//  Copyright © 2020 Robot. All rights reserved.
//

import Foundation

class Robot {
    enum State: Equatable {
        case wait // default state, do nothing
        case hibernate // if the temperature gets too low, hibernate
        case followTarget // if a target is detected, follow it
        case runAway // if danger is detected, run away
    }

    private let dangerDetector: DangerDetector
    private let targetDetector: TargetDetector

    var state: State {
        let minOperatingTemp = -20.75
        if globalTemperature < minOperatingTemp || globalTemperatureAccordingToABackupSensor() < minOperatingTemp {
            return .hibernate
        } else if dangerDetector.checkForDanger() {
            return .runAway
        } else if targetDetector.isTargetDetected {
            return .followTarget
        } else {
            return .wait
        }
    }

    init(dangerDetector: DangerDetector = DangerDetector(), targetDetector: TargetDetector = StandardTargetDetector()) {
        self.dangerDetector = dangerDetector
        self.targetDetector = targetDetector
    }
}

fileprivate(set) var globalTemperature: Double = 21.5 { didSet {} }

func globalTemperatureAccordingToABackupSensor() -> Double { 22.5 }

class DangerDetector {
    func checkForDanger() -> Bool { false }
}

protocol TargetDetector {
    var isTargetDetected: Bool { get }
}

class StandardTargetDetector: TargetDetector {
    var isTargetDetected: Bool = false {
        didSet {}
    }
}
