//
//  ListeningTab.swift
//  a1-s3713342
//
//  Created by 민철 on 22/8/23.
//

import SwiftUI

struct ListeningTab: View {
    
    @Binding var blocks: [BlockType]
    @Binding var notificationSettings: [NotificationSetting]
    @State private var navigateToNext = false
    @State private var navigateToCustom = false
    @State private var arrowOffset: CGFloat = 0
    
    
    
    var body: some View {
        ZStack {
            Color.black.edgesIgnoringSafeArea(.all)
            VStack {
                HStack {
                    Text("#USERNAME")
                        .font(.system(size: 30))
                        .fontWeight(.bold)
                        .foregroundColor(.purple)
                        .padding(.leading, 30)  // 여기에 패딩 추가
                    Spacer()
                }
                
                HStack {
                    Text("here is what you're")
                        .font(.system(size: 30))
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                        .padding(.leading, 30)  // 여기에 패딩 추가
                    Spacer()
                }
                
                HStack {
                    Text("listening to...")
                        .font(.system(size: 30))
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                        .padding(.leading, 30)  // 여기에 패딩 추가
                    Spacer()
                }
                
                // If user add no blocks, message is shown
                if blocks.isEmpty {
                    VStack {
                        Spacer() // 위쪽으로 밀어냄
                        Text("No blocks added")
                            .font(.system(size: 30))
                            .fontWeight(.regular)
                            .foregroundColor(.gray)
                        
                        // User guide arrow
                        Image(systemName: "arrow.down")
                            .resizable()
                            .frame(width: 30, height: 30)
                            .foregroundColor(.gray)
                            .offset(y: arrowOffset)
                            .onAppear() {
                                withAnimation(Animation.easeInOut(duration: 1).repeatForever(autoreverses: true)) {
                                    arrowOffset = 200
                                }
                            }
                        Spacer()
                    }
                } else {
                    ForEach(blocks, id: \.self) { block in
                        NavigationLink(destination: BlockSettingView(block: block, notificationSettings: $notificationSettings, blocks: $blocks)) {
                            genericBlock(block: block)
                        }
                    }
                }
                
                Spacer()
                
                NavigationLink(destination: AddListenerFlowView0(blocks: $blocks, notificationSettings: $notificationSettings, navigateToNext: $navigateToNext, navigateToCustom: $navigateToCustom), isActive: $navigateToNext) {
                    
                    HStack {
                        //Spacer() // HStack의 오른쪽으로 밀어냄
                        
                        //Bottom button
                        plusButton()
                            .offset(y: -20)  // 위로 20 픽셀 올림
                                            /*.padding(.bottom, 20)  // 아래쪽에 20픽셀 패딩
                                            .padding(.trailing, 20)// 오른쪽에 20픽셀 패딩*/
                    }
                }
                .isDetailLink(false)
            }
        }
    }
}


struct ListeningTab_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            // Preview with no blocks
             ListeningTab(blocks: .constant([]), notificationSettings: .constant([]))
            
            // Preview with some sample blocks
            /*ListeningTab(blocks: .constant([.zoraNFTs, .coins]), notificationSettings: .constant([]))*/
        }
    }
}






