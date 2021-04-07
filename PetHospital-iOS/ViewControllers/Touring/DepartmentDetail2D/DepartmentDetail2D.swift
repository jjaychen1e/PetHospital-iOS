//
//  DepartmentDetail2D.swift
//  PetHospital-iOS
//
//  Created by jjaychen on 2021/4/7.
//

import SwiftUI
import Kingfisher
import UIImageColors

struct DepartmentDetail2D: View {
    @ObservedObject var viewModel: DepartmentCardViewModel
    
    @State var titleColor: Color = .black
    
    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                ZStack(alignment: .topLeading) {
                    KFImage(URL(string: viewModel.department.picture))
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                    Text(viewModel.department.name)
                        .font(.largeTitle).fontWeight(.bold)
                        .padding()
                        .foregroundColor(titleColor)
                        .animation(.spring())
                }
                LazyVStack(alignment: .leading, spacing: 16) {
                    HStack(alignment: .top) {
                        Text("科室描述")
                            .font(.headline)
                        Text(viewModel.department.description)
                        Spacer()
                    }
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(
                            Color(Asset.dynamicSecondaryBackground.color)
                        )
                        .cornerRadius(12)
                        .shadow(color: Color.black.opacity(0.2), radius: 4, x: 1, y: 1)
                    
                    HStack(alignment: .top) {
                        Text("科室设备")
                            .font(.headline)
                        
                        if viewModel.department.equipments.isEmpty {
                            HStack {
                                Text("该科室暂无设备信息。")
                                Spacer()
                            }
                        } else {
                            VStack {
                                ForEach(viewModel.department.equipments) { equipment in
                                    HStack(alignment: .top) {
                                        KFImage(URL(string: equipment.picture)!)
                                            .resizable()
                                            .aspectRatio(contentMode: .fit)
                                            .frame(width: 35, height: 35)
                                        VStack(alignment: .leading) {
                                            Text(equipment.name)
                                                .font(.body)
                                                .fontWeight(.bold)
                                            Text(equipment.description)
                                        }
                                        Spacer()
                                    }
                                }
                            }
                        }
                        
                        Spacer()
                    }
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(
                            Color(Asset.dynamicSecondaryBackground.color)
                        )
                        .cornerRadius(12)
                        .shadow(color: Color.black.opacity(0.2), radius: 4, x: 1, y: 1)
                }
                .padding(.horizontal)
            }
        }
        .onAppear {
            let uiImageView = UIImageView()
            uiImageView.kf.setImage(with: URL(string: viewModel.department.picture)!) { result in
                switch result {
                case .success(_):
                    uiImageView.image?.getColors() { colors in
                        if let background = colors?.background {
                            var fRed : CGFloat = 0
                            var fGreen : CGFloat = 0
                            var fBlue : CGFloat = 0
                            var fAlpha: CGFloat = 0
                            background.getRed(&fRed, green: &fGreen, blue: &fBlue, alpha: &fAlpha)
                            let luminance = (0.299 * fRed * 255 + 0.587 * fGreen * 255 + 0.114 * fBlue * 255)
                            
                            if luminance < 150 {
                                titleColor = .white
                            }
                        }
                    }
                default:
                    break
                }
            }
        }
    }
}

struct DepartmentDetail2D_Previews: PreviewProvider {
    static var previews: some View {
        DepartmentDetail2D(viewModel: DepartmentCardViewModel())
    }
}
