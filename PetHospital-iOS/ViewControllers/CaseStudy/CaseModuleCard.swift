//
//  CaseModuleCard.swift
//  PetHospital-iOS
//
//  Created by jjaychen on 2021/4/4.
//

import SwiftUI

struct CaseModuleCard: View {
    var title: String
    var description: String
    var index: Int
    
    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            Image(systemName: "\(index).circle.fill")
                .resizable()
                .frame(width: 24, height: 24)
                .foregroundColor(.blue)
            VStack(alignment: .leading, spacing: 12) {
                Text(title)
                    .font(.headline)
                Text(description)
            }
            Spacer()
        }
        .frame(maxWidth: .infinity)
        .padding(.all, 32)
        .background(
            RoundedRectangle(cornerRadius: 12, style: .continuous)
                .foregroundColor(Color(Asset.dynamicSecondaryBackground.color))
                .shadow(color: Color.black.opacity(0.2), radius: 4, x: 1, y: 1)
                .padding()
        )
    }
}

struct CaseModuleCard_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            CaseModuleCard(title: "病例检查", description: "您应该避免集会活动，并与家人以外的所有人保持 6 英尺的距离。尤其注意避开表现出相关症状的人。\n\n另外，出门时应戴布口罩。您还应该经常清洁双手，避免触摸脸部。", index: 1)
            CaseModuleCard(title: "病例检查", description: "您应该避免集会活动", index: 2)
        }
    }
}
