//
//  TouringListView.swift
//  PetHospital-iOS
//
//  Created by jjaychen on 2021/3/10.
//

import SwiftUI
import Kingfisher

struct TouringListView: View {
    @ObservedObject var departmentViewModel: DepartmentViewModel
    
    var body: some View {
        List {
            ForEach(departmentViewModel.departments, id: \.id) { department in
                NavigationLink(destination: Text("Second View")) {
                    HStack {
                        KFImage(URL(string: department.picture))
                            .resizable()
                            .frame(width: 44, height: 44, alignment: .center)
                        Text("\(department.name)")
                    }
                }
            }
        }
    }
}

struct TouringListView_Previews: PreviewProvider {
    static var previews: some View {
        let departmentViewModel = DepartmentViewModel()
        var departments = Array<Department>()
        for i in 0..<100 {
            departments.append(.init(id: i, name: "科室\(i)", description: "科室\(i)的描述", picture: "https://cdn.jsdelivr.net/gh/JJAYCHENFIGURE/Image/img/A02/avatar_2020_03_19_16_43.png", roleName: "科室\(i)的负责人", position: [], equipments: []))
        }
        departmentViewModel.departments = departments
        return TouringListView(departmentViewModel: departmentViewModel)
    }
}
