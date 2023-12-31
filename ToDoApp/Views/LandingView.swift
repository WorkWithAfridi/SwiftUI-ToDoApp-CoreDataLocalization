import SwiftUI

struct LandingView: View {
    init() {
        UINavigationBar.appearance().barTintColor = .clear
        UINavigationBar.appearance().setBackgroundImage(UIImage(), for: .default)
        UINavigationBar.appearance().shadowImage = UIImage()
    }
    
    @StateObject var viewModel: LandingViewModel = LandingViewModel()
    @State var isPresentCreateTask:Bool = false
    @State var isLangEng: Bool = false
    @State private var showToast = false
    
    var body: some View {
        
        NavigationView{
            ZStack {
                if viewModel.taskList.count == 0{
                    Color.white.edgesIgnoringSafeArea(.all)
                }
                else{
                    Color.black.opacity(0.05).edgesIgnoringSafeArea(.all)
                }
                if viewModel.taskList.count == 0{
                }
                ScrollView{
                    VStack{
                        //Collection View
                        LazyVGrid(columns: [GridItem(.adaptive(minimum: 150, maximum: 200), spacing: 20)], content: {
                            ForEach(viewModel.taskList, id: \.categoryId){ task in
                                NavigationLink(
                                    destination: TaskDetailView(viewModel: viewModel, taskDetails: task)) {
                                        if task.isShow{
                                            TaskCellView(taskImg: task.categoryImage, categoryName: task.categoryName, noOftask: task.noOfTasks)
                                        }
                                    }
                            }
                        }
                        )
                        Spacer()
                    }
                    .padding()
                }
                VStack{
                    Spacer()
                    HStack{
                        if   LanguageManager.shared.currentLanguage == "de" {
                            Button("Change Language: EN") {
                                LanguageManager.shared.currentLanguage = "en"
                                showToast = true
                            }
                        } else {
                            Button("Change Language: DE") {
                                LanguageManager.shared.currentLanguage = "de"
                                showToast = true
                            }
                        }
                        Spacer()
                        Button(action: {
                            isPresentCreateTask = true
                        }){
                            Image(systemName: "plus.circle.fill")
                                .resizable()
                                .frame(width: 50, height: 50)
                        }
                    }
                    .padding()
                }
                if viewModel.taskList.count == 0{
                    TaskEmptySateView()
                }
            }
            .toast(isPresented: $showToast, message:
                    "Language changed. Please restart the app.")
        }
        .fullScreenCover(isPresented: $isPresentCreateTask, content: {
            withAnimation {
                NewTaskView(viewModel: viewModel, isPresentCreateTask: $isPresentCreateTask)
            }
        })
        .onAppear{
            viewModel.taskList = viewModel.getAllTaskList()
        }
        
    }
    
}

struct LandingView_Previews: PreviewProvider {
    static var previews: some View {
        LandingView()
    }
}


struct TaskCellView:View {
    
    @State var taskImg:Image
    @State var categoryName: String
    @State var noOftask: Int
    
    var body: some View{
        HStack{
            VStack(alignment: .leading){
                taskImg
                    .resizable()
                    .frame(width: 30, height: 30)
                Spacer()
                    .frame(height: 20)
                VStack(alignment: .leading){
                    Text(LocalizedStringKey(categoryName))
                        .fontWeight(.medium)
                        .foregroundColor(.black)
                    Text("\(noOftask) Tasks")
                        .foregroundColor(.gray)
                }
            }
            Spacer()
        }
        .frame(width: 140, height: 140)
        .padding(.horizontal)
        .background(Color.white)
        .cornerRadius(10)
    }
}

struct TaskEmptySateView: View {
    var body: some View{
        VStack{
            Image("task_empty")
                .resizable()
                .frame(width: 200, height: 200, alignment: .center)
            Text("You don't have any Tasks listed")
        }
        .frame(width: UIScreen.main.bounds.width - 20, height: UIScreen.main.bounds.width - 60)
    }
}
