import Foundation

//One Time Pad Keys
typealias OTPKey = [UInt8]
typealias OTPKeyPair = (key1: OTPKey, key2: OTPKey)

func randomOTPKey(length: Int) -> OTPKey {
    var randomKey: OTPKey = OTPKey()
    for _ in 0..<length {
        let randomKeyPoint = UInt8(arc4random_uniform(UInt32(UInt8.max)))
        randomKey.append(randomKeyPoint)
    }
    return randomKey
}

func encryptOTP(original: String) -> OTPKeyPair {
    let dummy = randomOTPKey(length: original.utf8.count)
    let encrypted: OTPKey = dummy.enumerated().map{ i, e in
        return e ^ original.utf8[original.utf8.index(original.utf8.startIndex, offsetBy: i)]
    }
    return (dummy,encrypted)
}

func decryptOTP(keyPair: OTPKeyPair) -> String? {
    let decrypted : OTPKey = keyPair.key1.enumerated().map { i, e in
        e ^ keyPair.key2[i]
    }
    return String(bytes: decrypted, encoding: String.Encoding.utf8)
}

encryptOTP(original: "¡Vamos Swift!")
decryptOTP(keyPair: encryptOTP(original: "¡Vamos Swift!"))
