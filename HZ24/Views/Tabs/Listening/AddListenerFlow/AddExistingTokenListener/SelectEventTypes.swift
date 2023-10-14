//
// SelectEventTypes.swift
// HZ24
// 
// Created by jin on 2023-10-06
// 



import SwiftUI

struct SelectEventTypes: View {
    
    @Environment(\.managedObjectContext) private var viewContext

    
    var newListener: ExistingTokenListener?
    
    @State private var listenToMetadataEvents = false
    @State private var listenToMintCommentEvents = false
    
    var body: some View {
        VStack {
            ProgressView(value: 0.66)
            Spacer()
            Text("Select events to listen to")
                .font(.largeTitle.bold())
            Button {
                newListener?.listeningForMetadataEvents.toggle()
                listenToMetadataEvents.toggle()
            } label: {
                HStack {
                    Text("Metadata Events")
                        .font(.title2)
                    .padding()
                    
                    if listenToMetadataEvents {
                        Image(systemName: "checkmark")
                    } else {
                        /*@START_MENU_TOKEN@*/EmptyView()/*@END_MENU_TOKEN@*/
                    }
                    
                }
            }
            Button {
                newListener?.listeningForMintCommentEvents.toggle()
                listenToMintCommentEvents.toggle()
            } label: {
                HStack {
                    Text("Mint Comment Events")
                        .font(.title2)
                    .padding()
                    
                    if listenToMintCommentEvents {
                        Image(systemName: "checkmark")
                    } else {
                        /*@START_MENU_TOKEN@*/EmptyView()/*@END_MENU_TOKEN@*/
                    }
                }
            }
            NavigationLink {
                NotificationSelection()
            } label: {
                Text("Continue")
                    
            }
            Spacer()



        }
        .padding()
        .preferredColorScheme(.dark)
    }
}

struct SelectEventTypes_Previews: PreviewProvider {
    static let coreDataProvider = CoreDataProvider.preview
    // Preview
    static let newListener = ExistingTokenListener(context: coreDataProvider.container.viewContext)

    static var previews: some View {
        SelectEventTypes(newListener: newListener)
            .environment(\.managedObjectContext, coreDataProvider.container.viewContext)

    }
}
