import UIKit

func calculatePi(nTerms: UInt) -> Double {
    let numerator: Double = 4
    var denominator: Double = 1
    var operation: Double = -1
    var pi: Double = 0
    for _ in 0..<nTerms {
        pi += operation * (numerator / denominator)
        denominator += 2
        operation *= -1
    }
    return abs(pi)
}

calculatePi(nTerms: 1000)
