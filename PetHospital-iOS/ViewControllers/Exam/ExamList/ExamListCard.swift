//
//  ExamListCard.swift
//  PetHospital-iOS
//
//  Created by jjaychen on 2021/4/3.
//

import SwiftUI

class ExamListCardViewModel: ObservableObject {
    @Published var title = ""
    @Published var totalQuestionNumber = 0
    @Published var totalQuestionScore = 0
    @Published var startDateTime = "0000-00-00 00:00"
    @Published var endDateTime = "0000-00-00 00:00"
    @Published var action: () -> () = {}
}

struct ExamListCard: View {
    @ObservedObject var viewModel: ExamListCardViewModel
    
    var body: some View {
        Button(action: viewModel.action, label: {
            HStack {
                Text("📄")
                    .font(.largeTitle)
                    .frame(width: 50)
                VStack(alignment: .leading) {
                    Text(viewModel.title)
                        .font(.title).fontWeight(.bold)
                    Text("共 \(viewModel.totalQuestionNumber) 题 计 \(viewModel.totalQuestionScore) 分")
                        .font(.body)
                    Spacer()
                    Text("开始时间 \(viewModel.startDateTime)")
                        .font(Font.system(.subheadline, design: .monospaced).weight(.bold))
                    Text("结束时间 \(viewModel.endDateTime)")
                        .font(Font.system(.subheadline, design: .monospaced).weight(.bold))
                }
                .frame(height: 130)
                Spacer()
            }
            .foregroundColor(.primary)
            .frame(maxWidth: .infinity)
            .padding(.all, 32)
            .background(
                RoundedRectangle(cornerRadius: 28, style: .continuous)
                    .foregroundColor(Color(Asset.dynamicSecondaryBackground.color))
                    .shadow(color: Color.black.opacity(0.2), radius: 4, x: 1, y: 1)
                    .padding()
            )
        })
    }
}

struct ExamListCard_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ExamListCard(viewModel: ExamListCardViewModel())
                .background(Color.gray)
        }
    }
}
