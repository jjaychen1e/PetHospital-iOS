//
//  RolePlayingView.swift
//  PetHospital-iOS
//
//  Created by jjaychen on 2021/3/10.
//

import SwiftUI

struct RolePlayingView: View {
    var roles: [Role]
    var body: some View {
        ScrollView {
            VStack {
                ForEach(roles) { role in
                    NavigationLink(destination: Text("Destination")) {
                        RoleCardView(role: role)
                    }
                }
            }
            .padding(.horizontal)
            .padding(.vertical)
        }
    }
}

struct RolePlayingView_Previews: PreviewProvider {
    
    static var previews: some View {
        var roles = Array<Role>()
        roles.append(Role(name: "医生", description: "这里会有医生的一堆描述。这里会有医生的一堆描述。这里会有医生的一堆描述。这里会有医生的一堆描述。这里会有医生的一堆描述。这里会有医生的一堆描述。这里会有医生的一堆描述。这里会有医生的一堆描述。"))
        roles.append(Role(name: "医助", description: "这里会有医生的一堆描述。这里会有医生的一堆描述。这里会有医生的一堆描述。这里会有医生的一堆描述。这里会有医生的一堆描述。这里会有医生的一堆描述。这里会有医生的一堆描述。这里会有医生的一堆描述。"))
        roles.append(Role(name: "前台", description: "这里会有医生的一堆描述。这里会有医生的一堆描述。这里会有医生的一堆描述。这里会有医生的一堆描述。这里会有医生的一堆描述。这里会有医生的一堆描述。这里会有医生的一堆描述。这里会有医生的一堆描述。"))
        roles.append(Role(name: "前台", description: "这里会有医生的一堆描述。这里会有医生的一堆描述。这里会有医生的一堆描述。这里会有医生的一堆描述。这里会有医生的一堆描述。这里会有医生的一堆描述。这里会有医生的一堆描述。这里会有医生的一堆描述。"))
        roles.append(Role(name: "前台", description: "这里会有医生的一堆描述。这里会有医生的一堆描述。这里会有医生的一堆描述。这里会有医生的一堆描述。这里会有医生的一堆描述。这里会有医生的一堆描述。这里会有医生的一堆描述。这里会有医生的一堆描述。"))
        return RolePlayingView(roles: roles)
    }
}

struct RoleCardView: View {
    var role: Role
    var body: some View {
        HStack {
            Text(role.emoji)
                .font(.system(size: 50))
            VStack (alignment: .leading) {
                Text(role.name)
                    .font(.largeTitle)
                Text(role.description)
            }
            .foregroundColor(.primary)
            Spacer()
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 25.0, style: .continuous)
                .foregroundColor(.gray)
        )
    }
}
