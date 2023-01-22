//
//  PasswordGenerator.swift
//  ViZhual-IOS
//
//  Created by Alireza Toghiani on 1/22/23.
//

import SwiftUI
import CommonCrypto

enum PasswordFormat: String, CaseIterable {
    case alphanumeric
    case alphanumericLong
    case alphanumericSpecial
    case alphanumericSpecialLong
    case random
    
    var minLengthLimit: Int {
        switch self {
        case .alphanumeric:
            return 8
        case .alphanumericLong:
            return 12
        case .alphanumericSpecial:
            return 12
        case .alphanumericSpecialLong:
            return 16
        case .random:
            return 8
        }
    }
}

enum PasswordStrengthLevel: String {
    case weak
    case medium
    case strong
    
    var color: Color {
        switch self {
        case .weak:
            return .red
        case .medium:
            return .orange
        case .strong:
            return .green
        }
    }
}

class SecurityManager {
    
    private init() {}
    
    static var shared = SecurityManager()
    
    func generate(withFormat format: PasswordFormat, length: Int) -> String {
        switch format {
            case .alphanumeric:
                return randomString(length: length, allowedCharacters: "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789")
            case .alphanumericSpecial:
                return randomString(length: length, allowedCharacters: "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789!@#$%^&*()_-+=")
            case .alphanumericSpecialLong:
                return randomString(length: length, allowedCharacters: "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789!@#$%^&*()_-+=")
            case .alphanumericLong:
                return randomString(length: length, allowedCharacters: "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789")
            case .random:
                return randomString(length: length, allowedCharacters: "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789!@#$%^&*()_-+=[]{}|;':\",.<>/?\\")
        }
    }

    func randomString(length: Int, allowedCharacters: String) -> String {
        var password = ""
        for _ in 0..<length {
            var randomCharacter: Character?
            repeat {
                randomCharacter = allowedCharacters.randomElement()
            } while (randomCharacter == nil || !allowedCharacters.contains(randomCharacter!))
            if let randomCharacter = randomCharacter {
                password.append(randomCharacter)
            }
        }
        return password
    }
    
    func getPasswordStrength(score: Int) -> PasswordStrengthLevel {
        switch score {
        case 0...40:
            return .weak
        case 41...70:
            return .medium
        case 71...100:
            return .strong
        default:
            return .weak
        }
    }
    
    // Function to estimate cracking time
    func estimateCrackingTime(password: String) -> Double {
        // calculate the entropy of the password
        let passwordEntropy = calculateEntropy(password: password)
        // calculate the cracking time based on the entropy
        let crackingTime = pow(2, passwordEntropy)
        return crackingTime
    }

    // function to calculate the entropy of the password
    func calculateEntropy(password: String) -> Double {
        var entropy = 0.0
        let passwordSet = Set(password.unicodeScalars)
        for scalar in passwordSet {
            let characterFrequency = Double(password.filter({$0.unicodeScalars.first == scalar}).count) / Double(password.count)
            entropy += -characterFrequency * log2(characterFrequency)
        }
        return entropy
    }

    // Function to check the password strength
    func checkPasswordStrength(password: String) -> PasswordStrength {
        var score = 0
        let estimatedCrackingTime = estimateCrackingTime(password: password)

        // Check password length
        let length = password.count
        if length >= 8 {
            score += 10
        }
        if length >= 12 {
            score += 10
        }
        if length >= 16 {
            score += 10
        }

        // Check for the presence of uppercase and lowercase letters, numbers, and special characters
        let upperCase = CharacterSet.uppercaseLetters
        let lowerCase = CharacterSet.lowercaseLetters
        let numbers = CharacterSet.decimalDigits
        let specialCharacters = CharacterSet(charactersIn: "!@#$%^&*()_+-=[]{}|;':\"<>,.?/\\")

        if password.rangeOfCharacter(from: upperCase) != nil {
            score += 10
        }
        if password.rangeOfCharacter(from: lowerCase) != nil {
            score += 10
        }
        if password.rangeOfCharacter(from: numbers) != nil {
            score += 10
        }
        if password.rangeOfCharacter(from: specialCharacters) != nil {
            score += 10
        }
        
        let entropy = calculateEntropy(password: password)
        score += Int((entropy * 45 / log2(128)).rounded())

        // Read the list of common passwords from a text file
        let fileURL = Bundle.main.url(forResource: "common-passwords", withExtension: "txt")
        let commonPasswords = try? String(contentsOf: fileURL!).components(separatedBy: "\n")

        // Check for common words or patterns
        if (commonPasswords ?? []).contains(password) {
            score -= 20
        }
        
        if score < 0 {
            score = 0
        }
        if score > 100 {
            score = 100
        }

        return PasswordStrength(score: score, estimatedCrackingTime: estimatedCrackingTime)
    }
}
