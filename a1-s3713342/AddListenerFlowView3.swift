//
//  AddListenerFlowView3.swift
//  a1-s3713342
//
//  Created by 민철 on 2023/08/05.
//
import SwiftUI



struct AddListenerFlowView3: View {
    
    var body: some View {
        ZStack {
            Color.black.edgesIgnoringSafeArea(.all) // set black background
            VStack {
                Text("Success").foregroundColor(.white)
                    .font(.largeTitle)
                    }
        }
    }
}

struct AddListenerFlowView3_Previews: PreviewProvider {
    static var previews: some View {
        AddListenerFlowView3()
    }
}
