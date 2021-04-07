//
//  DepartmentCardView.swift
//  PetHospital-iOS
//
//  Created by jjaychen on 2021/4/4.
//

import SwiftUI
import Kingfisher

class DepartmentCardViewModel: ObservableObject {
    @Published var department: Department = Department(id: 0, name: "专科检查室", description: "负责对眼科、骨科、神经科、心脏科等专科疾病的检查，如眼科（检眼镜检查、眼压检查、裂隙灯检查、眼底检查、泪液分泌量检查等）、心脏科检查（心脏听诊、心电图检查等）、神经学检查（步态检查、各种反射检查等）等。", picture: "http://152.136.173.30/images/pethospital/HospitalClinic.jpg", roleName: "", position: [], equipments: [])
    @Published var tapAction: () -> () = {}
}

struct DepartmentCardView: View {
    
    @ObservedObject var viewModel: DepartmentCardViewModel
    
    var body: some View {
        Button(action: viewModel.tapAction, label: {
            VStack(alignment: .leading, spacing: 0) {
                KFImage(URL(string: viewModel.department.picture)!)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
//
                HStack {
                    VStack(alignment: .leading, spacing: 10) {
                        Text(viewModel.department.name)
                            .font(Font.title.bold())
                        Group {
                            Text(viewModel.department.description)
                            
                            if viewModel.department.equipments.count >= 3 {
                                Text("该科室内含有") + Text("\(viewModel.department.equipments[0].name)").fontWeight(.bold) + Text("、") + Text("\(viewModel.department.equipments[1].name)").fontWeight(.bold) + Text("和")  + Text("\(viewModel.department.equipments[2].name)").fontWeight(.bold) + Text("等。")
                            } else if viewModel.department.equipments.count == 2 {
                                Text("该科室内含有") + Text("\(viewModel.department.equipments[0].name)").fontWeight(.bold) + Text("和") + Text("\(viewModel.department.equipments[1].name)").fontWeight(.bold) + Text("。")
                            } else if viewModel.department.equipments.count == 1 {
                                Text("该科室内含有") + Text("\(viewModel.department.equipments[0].name)").fontWeight(.bold) + Text("。")
                            } else if viewModel.department.equipments.count == 0 {
                                Text("该科室暂无设备信息。")
                            }
                        }
                        .font(.body)
                    }
                    .padding()
                    
                    Spacer()
                }
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
        DepartmentCardView(viewModel: DepartmentCardViewModel())
            .frame(width: 200, height: 400)
    }
}
