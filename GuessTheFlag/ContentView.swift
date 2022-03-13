//
//  ContentView.swift
//  GuessTheFlag
//
//  Created by Vishal on 28/02/22.
//

import SwiftUI

struct FlagImage: View {
    let country: String

    var body: some View {
        Image(country)
            .renderingMode(.original)
            .clipShape(Capsule())
            .shadow(radius: 5)
    }
}

struct ContentView: View {
    @State private var showingScore = false
    @State private var showingGameOverAlert = false
    @State private var scoreTitle = ""
    @State private var scoreMessage = ""
    @State private var score = 0
    @State private var questionCount = 0

    @State private var countries = ["Estonia", "France", "Germany", "Ireland", "Italy", "Nigeria", "Poland", "Russia", "Spain", "UK", "US"].shuffled()
    @State private var correctAnswer = Int.random(in: 0...2)

    @State private var rotationAnimationAmount = 0.0
    @State private var selectedFlag = -1
    @State private var buttonOpacity = 1.0

    private let maxQuestions = 8

    var body: some View {
        ZStack {
            RadialGradient(stops: [
                .init(color: Color(red: 0.1, green: 0.2, blue: 0.45), location : 0.3),
                .init(color: Color(red: 0.76, green: 0.15, blue: 0.26), location: 0.3)
            ], center: .top, startRadius: 200, endRadius: 700)
                .ignoresSafeArea()

            VStack {
                Spacer()

                Text("Guess the Flag")
                    .font(.largeTitle.bold())
                    .foregroundColor(.white)

                VStack(spacing: 15) {
                    VStack {
                        Text("Tap the flag of")
                            .foregroundStyle(.secondary)
                            .font(.subheadline.weight(.heavy))

                        Text(countries[correctAnswer])
                            .font(.largeTitle.weight(.semibold))
                    }

                    ForEach(0..<3) { number in
                        Button {
                            withAnimation {
                                selectedFlag = number
                                rotationAnimationAmount = 1
                                buttonOpacity = 0.25
                            }
                            flagTapped(number)
                        } label: {
                            FlagImage(country: countries[number])
                        }
                        .rotation3DEffect(.degrees(selectedFlag == number ? rotationAnimationAmount * 360 : 0), axis: (x: 0, y: 1, z: 0))
                        .opacity((selectedFlag == -1 || selectedFlag == number) ? 1 : buttonOpacity)
                    }
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 20)
                .background(.regularMaterial)
                .clipShape(RoundedRectangle(cornerRadius: 20))

                Spacer()
                Spacer()

                Text("Score \(score)")
                    .foregroundColor(.white)
                    .font(.title.bold())

                Spacer()
            }
            .padding()
        }

        .alert(scoreTitle, isPresented: $showingScore) {
            Button("Continue", action: continueGame)
        } message: {
            Text(scoreMessage)
        }

        .alert("Game over", isPresented: $showingGameOverAlert) {
            Button("Restart", action: {
                restartGame()
                askQuestion()
            })
        } message: {
            Text("Your final score is \(score)")
        }
    }

    func flagTapped(_ number: Int) {
        if number == correctAnswer {
            score += 1
            scoreTitle = "Correct"
            scoreMessage = "Your score is \(score)"
        } else {
            scoreTitle = "Wrong"
            scoreMessage = "That's the flag of \(countries[number])"
        }

        showingScore = true
    }

    func continueGame() {
        questionCount += 1
        selectedFlag = -1
        rotationAnimationAmount = 0.0
        buttonOpacity = 1.0

        if questionCount < maxQuestions {
            askQuestion()
        } else {
            showingGameOverAlert = true
        }
    }

    func askQuestion() {
        countries.shuffle()
        correctAnswer = Int.random(in: 0...2)
    }

    func restartGame() {
        questionCount = 0
        score = 0
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
