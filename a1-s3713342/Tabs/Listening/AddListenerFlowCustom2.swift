//
//  AddListenerFlowCustom2.swift
//  a1-s3713342
//
//  Created by Min on 2023/08/20.
//

import SwiftUI

// MARK: - Add Custom Listener Step 2
struct AddListenerFlowCustom2: View {
    var body: some View {
        ZStack {
            // Background color
            Color.black.edgesIgnoringSafeArea(.all)
            
            VStack {
                // Loading and information text
                Text("Fetching event types..")
                    .foregroundColor(.white)
                Text("(end of screen, need further development)")
                    .foregroundColor(.white)
                
                // Loading spinner
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle(tint: .white))
            }
        }
    }
}

struct AddListenerFlowCustom2_Previews: PreviewProvider {
    static var previews: some View {
        AddListenerFlowCustom2()
    }
}

