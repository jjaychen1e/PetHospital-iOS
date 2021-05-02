//
//  WorkflowListView.swift
//  PetHospital-iOS
//
//  Created by jjaychen on 2021/4/7.
//

import SwiftUI
import Kingfisher
import Introspect

struct WorkflowListView: View {
    
    var role: Role
    @State private var workflows: [Workflow] = [
//        Workflow(id: 1, name: "术前消毒流程"),
//        Workflow(id: 2, name: "术前消毒流程"),
//        Workflow(id: 3, name: "术前消毒流程"),
//        Workflow(id: 4, name: "术前消毒流程"),
//        Workflow(id: 5, name: "术前消毒流程"),
//        Workflow(id: 6, name: "术前消毒流程"),
    ]
    
    @State private var rootViewController: UIViewController?
    
    var body: some View {
        ScrollView {
            LazyVStack(alignment: .leading) {
                KFImage(URL(string: role.picture)!)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                
                VStack(alignment: .leading, spacing: 16) {
                    Text("\(role.name)角色扮演流程")
                        .font(.largeTitle).fontWeight(.bold)
                    
                    Text(role.description)
                    
                    VStack(alignment: .leading, spacing: 8) {
                        Text("选择流程参与体验")
                            .font(.headline)
                        if workflows.count > 0 {
                            VStack(alignment: .leading, spacing: 16) {
                                ForEach(workflows) { workflow in
                                    Button(action: {
                                        rootViewController?.present(UIHostingController(rootView: WorkflowStepsView(workflow: workflow)), animated: true, completion: nil)
                                    }) {
                                        HStack {
                                            Text("流程")
                                                .font(.headline)
                                            Text(workflow.name)
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
                                    .foregroundColor(.primary)
                                }
                            }
                        } else {
                            Text("该角色暂无可选流程。")
                        }
                    }
                }
                .padding()
            }
            .onAppear {
                let parameters = ["roleId": role.id]
                NetworkManager.shared.fetch(endPoint: .allWorkflows, method: .POST, parameters: parameters) { (result: Result<ResultEntity<[Workflow]>, Error>) in
                    result.resolve { result in
                        if result.code == .success, let workflows = result.data {
                            self.workflows = workflows
                        } else {
                            print(result)
                        }
                    }
                }
            }
            .introspectViewController(customize: { (rootViewController) in
                self.rootViewController = rootViewController
            })
        }
    }
    
}

struct WorkflowListView_Previews: PreviewProvider {
    static var previews: some View {
        WorkflowListView(role: Role(id: 1, name: "医生", picture: "https://pethospital-1255582475.cos-website.ap-shanghai.myqcloud.com/role/doctor.jpg"))
    }
}
