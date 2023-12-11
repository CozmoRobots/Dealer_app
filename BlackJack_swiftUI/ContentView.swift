//
//  ContentView.swift
//  BlackJack_swiftUI
//
//  Created by Haruko Okada on 10/29/23.
//

import SwiftUI
import Network

enum card_values: String {
    case two = "Two"
    case three = "Three"
    case four = "Four"
    case five = "Five"
    case six = "Six"
    case seven = "Seven"
    case eight = "Eight"
    case nine = "Nine"
    case ten = "Ten"
    case jack = "Jack"
    case queen = "Queen"
    case king = "King"
    case ace = "Ace"
}

enum CardSuits: String, CaseIterable {
    case spade = "Spade"
    case clover = "Club"
    case heart = "Heart"
    case diamond = "Diamond"
}

struct ContentView: View {
    @EnvironmentObject var network: Network
    @EnvironmentObject var netV: netVar
    @State var IPadr: String = "10.0.1.10"
    @State var portNoS: String = "5000"
    @State var message: String = ""
    @State private var cardSuit = ""
    @State private var cardValue = ""
    @State private var selectedSuit: CardSuits = .spade
    @State private var selectedTableNumber = 1
    @State private var selectedDeckNumber = 1
    @State private var handValue = 0
    @State private var count = 0
    
    let card_value_buttons: [[card_values]] = [
        [.two, .three, .four, .five, .six],
        [.seven, .eight, .nine, .ten, .jack],
        [.queen, .king, .ace]
    ]
    
    let cardLabelsArray: [String] = ["2", "3", "4", "5", "6", "7", "8", "9", "10", "Jack", "Queen", "King", "Ace"]

    
    let card_suits_buttons: [CardSuits] = [.spade, .clover, .heart, .diamond]
    let numbers = Array(1...5)
    
    var body: some View {
        
        NavigationView {
            
            VStack(spacing: 20) {
                
                // Connect to network
                Button(action: {
                    let res = self.network.open(ip: self.IPadr, port: UInt16(self.portNoS)!)
                    if res == "Ready" {
                        print("connection success")
                    } else {
                        print("failed to connect")
                    }
                }) {
                    Text("Connect to Network")
                        .frame(width: UIScreen.main.bounds.width - 200, height:30)
                        .background(Color.green)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                
                
                // Table Number
                Text("Select a table number")
                    .font(.headline)
                    .padding(.top, 10)
                Picker("Select a number", selection: $selectedTableNumber) {
                    ForEach(numbers, id: \.self) { number in
                        Text("\(number)")
                            .tag(number)
                    }
                }
                .frame(width: UIScreen.main.bounds.width - 40)
                .pickerStyle(SegmentedPickerStyle())
                
                
                // Deck Number
                Text("Select a deck number")
                    .font(.headline)
                    .padding(.top, 10)
                Picker("Select a table number", selection: $selectedDeckNumber) {
                    ForEach(numbers, id: \.self) { number in
                        Text("\(number)")
                            .tag(number)
                    }
                }
                .frame(width: UIScreen.main.bounds.width - 40)
                .pickerStyle(SegmentedPickerStyle())
            
            
                // Start Round
                Button(action: {
                    count = 0
                    // send value to network ( "table;START;"
                    message = "\(selectedTableNumber);START;\(selectedDeckNumber)"
                    // let data = message.data(using: .utf8)!
                    let sentF = self.network.send(sText: message)
                    print("Message formulated:", message)
                    if sentF.statS == "success" {
                        print("sent successfully: \(message)")
                    } else {
                        print("failed to send")
                    }
                }, label: {
                    Text("Start Round")
                        .frame(width: UIScreen.main.bounds.width - 200, height:30)
                        .background(Color.green)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                })
           
                
                // Suits
                Text("Select a suit")
                    .font(.headline)
                    .padding(.top, 10)
                
                Picker("Suits", selection: $selectedSuit) {
                    ForEach(card_suits_buttons, id: \.self) { suit in
                        Text(self.label(for: suit))
                            .tag(suit)
                    }
                }
                .frame(width: UIScreen.main.bounds.width - 40)
                .pickerStyle(SegmentedPickerStyle())
                .padding(.bottom, 10)
                
                
                // Values
                ForEach(0..<card_value_buttons.count, id: \.self) { rowIndex in
                    HStack(spacing: 10) {
                        ForEach(0..<card_value_buttons[rowIndex].count, id: \.self) { columnIndex in
                            let item = card_value_buttons[rowIndex][columnIndex]
                            let labelIndex = rowIndex * 5 + columnIndex

                            Button(action: {
                                count += 1
                                cardValue = item.rawValue
                                // "table;dealer;cardNumber;cardValue"
                                cardValue = item.rawValue
                                message = "\(selectedTableNumber);dealer;\(count);\(cardValue)"
                                print("message: \(message)")
                                // let data = message.data(using: .utf8)!
                                let sentF = self.network.send(sText: message)
                                if sentF.statS == "success" {
                                    print("sent successfully: \(message)")
                                } else {
                                    print("failed to send")
                                }
                            }, label: {
                                Text(cardLabelsArray[labelIndex])
                                    .font(.system(size: 20))
                                    .frame(
                                        width: self.buttonWidth(),
                                        height: self.buttonHeight())
                                    .background(Color.green)
                                    .foregroundColor(.white)
                                    .cornerRadius(10)
                            })
                        }
                    }
                }
                
                
                // Stay button
                Button(action: {
                    // "table;dealer;-1;-1"
                    message = "\(selectedTableNumber);dealer;-1;-1"
                    
                    print("message: \(message)")
//                    let data = message.data(using: .utf8)!
                    let sentF = self.network.send(sText: message)
                    if sentF.statS == "success" {
                        print("sent successfully: \(message)")
                    } else {
                        print("failed to send")
                    }
                }, label: {
                    Text("Stay")
                        .frame(width: UIScreen.main.bounds.width - 200, height:30)
                        .background(Color.green)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                })
                
                
                // Button to navigate to TextInputView
                NavigationLink(destination: TextInputView()) {
                    Text("Go to TextInputView")
                    
                }
                
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text("Dealer")
                        .font(.headline)
                        .foregroundColor(.primary)
                }
            }
            
        }
        .navigationViewStyle(StackNavigationViewStyle())

    
    }
    
    func buttonWidth() -> CGFloat {
        return (UIScreen.main.bounds.width - (5 * 20)) / 5
    }
    
    func buttonHeight() -> CGFloat {
        return (UIScreen.main.bounds.width - (5 * 20)) / 5
    }
    
    
    func label(for suit: CardSuits) -> String {
        switch suit {
        case .spade:
            return "♤"
        case .clover:
            return "♧"
        case .heart:
            return "♡"
        case .diamond:
            return "♢"
        }
    }
    
    
    func buttonTapped(_ suit: CardSuits) {
        // Handle button tap action here
        print("Button tapped for \(suit)")
    }
    
}

class netVar: ObservableObject {
    @Published var sentM = ""
//    @Published var recvM = ""
    @Published var statM = ""
}

#Preview {
    ContentView()
}
    
