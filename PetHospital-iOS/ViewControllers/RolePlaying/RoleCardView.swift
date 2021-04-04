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
        HStack {
            Text(role.emoji)
                .font(.system(size: 50))
            VStack (alignment: .leading) {
                Text(role.name)
                    .font(Font.largeTitle.bold())
                Text(role.description)
            }
            .foregroundColor(.primary)
            Spacer()
        }
        .padding(.all, 32)
        .background(
            RoundedRectangle(cornerRadius: 25.0, style: .continuous)
                .padding()
                .foregroundColor(Color(Asset.dynamicSecondaryBackground.color))
                .shadow(color: Color.black.opacity(0.2), radius: 4, x: 1, y: 1)
        )
    }
}

struct RoleCardView_Previews: PreviewProvider {
    static var previews: some View {
        RoleCardView(role: Role(id: 0, name: "一生", description: "描述"))
    }
}
