//
//  EventDetailView.swift
//  a1-s3713342
//
//  Created by Jin on 2023-08-26.
//

import SwiftUI

struct EventDetailView: View {
    
    @Environment(\.dismiss) var dismiss
    var event: EventData

    var body: some View {
            
            ZStack {
                LinearGradient(colors: [.orange, Color("gradientTrailingBrown")], startPoint: .top, endPoint: .bottomTrailing)

                VStack {
                    HStack {
                        Text("\(event.eventType.name)")
                            .foregroundStyle(.black)
                            .font(.largeTitle.bold())
                            .padding(20)
                        
                        Spacer()
                    }
                    
                    VStack {
                        HStack {
                            Text("Smart Contract")
                                .font(.callout.bold())
                            Spacer()
                        }
                        VStack {
                            HStack {
                                Text("Name")
                                Spacer()
                                Text("\(event.smartContract.tokenName)")
                            }
                            HStack {
                                Text("Address")
                                Spacer()
                                Text("\(event.smartContract.address)")
                            }
                        }
                        .padding(10)
                        .overlay {
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(.black, lineWidth: 2)
                        }
                    }
                    
                    VStack {
                        HStack {
                            Text("Event")
                                .font(.callout.bold())
                            Spacer()
                        }
                        VStack {
                            HStack {
                                Text("Name")
                                Spacer()
                                Text("\(event.eventType.name)")
                            }
                            HStack {
                                Text("Description")
                                Spacer()
                                Text("\(event.eventType.description)")
                            }
                            HStack {
                                Text("Timestamp")
                                Spacer()
                                Text("\(timeIntervalToHourmarkLabel(timeInterval: event.eventTimestamp))")
                            }
                            HStack {
                                Text("Block Number")
                                Spacer()
                                Text("\(event.eventLog.blockNumber)")
                            }
                            HStack {
                                Text("Tx Hash")
                                Spacer()
                                Text("\(event.eventLog.txHash)")
                            }
                        }
                        .padding(10)
                        .overlay {
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(.black, lineWidth: 2)
                        }
                    }
                    
                    Spacer()

                    Button {
                        //
                    } label: {
                        Text("Save")
                            .font(.title2)
                            .foregroundStyle(.gray)
                            .frame(width: 200, height: 50)
                            .background(.black)
                            .cornerRadius(10)
                            .overlay {
                                HStack {
                                    Spacer()
                                    Image(systemName: "bookmark.circle")
                                        .font(.title)
                                        .foregroundStyle(.gray)
                                        .padding(10)
                                }
                            }
                    }

                    
                }
                .padding(.top, 60)
                .padding([.bottom, .horizontal], 30)

            }
            .overlay(
                VStack {
                    HStack {
                        Spacer()
                        Button {
                            dismiss()
                        } label: {
                            Image(systemName: "xmark")
                                .font(.largeTitle)
                                .foregroundStyle(.black)
                        }
                        .padding(.trailing, 15)
                        .padding(.top, 8)
                        
                    }
                    .frame(height: 60)
//                    .background(.white)
                    Spacer()
                }
            )
//            .background(.black).edgesIgnoringSafeArea(.all)

    }
}

struct EventDetailView_Previews: PreviewProvider {
    static var previews: some View {
        let eventData = getEventData()
        TimeSegment(toTimestamp: Constants.dummyCurrentTimeInterval, eventData: eventData!)
    }
}

//struct EventDetailView_Previews: PreviewProvider {
//    static var previews: some View {
//        EventDetailView()
//    }
//}

// Custom GroupBox Style
struct CustomBackground: GroupBoxStyle {
    func makeBody(configuration: Configuration) -> some View {
        VStack {
            HStack {
                configuration.label
                    .font(.headline)
                Spacer()
            }
            
            configuration.content
        }
        .padding()
        .background(RoundedRectangle(cornerRadius: 8, style: .continuous)
            .fill(.clear))
    }
}
