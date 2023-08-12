//
//  AddListenerFlowView3.swift
//  a1-s3713342
//
//  Created by 민철 on 2023/08/12.
//
import SwiftUI

struct AddListenerFlowView3: View {
    @Binding var navigateToAddListenerFlow: Bool
    
    var body: some View {
        ZStack {
            Color.black.edgesIgnoringSafeArea(.all) // set black background
            
            VStack {
                Text("Success").foregroundColor(.white)
                    .font(.largeTitle)
            }
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                // after 3 seconds go back to ContentView
                navigateToAddListenerFlow = false
            }
        }
    }
}





struct AddListenerFlowView3_Previews: PreviewProvider {
    static var previews: some View {
        AddListenerFlowView3(navigateToAddListenerFlow: .constant(true))
    }
}
