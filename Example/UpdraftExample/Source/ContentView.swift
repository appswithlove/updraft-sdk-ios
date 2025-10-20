//
//  ContentView.swift
//  UpdraftExample
//
//  Created by Raphael Neuenschwander on 02.10.20.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack {
            Text("Hello, world!")
                .padding()
            
            VStack(alignment: .leading) {
                Text("To see the Updraft Feedback screen:")
                Text("- take a screenshot")
                
                // For Simulator
                Button(action: {
                    NotificationCenter.default.post(
                        name: UIApplication.userDidTakeScreenshotNotification,
                        object: nil
                    )
                }, label: {
                    Text("- or tap this button")
                })
            }
            .padding()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
