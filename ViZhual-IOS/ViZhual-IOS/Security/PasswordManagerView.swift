//
//  PasswordManager.swift
//  ViZhual-IOS
//
//  Created by Alireza Toghiani on 1/21/23.
//

import SwiftUI

// Define a struct to hold the password strength score and estimated cracking time
struct PasswordStrength {
    var score: Int
    var estimatedCrackingTime: Double
}

struct PasswordManagerView: View {
    @State private var password = ""
    @State private var generatedPassword = ""
    @State private var generatedPasswordScore = 0
    @State private var passwordScore = 0
    @State private var offset: CGFloat = -200
    
    let passwordTypes = PasswordFormat.allCases
    @State private var selectedPasswordType = PasswordFormat.alphanumericLong
    @State private var passowrdLength = 8
    @State private var passowrdLengthText: String = ""
    
    var body: some View {
        ZStack(alignment: .top) {
            
            ScrollView {
                VStack {
                    VStack {
                        Text("Password Checker")
                            .font(.title)
                            .fontWeight(.bold)
                        ZStack {
                            RoundedRectangle(cornerRadius: 10)
                                .frame(width: 150, height: 150)
                                .shadow(radius: 5)
                                .foregroundColor(SecurityManager.shared.getPasswordStrength(score: passwordScore).color)
                            HStack {
                                Text("\(passwordScore)")
                                    .font(.largeTitle)
                                    .foregroundColor(.white)
                                Text("/100")
                                    .font(.callout)
                                    .foregroundColor(.white)
                            }
                        }
                        
                        TextField("Enter Password", text: $password)
                            .frame(height: 40)
                            .padding(.horizontal, 10)
                            .overlay(
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(Color.black, lineWidth: 1)
                            )
                            .padding(.horizontal, 20)
                            .textContentType(.password)
                            .onChange(of: password, perform: { value in
                                passwordScore = SecurityManager.shared.checkPasswordStrength(password: value).score
                            })
                    }
                    .padding(5)
                    .modifier(CardModifier())
                    .padding([.leading, .trailing])
                    
                    VStack {
                        Text("Password Generator")
                            .font(.title)
                            .fontWeight(.bold)
                        if !generatedPassword.isEmpty {
                            ZStack {
                                RoundedRectangle(cornerRadius: 10)
                                    .frame(width: 150, height: 150)
                                    .shadow(radius: 5)
                                    .foregroundColor(SecurityManager.shared.getPasswordStrength(score: generatedPasswordScore).color)
                                HStack {
                                    Text("\(generatedPasswordScore)")
                                        .font(.largeTitle)
                                        .foregroundColor(.white)
                                    Text("/100")
                                        .font(.callout)
                                        .foregroundColor(.white)
                                }
                            }
                        }
                        
                        Picker("Password Type", selection: $selectedPasswordType) {
                            ForEach(passwordTypes, id: \.self) {
                                Text($0.rawValue)
                            }
                        }
                        
                        TextField("Length (Min & Default = \(selectedPasswordType.minLengthLimit)", text: $passowrdLengthText)
                            .frame(height: 40)
                            .padding(.horizontal, 10)
                            .overlay(
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(Color.black, lineWidth: 1)
                            )
                            .padding(.horizontal, 20)
                            .keyboardType(.numberPad)
                            .multilineTextAlignment(.center)
                            .onChange(of: passowrdLengthText, perform: { value in
                                if let passowrdLength = Int(passowrdLengthText) {
                                    self.passowrdLength = passowrdLength
                                    passowrdLengthText = passowrdLength.description
                                } else {
                                    self.passowrdLength = selectedPasswordType.minLengthLimit
                                    passowrdLengthText = ""
                                }
                            })
                            .onSubmit {
                                if passowrdLength < selectedPasswordType.minLengthLimit {
                                    self.passowrdLength = selectedPasswordType.minLengthLimit
                                    passowrdLengthText = ""
                                }
                            }
                        
                        Button(action: {
                            generatedPassword = SecurityManager.shared.generate(withFormat: selectedPasswordType, length: passowrdLength)
                            generatedPasswordScore = SecurityManager.shared.checkPasswordStrength(password: generatedPassword).score
                            UIPasteboard.general.string = generatedPassword
                            withAnimation(.easeInOut(duration: 0.1)) {
                                offset = 0
                            }
                        }) {
                            Text("Generate & Copy")
                                .foregroundColor(.white)
                                .padding()
                                .background(Color.green)
                                .cornerRadius(20)
                        }
                        .frame(minWidth: 0, maxWidth: .infinity, alignment: .center)
                        
                        Text(generatedPassword)
                        
                        if SecurityManager.shared.getPasswordStrength(score: generatedPasswordScore) != .strong && !generatedPassword.isEmpty {
                            Text("This is a weak password and we suggest you use other type of passwords if you can!")
                                .multilineTextAlignment(.center)
                                .foregroundColor(.red)
                                .padding(5)
                        }
                        
                    }
                    .frame(minWidth: 0, maxWidth: .infinity, alignment: .center)
                    .padding(5)
                    .modifier(CardModifier())
                    .padding([.leading, .trailing])
                    
                }
            }
            
            VStack {
                Text("Password copied to clipboard!")
                    .foregroundColor(.white)
                    .padding()
                    .background(.green)
                    .cornerRadius(16)
                    .shadow(radius: 2)
                    .offset(y: offset)
                    .animation(.easeInOut(duration: 1))
            }
            .onChange(of: offset, perform: { newValue in
                if newValue == 0 {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                        withAnimation(.easeInOut(duration: 1)) {
                            offset = -200
                        }
                    }
                }
            })
            .onTapGesture {
                withAnimation(.easeInOut(duration: 1)) {
                    offset = -200
                }
            }
        }
    }
}

struct PasswordManager_Previews: PreviewProvider {
    static var previews: some View {
        PasswordManagerView()
    }
}
