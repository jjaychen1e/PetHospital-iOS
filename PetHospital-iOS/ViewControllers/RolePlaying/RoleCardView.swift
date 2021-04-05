//
//  RoleCardView.swift
//  PetHospital-iOS
//
//  Created by jjaychen on 2021/3/10.
//

import SwiftUI

struct RoleCardView: View {
    var role: Role
    var body: some View {
        Button(action: {}, label: {
            VStack(alignment: .leading) {
                Image("example_doctor")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                VStack (alignment: .leading) {
                    HStack(alignment: .center) {
                        Text(role.name)
                            .font(Font.title.bold())
                        Text(role.emoji)
                            .font(.system(size: 28))
                    }
                    Text(role.description)
                }
                .foregroundColor(.primary)
                .padding()
            }
            .background(
                Color(Asset.dynamicSecondaryBackground.color)
            )
            .cornerRadius(25)
            .padding()
            .shadow(color: Color.black.opacity(0.2), radius: 4, x: 1, y: 1)
        })
    }
}

struct RoleCardView_Previews: PreviewProvider {
    static var previews: some View {
        RoleCardView(role: Role(id: 0, name: "医生", description: "描述"))
    }
}
