//
//  Round.swift
//  oh-my-grill
//
//  Created by Barbara da Silva Dapper on 26/11/25.
//

import Foundation

@Observable
public class Round {
    public var number: Int
    public var minPoints: Int
    
    public var points: Int {
        didSet {
            print("Points: \(points)")
        }
    }
    
    public var time: TimeInterval
    public var status: RoundStatus
    public var feedback: Feedback
    
    private var timer: Timer?
    
    public var onFinished: ((Round) -> Void)?
    
    public init(number: Int, minPoints: Int)
    {
        self.number = number
        self.minPoints = minPoints
        self.points = 0
        self.time = 180
        self.status = .inProgress
        self.feedback = .none
        
        startCountdown()
    }
    
    // MARK: Countdown
    
    public func startCountdown() {
        timer?.invalidate()
        
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] _ in
            guard let self else { return }
            
            if self.time > 0 {
                self.time -= 1
            } else {
                self.finishRound()
            }
        }
    }

    public func finishRound() {
        timer?.invalidate()
        time = 0
        status = .finished
        getFeedback()
        onFinished?(self)
    }

    
    public func invalidateTimer() {
        timer?.invalidate()
    }
    
    // MARK: Points
    
    public func updatePoints(by amount: Int = 50) {
        guard status == .inProgress else { return }
        self.points += amount
    }
    
    // MARK: Feedback
    
    public func getFeedback() {
        if points >= minPoints {
            feedback = .success
        } else {
            feedback = .fail
        }
    }
}


public enum RoundStatus: String, Codable {
    case inProgress
    case finished
}

public enum Feedback: String, Codable {
    case none
    case fail
    case success
}


extension Feedback {
    var displayName: String {
        switch self {
        case .none: ""
        case .fail: "Falharam"
        case .success: "Ganharam"
        }
    }
}
