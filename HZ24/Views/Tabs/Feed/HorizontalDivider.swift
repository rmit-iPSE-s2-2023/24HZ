//
// HorizontalDivider.swift
// HZ24
// 
// Created by jin on 2023-10-07
// 



import SwiftUI

struct HorizontalDivider: View {
    var body: some View {
        VStack {
            Divider()
                .background(.gray)
        }
    }
}

struct HorizontalDivider_Previews: PreviewProvider {
    static var previews: some View {
        HorizontalDivider()
    }
}
