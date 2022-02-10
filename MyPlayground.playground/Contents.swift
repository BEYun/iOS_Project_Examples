import UIKit

let date = Date()
let form =  DateFormatter()
form.timeStyle = .short

let stringDate = form.string(from: date)
