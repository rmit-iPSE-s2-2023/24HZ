//
//  AddListenerFlowCustom2.swift
//  a1-s3713342
//
//  Created by 민철 on 2023/08/20.
//

import SwiftUI

struct AddListenerFlowCustom2: View {
    var body: some View {
        ZStack {
            Color.black.edgesIgnoringSafeArea(.all)
            VStack {
                Text("Fetching event types..")
                    .foregroundColor(.white)
                Text("(end of screen, need further development)")
                // need info
                    .foregroundColor(.white)
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle(tint: .white)) //loading icon
            }
        }
    }
}

struct AddListenerFlowCustom2_Previews: PreviewProvider {
    static var previews: some View {
        AddListenerFlowCustom2()
    }
}

