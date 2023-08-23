//
//  ContentView.swift
//  a1-s3713342
//
//  Created by 민철 on 2023/08/12.
//

import SwiftUI

struct ContentView: View {
    @State var blocks: [BlockType] = []
    @State var notificationSettings: [NotificationSetting] = [.eventsFeed]
    //@Binding var blocks: [BlockType]
    //@Binding var notificationSettings: [NotificationSetting]
    
    @State private var viewSelection = 1
    @State private var navigateToNext = false
    @State private var navigateToCustom = false // for custom page
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.black.edgesIgnoringSafeArea(.all) // set black background
                VStack {
                    HStack {
                        Text("Listening")
                            .foregroundColor(viewSelection == 0 ? .white : .gray)
                        Text("Feed")
                            .foregroundColor(viewSelection == 1 ? .white : .gray)
                        Text("Saved")
                            .foregroundColor(viewSelection == 2 ? .white : .gray)
                        Text("Chat")
                            .foregroundColor(viewSelection == 3 ? .white : .gray)
                    }
                    .font(.headline)
                    .padding()


                    TabView(selection: $viewSelection) {
                        // Listening tab
                        ZStack {
                            Color.black.edgesIgnoringSafeArea(.all)
                            VStack {
                                ForEach(blocks, id: \.self) { block in
                                    NavigationLink(destination: BlockSettingView(block: block, notificationSettings: $notificationSettings)) {
                                        HStack {
                                            Image("block-generic")
                                                .overlay(
                                                    Text(block.rawValue)
                                                        .foregroundColor(.black)  // color
                                                        .font(.headline)          // fontsize
                                                        .padding(.leading, 10),   // 10pt padding
                                                    alignment: .leading
                                                )
                                        }
                                    }
                                }
                                Spacer()
                                NavigationLink(destination: AddListenerFlowView0(blocks: $blocks, notificationSettings: $notificationSettings, navigateToNext: $navigateToNext, navigateToCustom: $navigateToCustom), isActive: $navigateToNext) {
                                    Image("add-event")
                                }
                                .isDetailLink(false) // ensures that the back stack is cleared

                            }
                        }
                        .tag(0)
                        .foregroundColor(.white)
                        
                        // Last 24H Feed Tab
                        VStack {
                            Text("Events captured in the Last 24 Hours")
                                .font(.largeTitle)
                                .foregroundColor(.white)
                            
                            // Divide captured events by hour blocks
                            Hourmark(label: "12:00")
                            
                            Spacer()
                        }
                        .tag(1)
                        
                        // Saved tab
                        ZStack {
                            Color.black.edgesIgnoringSafeArea(.all)
                            VStack(spacing: 20) {
                                Text("Your saved events will show up on this page.")
                                    .font(.system(size: 24))
                                    .foregroundColor(.white)
                                    .padding(.top, 50)
                                Spacer()
                                
                                VStack(spacing: 15) {
                                    Text("To save events:")
                                        .foregroundColor(.white)
                                        .font(.headline)
                                    
                                    Text("1. Navigate to Feed")
                                        .foregroundColor(.white)
                                    Text("2. Tap on an event")
                                        .foregroundColor(.white)
                                    Text("3. Tap “Save”")
                                        .foregroundColor(.white)
                                }
                                .padding()
                                .overlay(
                                    RoundedRectangle(cornerRadius: 10)
                                        .stroke(Color.white, lineWidth: 2)
                                )
                                
                                VStack(spacing: 15) {
                                    Image("icon")
                                        .resizable()
                                        .frame(width: 100, height: 100) // Adjust this to fit the icon's aspect ratio
                                    Text("<helper_animation>")
                                        .foregroundColor(.white)
                                }
                                .padding()
                                .overlay(
                                    RoundedRectangle(cornerRadius: 10)
                                        .stroke(Color.white, lineWidth: 2)
                                )
                                
                                Spacer()
                            }
                        }
                            .padding(.horizontal)
                            .background(Color.black.edgesIgnoringSafeArea(.all))
                            .tag(2)
                            .foregroundColor(.white)
                        
                        Text("Chat")
                            .tag(3)
                            .foregroundColor(.white)
                    }
                    .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never)) // Hide indicator
                }
            }
            .navigationBarHidden(true)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}


