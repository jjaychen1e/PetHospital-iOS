//
//  TouringListView.swift
//  PetHospital-iOS
//
//  Created by jjaychen on 2021/3/10.
//

import SwiftUI
import SDWebImageSwiftUI

struct TouringListView: View {
    @ObservedObject var departmentViewModel: DepartmentViewModel
    
    var body: some View {
        List {
            ForEach(departmentViewModel.departments, id: \.id) { department in
                NavigationLink(destination: Text("Second View")) {
                    HStack {
                        WebImage(url: URL(string: department.thumbnail))
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
        for _ in 0..<100 {
            departments.append(.init(name: "科室名", thumbnail: "https://cdn.jsdelivr.net/gh/JJAYCHENFIGURE/Image/img/A02/avatar_2020_03_19_16_43.png"))
        }
        departmentViewModel.departments = departments
        return TouringListView(departmentViewModel: departmentViewModel)
    }
}
