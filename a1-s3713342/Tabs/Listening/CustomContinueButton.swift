//
//  CustomContinueButton.swift
//  a1-s3713342
//
//  Created by 민철 on 26/8/23.
//

import SwiftUI

// Generic Block Button
func genericBlock(block: BlockType) -> some View {
    ZStack {
        RoundedRectangle(cornerRadius: 15)
            .stroke(Color.white, lineWidth: 2)
            .background(Color.black)
            .frame(width: 350, height: 70)
            .overlay(
                Text(block.rawValue)
                    .foregroundColor(.white)
                    .font(.largeTitle)
                    .padding(.leading, 10),
                alignment: .leading
            )
            .overlay(
                ZStack {
                    RoundedRectangle(cornerRadius: 5)
                        .fill(LinearGradient(gradient: Gradient(colors: [Color.pink, Color.purple]), startPoint: .leading, endPoint: .trailing))
                        .frame(width: 60, height: 20)
                    
                    Text("Generic")
                        .foregroundColor(.white)
                        .font(.caption)
                }
                .padding([.top, .trailing], 10),
                alignment: .topTrailing
            )
    }
}


// '+' Button
func plusButton() -> some View {
    Image(systemName: "plus")
        .font(.system(size: 40))
        .frame(width: 60, height: 60)  // 너비와 높이를 동일하게 설정하여 원 형태가 되도록 합니다.
        .foregroundColor(.white)
        .background(Color.black)
        .overlay(
            Circle()  // 테두리를 원으로 설정
                .stroke(Color.white, lineWidth: 2)
        )
}


func customContinueButton() -> some View {
    Image(systemName: "arrow.right")
        .font(.system(size: 40))
        .foregroundColor(.black)
        .frame(width: 200, height: 70)
        .background(Color.white)
        .border(Color.white, width: 5)
        .cornerRadius(10)
}

func customCheckButton(isChecked: Bool) -> some View {
    ZStack {
        RoundedRectangle(cornerRadius: 10)  // 배경에 둥근 모서리의 직사각형
            .fill(isChecked ? Color.green : Color.white)  // 체크 상태에 따라 배경색 변경
            .frame(width: 400, height: 100)  // 크기 설정
        
        if isChecked {
            //Little circle
            Circle()
                .fill(Color.black)
                .frame(width: 30, height: 30)
                .offset(x: 180, y: -30)
            
            //Checkmark
            Image(systemName: "checkmark")  // 체크 상태일 경우 체크마크 아이콘 표시
                .foregroundColor(.green)  // green
                .offset(x: 180, y: -30)  // 오른쪽 위로 이동
        }
    }
}
