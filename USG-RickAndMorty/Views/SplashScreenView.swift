//
//  SplashScreenView.swift
//  USG-RickAndMorty
//
//  Created by Fatih Acıroğlu on 24.04.2023.
//

import SwiftUI

struct SplashScreenView: View {
    private let gifName = "splash.gif"
    @State private var currentFrameIndex = 0
    @AppStorage("welcomeMessage") var welcomeMessage: String = ""
    @State var backgroundColor = Color("SplashFirstPhaseColor")
    @State private var isActive = false
    var body: some View {
        if isActive {
            HomeScreenView()

        } else {
            VStack {
                ZStack {
                    GifPlayer(gifName: "splash")
                        .frame(width: 400, height: 250)
                        .onAppear {
                            Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { _ in
                                withAnimation {
                                    if backgroundColor != Color("SplashSecondPhaseColor") {
                                        if currentFrameIndex >= 18 {
                                            backgroundColor = Color("SplashSecondPhaseColor")
                                        } else {
                                            currentFrameIndex = (currentFrameIndex + 1) % 30
                                        }
                                    }
                                }
                            }
                        }
                }
                Text(welcomeMessage)
                    .font(.custom("AmaticSC-Regular", size: 96))
                    .foregroundColor(Color(#colorLiteral(red: 0.26, green: 0.71, blue: 0.79, alpha: 1)))
            }
            .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
            .background(backgroundColor)
            .onAppear {
                changeMessage()
                DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                    withAnimation {
                        isActive = true
                    }
                }
            }
        }
    }

    func changeMessage() {
        if welcomeMessage.isEmpty {
            welcomeMessage = "Welcome!"
            UserDefaults.standard.set(welcomeMessage, forKey: "welcomeMessage")
        } else {
            welcomeMessage = "Hello!"
        }
    }
}

struct SplashScreenView_Previews: PreviewProvider {
    static var previews: some View {
        SplashScreenView()
    }
}
