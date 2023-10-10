//
//  AddListenerFlowView3.swift
//  a1-s3713342
//
//  Created by Min on 2023/08/12.
//

import SwiftUI

// MARK: - Final Step of AddListenerFlow
struct Success: View {
    
    @State private var goToNextScreen = false
    
    var body: some View {
        
        VStack {
            // Display a success message
            Text("Success!")
                .font(.title2)
            
            // FIXME: Look into the "pop-to-root" SwiftUI pattern
            NavigationLink("", isActive: $goToNextScreen) {
                ContentView()
                    .navigationBarBackButtonHidden(true)
            }
            
        }
        .onAppear {
            //                 Execute the following code after a delay of 2 seconds
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                // Update the binding variables and navigate back
                goToNextScreen = true
            }
        }
        .preferredColorScheme(.dark)
    }
}

// MARK: - Previews
struct Success_Previews: PreviewProvider {
    
    static var previews: some View {
        
        /// Wrapped view to enable navigation
        NavigationView {
            Success()
        }
        .previewDisplayName("Wrapped in NavView")
        
        /// Unwrapped view for meaningful view debugging with: `Editor > Canvas > Show Selection`
        Success()
            .previewDisplayName("Unwrapped")
        
    }
}
