//
//  AddListenerFlow0.swift
//  a1-s3713342
//
//  Created by 민철 on 2023/08/05.
//
import SwiftUI

struct AddListenerFlow0: View {
    @Binding var showAddListenerFlow: Bool
    @State private var selectedOption: Int? = nil
    @State private var moveToNextView = false
    
    init(showAddListenerFlow: Binding<Bool>) {
        self._showAddListenerFlow = showAddListenerFlow
    }
}

struct AddListenerFlow0_Previews: PreviewProvider {
    static var previews: some View {
        AddListenerFlow0()
    }
}
