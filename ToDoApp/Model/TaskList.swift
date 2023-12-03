import Foundation
import SwiftUI

struct TaskList {
    var categoryName:String!
    var noOfTasks:Int!
    var categoryImage:Image!
    var categoryId:Int!
    var isShow:Bool = false
    var taskList:[Task] = []
}
