//
//  TextInputView.swift
//  BlackJack_swiftUI
//
//  Created by Haruko Okada on 12/10/23.
//

import SwiftUI
import Network

struct TextInputView: View {
    @EnvironmentObject var network: Network
    @EnvironmentObject var netV: netVar
    @State var IPadr: String = "10.0.1.10"
    @State var portNoS: String = "5000"
    @State var message: String = ""
    var body: some View {
        
        VStack(spacing: 50) {
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
            
            TextField(
                "Message",
                text: $message
            )
            .disableAutocorrection(true)
            .frame(width: UIScreen.main.bounds.width - 50)
            .textFieldStyle(.roundedBorder)
            
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
            
        }.padding(.bottom, 40)
    }
}

#Preview {
    TextInputView()
}
