//
//  PasswordManager.swift
//  ViZhual-IOS
//
//  Created by Alireza Toghiani on 1/21/23.
//

import SwiftUI
import CommonCrypto

// Define a struct to hold the password strength score and estimated cracking time
struct PasswordStrength {
    var score: Int
    var estimatedCrackingTime: Double
}

struct PasswordManagerView: View {
    @State private var password = ""
    @State private var score = 0

    var body: some View {
        VStack {
            ZStack {
                RoundedRectangle(cornerRadius: 10)
                    .frame(width: 150, height: 150)
                    .shadow(radius: 5)
                    .foregroundColor(getColor())
                Text("\(score)")
                    .font(.largeTitle)
                    .foregroundColor(.white)
            }

            TextField("Enter Password", text: $password)
                .frame(height: 40)
                .padding([.trailing, .leading], 10)
                .background(RoundedRectangle(cornerRadius: 8).fill(Color.white))
                .border(Color.black, width: 2)
                .padding(.horizontal, 20)
                .textContentType(.password)
                .onChange(of: password, perform: { value in
                    score = checkPasswordStrength(password: value).score
                })
        }
    }

    func getColor() -> Color {
        switch score {
        case 0...40:
            return .red
        case 41...70:
            return .orange
        case 71...100:
            return .green
        default:
            return .black
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

        // Read the list of common passwords from a text file
        let fileURL = Bundle.main.url(forResource: "common-passwords", withExtension: "txt")
        let commonPasswords = try? String(contentsOf: fileURL!).components(separatedBy: "\n")

        // Check for common words or patterns
        if (commonPasswords ?? []).contains(password) {
            score -= 20
        }
        
        score = max(0, score)

        return PasswordStrength(score: score, estimatedCrackingTime: estimatedCrackingTime)
    }
}

struct PasswordManager_Previews: PreviewProvider {
    static var previews: some View {
        PasswordManagerView()
    }
}
