import Foundation

func fibo(n: UInt) -> UInt {
    if n < 2 {
        return n
    }
    return fibo(n: n-2) + fibo(n: n-1)
}
fibo(n: 20)

//Memoization: technique in which you store the results of computational tasks when they are completed
//so that when you need them again you can look them up instead of needing to compute them a second
//This term was coined by Donald Michie

var fibMemo: [UInt:UInt] = [0:0, 1:1] //base cases
func fibo2(n: UInt) -> UInt {
    if let result = fibMemo[n] {
        return result
    }else {
        fibMemo[n] = fibo2(n: n-1) + fibo2(n: n-2)
    }
    return fibMemo[n]!
}
fibo2(n: 20)

func fibo3(n: UInt64) -> UInt64 {
    if n == 0 {return n}
    var last: UInt64 = 0, next: UInt64 = 1
    for _ in 1..<n {
        (last,next) = (next,last+next)
    }
    return next
}
fibo3(n: 50)
