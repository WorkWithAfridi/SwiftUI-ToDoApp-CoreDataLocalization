//
//  TaskDetailView.swift
//  ToDoApp
//
//  Created by Sabari on 25/07/21.
//

import SwiftUI
import Foundation
import UIKit

struct TaskDetailView: View {
    
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var viewModel: LandingViewModel
    @State var taskDetails:TaskList!
    
    var body: some View {
        ZStack{
            Color.blue.edgesIgnoringSafeArea(.all)
            VStack(alignment:.leading){
                TaskDetailsHeader(taskDetails: taskDetails, viewModel: viewModel)
                List{
                    ForEach(taskDetails.taskList) { task in
                        TaskDetailsCell(viewModel: viewModel, task: task)
                    }
                }
                .cornerRadius(20)
            }
            .padding()
        }
        .navigationBarBackButtonHidden(true)
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarItems(leading: Button(action: {
            self.presentationMode.wrappedValue.dismiss()
        }, label: {
            
            HStack{
                Image("back")
                    .resizable()
                    .frame(width: 35, height: 35)
                Spacer()
            }
        }))
    }
}

struct TaskDetailView_Previews: PreviewProvider {
    static var previews: some View {
        TaskDetailView(viewModel: .init())
    }
}

struct TaskDetailsHeader:View {
    @State var taskDetails:TaskList!
    @State private var isShowingDeleteConfirmation = false
    @State private var taskToDelete: Task?
    @ObservedObject var viewModel: LandingViewModel
    var body: some View{
        HStack{
            VStack(alignment:.leading){
                Circle()
                    .frame(width: 40, height: 40)
                    .foregroundColor(.white)
                    .overlay(
                        taskDetails.categoryImage
                            .resizable()
                            .frame(width: 28, height: 28)
                    )
                
                Text(LocalizedStringKey(taskDetails.categoryName))
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(.white)
                
                Text("\(taskDetails.noOfTasks) tasks")
                    .foregroundColor(.white.opacity(0.8))
                    .font(.callout)
                
                Spacer()
                    .frame(height: 30)
            }
            Spacer()
            Button {
                taskToDelete = taskDetails.taskList.first
                isShowingDeleteConfirmation.toggle()
            } label: {
                Text("Delete")
                    .foregroundColor(.white)
                    .bold()
            }
        }
        .padding()
        .actionSheet(isPresented: $isShowingDeleteConfirmation) {
            ActionSheet(
                title: Text("Delete Task"),
                message: Text("Are you sure you want to delete this task?"),
                buttons: [
                    .destructive(Text("Delete")) {
                        if let taskToDelete = taskToDelete {
                            CoreDataManager.shared.deleteTask(task: taskToDelete)
                            viewModel.taskList = viewModel.getAllTaskList()
                        }
                    },
                    .cancel(Text("Cancel"))
                ]
            )
        }
    }
}

struct TaskDetailsCell:View {
    
    @ObservedObject var viewModel: LandingViewModel
    @State var task:Task!
    
    var body: some View{
        HStack{
            VStack(alignment:.leading){
                Text(task.taskName ?? "")
                    .font(.callout)
                    .foregroundColor(task.taskCompleted ? .blue : .black)
                    .strikethrough(task.taskCompleted ? true : false, color: .blue)
                Text(getDateFormatString(date: task.taskDate ?? Date()))
                    .font(.caption)
                    .foregroundColor(task.taskCompleted ? .blue : .black)
                    .strikethrough(task.taskCompleted ? true : false, color: .blue)
            }
            Spacer()
            Button(action: {
                let taskObj = task
                taskObj?.taskCompleted.toggle()
                CoreDataManager.shared.save()
                viewModel.taskList = viewModel.getAllTaskList()
                
            }){
                Image(task.taskCompleted ? "checkbox_fill"  : "checkbox")
                    .resizable()
                    .foregroundColor(task.taskCompleted ? .blue :.gray)
                    .frame(width: 25, height: 25)
            }
        }
        .padding()
        .gesture(
            DragGesture()
                .onEnded { value in
                    if value.translation.width < 0 {
                        // Perform action when swiping left
                        let taskObj = task
                        taskObj?.taskCompleted.toggle()
                        CoreDataManager.shared.save()
                        viewModel.taskList = viewModel.getAllTaskList()
                    }
                }
        )
    }
}


func getDateFormatString(date:Date) -> String
{
    var dateString = ""
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "dd-MMM-yyyy,h:mm a"
    
    dateString = dateFormatter.string(from: date)
    return dateString
}
