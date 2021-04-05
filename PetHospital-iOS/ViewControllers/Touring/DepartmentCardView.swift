//
//  DepartmentCardView.swift
//  PetHospital-iOS
//
//  Created by jjaychen on 2021/4/4.
//

import SwiftUI

struct DepartmentCardView: View {
    var name: String
    var description: String
    
    var body: some View {
        Button(action: {}, label: {
            VStack(alignment: .leading, spacing: 0) {
                Image("example_department")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                
                VStack(alignment: .leading, spacing: 10) {
                    Text(name)
                        .font(Font.title.bold())
                    
                    Group {
                        Text(description)
                            .fixedSize(horizontal: false, vertical: true)
                        Text("该室内含有仪器A、仪器B和仪器C等。")
                    }
                    .font(.subheadline)
                }
                .padding()
            }
            .foregroundColor(Color(Asset.dynamicBlack.color))
            .background(
                Color(Asset.dynamicSecondaryBackground.color)
            )
            .cornerRadius(25)
            .padding()
            .shadow(color: Color.black.opacity(0.2), radius: 4, x: 1, y: 1)
        })
    }
}

struct DepartmentCardView_Previews: PreviewProvider {
    static var previews: some View {
        DepartmentCardView(name: "前台", description: "负责接待挂号、导医咨询、病历档案发出与回收、收费等。")
    }
}
