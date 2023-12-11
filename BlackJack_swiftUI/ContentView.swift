//
//  ContentView.swift
//  BlackJack_swiftUI
//
//  Created by Haruko Okada on 10/29/23.
//

import SwiftUI
import Network

enum card_values: String {
    case two = "two"
    case three = "three"
    case four = "four"
    case five = "five"
    case six = "six"
    case seven = "seven"
    case eight = "eight"
    case nine = "nine"
    case ten = "ten"
    case jack = "Jack"
    case queen = "Queen"
    case king = "King"
    case ace = "Ace"
}

enum card_suits: String {
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
    @State private var selectedNumber = 1
    
    
//    let card_value_buttons: [[card_values]] = [
//        [.two, .three, .four],
//        [.five, .six, .seven],
//        [.eight, .nine, .ten],
//        [.jack, .queen, .king],
//        [.ace]
//    ]
    let card_value_buttons: [[card_values]] = [
        [.two, .three, .four, .five],
        [.six, .seven, .eight, .nine],
        [.ten, .jack, .queen, .king],
        [.ace]
    ]
    
    let card_suits_buttons: [card_suits] = [.spade, .clover, .heart, .diamond]
    let numbers = Array(1...5)
    
    var body: some View {
        
        NavigationView {
            
            VStack {
                VStack {
                    Button(action: {
                        let res = self.network.open(ip: self.IPadr, port: UInt16(self.portNoS)!)
                        if res == "Ready" {
                            print("connection success")
                        } else {
                            print("failed to connect")
                        }
                    }) {
                        Text("Connect to Network")
                    }
                }.padding(.bottom, 10)
                
                // Table number
                VStack {
                    Picker("Select a number", selection: $selectedNumber) {
                        ForEach(numbers, id: \.self) { number in
                            Text("\(number)")
                                .tag(number)
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    
                    Button(action: {
                        // send value to network
                        let message = "START"
                        // let data = message.data(using: .utf8)!
                        let sentF = self.network.send(sText: message)
                        if sentF.statS == "success" {
                            print("sent successfully: \(message)")
                        } else {
                            print("failed to send")
                        }
                    }, label: {
                        Text("Start Round")
                    })
               
                
                    .padding()
                    
                    // Suits
                    HStack {
                        ForEach(card_suits_buttons, id: \.self) { suit in
                            Button(action: {
                                // Perform an action when the button is tapped
                                self.buttonTapped(suit)
                            }) {
                                // Display the button label based on the suit
                                Text(self.label(for: suit))
                                    .font(.system(size: 20))
                                    .frame(
                                        width: 25,
                                        height: 25)
                                    .padding()
                                    .foregroundColor(.white)
                                    .background(Color.black)
                                    .cornerRadius(8)
                            }
                        }
                    }.padding(.bottom, 10)
                    
                    // Values
                    ForEach(card_value_buttons, id: \.self) { row in
                        HStack(spacing: 20) {
                            ForEach(row, id: \.self) { item in
                                Button(action: {
                                    // send value to network
                                    let message = item.rawValue
                                    // let data = message.data(using: .utf8)!
                                    let sentF = self.network.send(sText: message)
                                    if sentF.statS == "success" {
                                        print("sent successfully: \(message)")
                                    } else {
                                        print("failed to send")
                                    }
                                }, label: {
                                    Text(item.rawValue)
                                        .font(.system(size: 20))
                                        .frame(
                                            width: self.buttonWidth(),
                                            height: self.buttonHeight())
                                        .background(Color.green)
                                        .foregroundColor(.white)
                                        .cornerRadius(10)
                                })
                            }
                        }.padding(.bottom, 10)
                    }
                }
                
                // Submit button
                Button(action: {
                    let data = message.data(using: .utf8)!
                    let sentF = self.network.send(sText: message)
                    if sentF.statS == "success" {
                        print("sent successfully: \(message)")
                    } else {
                        print("failed to send")
                    }
                }, label: {
                    Text("Send Message")
                        .frame(width: UIScreen.main.bounds.width - 100, height:50)
                        .background(Color.green)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                })
                
                Spacer()
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
        .background(BlackjackColors.blackjackGreen)
        .edgesIgnoringSafeArea(.all)

    
    }
    
    func buttonWidth() -> CGFloat {
        return (UIScreen.main.bounds.width - (5*20)) / 4
    }
    
    func buttonHeight() -> CGFloat {
        return (UIScreen.main.bounds.width - (5*20)) / 4
    }
    
    
    func label(for suit: card_suits) -> String {
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
    
    
    func buttonTapped(_ suit: card_suits) {
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
    
