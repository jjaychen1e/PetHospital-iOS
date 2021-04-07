//
//  RoleCardView.swift
//  PetHospital-iOS
//
//  Created by jjaychen on 2021/3/10.
//

import SwiftUI
import Kingfisher

struct RoleCardView: View {
    var role: Role
    var action: () -> () = {}
    var body: some View {
        Button(action: action, label: {
            VStack(alignment: .leading, spacing: 0) {
                KFImage(URL(string: role.picture)!)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                VStack (alignment: .leading, spacing: 10) {
                    HStack(alignment: .center) {
                        Text(role.name)
                            .font(Font.title.bold())
                        Text(role.emoji)
                            .font(.system(size: 28))
                    }
                    Text(role.description)
                        .font(.subheadline)
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
        RoleCardView(role: Role(id: 0, name: "医生", picture: "https://pethospital-1255582475.cos-website.ap-shanghai.myqcloud.com/role/doctor.jpg", description: "描述"))
    }
}
