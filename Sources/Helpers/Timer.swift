//
//  Timer.swift
//  CHIP-8
//
//  Created by Flemming Pedersen on 27/06/16.
//  Copyright © 2016 pisarm.dk. All rights reserved.
//

import Foundation

final class Timer {
    //MARK: Typealiases
    typealias TimerHandler = () -> Void

    //MARK: Properties
    private let rate: Int
    private let handler: TimerHandler

    private let timer: dispatch_source_t
    private let queue: dispatch_queue_t

    //MARK: Initialization
    /**
     Creates a timer which tick at a given rate.

     Queue parameter will default to a global background queue with default priority.

     Handler should capture self weakly in order to avoid retain cycles.

     - parameter rate: Rate at which the timer should tick, measured in Hz
     - parameter queue: Dispatch queue the handler should execute on
     - parameter handler: Evaluated every tick of the timer
     */
    init(rate: Int, queue: dispatch_queue_t = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), handler: TimerHandler) {
        self.rate = rate
        self.queue = queue
        self.handler = handler

        self.timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue)
        dispatch_source_set_timer(timer, DISPATCH_TIME_NOW, NSEC_PER_SEC / UInt64(rate), 0)
        dispatch_source_set_event_handler(timer) {
            self.handler()
        }
    }

    //MARK: Interaction
    func resume() {
        dispatch_resume(timer)
    }

    func cancel() {
        dispatch_source_cancel(timer)
    }

    func suspend() {
        dispatch_suspend(timer)
    }
    
}
