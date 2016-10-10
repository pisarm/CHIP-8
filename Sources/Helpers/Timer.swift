//
//  Timer.swift
//  CHIP-8
//
//  Created by Flemming Pedersen on 27/06/16.
//  Copyright © 2016 pisarm.dk. All rights reserved.
//

import Foundation

final class Timer {
    ///MARK: Typealiases
    public typealias DispatchHandler = () -> Void

    ///MARK: Properties
    public var interval: DispatchTimeInterval {
        didSet {
            self.cancel()
            (self.timer) = Timer.commonInit(queue: self.queue, interval: self.interval, handler: self.handler)
            self.resume()
        }
    }

    private var isRunning = false
    private let handler: DispatchHandler
    private var timer: DispatchSourceTimer
    private let queue: DispatchQueue

    ///MARK: Initialization
    /**
     Creates a timer which tick at a given interval.

     Queue parameter will default to a global background queue with default QOS.

     Handler should capture self weakly in order to avoid retain cycles.

     Example:
     ```
     let timer = Timer(interval: .milliseconds(2)) {
     print("tick/tock")
     }
     timer.resume()
     ```

     - parameter queue: Dispatch queue the handler should execute on
     - parameter interval: Interval at which the timer should tick
     - parameter handler: Closure evaluated every tick of the timer
     */
    init(queue: DispatchQueue = DispatchQueue.global(qos: .default), interval: DispatchTimeInterval, handler: @escaping DispatchHandler) {
        self.queue = queue
        self.interval = interval
        self.handler = handler

        (self.timer) = Timer.commonInit(queue: queue, interval: interval, handler: handler)
    }

    private static func commonInit(queue: DispatchQueue, interval: DispatchTimeInterval, handler: @escaping DispatchHandler) -> (DispatchSourceTimer) {
        let timer = DispatchSource.makeTimerSource(queue: queue)
        timer.scheduleRepeating(deadline: .now(), interval: interval)
        timer.setEventHandler(qos: DispatchQoS.default, flags: [.enforceQoS]) {
            handler()
        }

        return (timer)
    }

    ///MARK: Interaction
    func resume() {
        guard !isRunning else {
            return
        }

        isRunning = true
        timer.resume()
    }

    func cancel() {
        guard isRunning else {
            return
        }

        isRunning = false
        timer.cancel()
    }

    func suspend() {
        guard isRunning else {
            return
        }

        isRunning = false
        timer.suspend()
    }
}
