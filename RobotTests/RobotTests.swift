//
//  RobotTests.swift
//  RobotTests
//
//  Created by Sergiy Drapiko on 31.01.20.
//  Copyright © 2020 Robot. All rights reserved.
//

import XCTest
import Nimble
import SwiftMocks
@testable import Robot

class RobotTests: BaseTest {
    func testInitialState() {
        let robot = Robot()
        expect(robot.state) == .wait
    }

    func testTooColdAccordingToGlobalVar() {
        stub { globalTemperature }.with(-50)

        let robot = Robot()
        expect(robot.state) == .hibernate
    }

    func testTooColdAccordingToGlobalFunc() {
        stub { globalTemperatureAccordingToABackupSensor() }.with(-50)

        let robot = Robot()
        expect(robot.state) == .hibernate
    }

    func testDangerDetected() {
        let dangerDetector: DangerDetector = mock { it in
            stub { it.checkForDanger() }.with(true)
        }

        let robot = Robot(dangerDetector: dangerDetector)
        expect(robot.state) == .runAway
    }

    func testTargetDetected() {
        let targetDetector: TargetDetector = mock { it in
            stub { it.isTargetDetected }.with(true)
        }

        let robot = Robot(targetDetector: targetDetector)
        expect(robot.state) == .followTarget
    }
}
