//
//  PendingRequestsTableViewCell.swift
//  test
//
//  Created by Daniel Klinkert Houfer on 8/24/17.
//  Copyright © 2017 Daniel Klinkert Houfer. All rights reserved.
//

import UIKit
import DateTools

class PendingRequestsTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var status: UIView!
    @IBOutlet weak var requester: UILabel!
    @IBOutlet weak var numberOfDayRequested: UILabel!
    @IBOutlet weak var startDate: UILabel!
    @IBOutlet weak var endDate: UILabel!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    func setupCell(request:Request) {
        
        requester.text              = request.employeeName
        numberOfDayRequested.text   = calculateNumberoFDays(startDate: request.beginDate, endDate: request.endDate)
        startDate.text              = (request.beginDate as NSDate).formattedDate(withFormat: "dd/MM/yyyy")
        endDate.text                = (request.endDate as NSDate).formattedDate(withFormat: "dd/MM/yyyy")
        status.backgroundColor      = request.approved ? UIColor.green:UIColor.red
        
    }
    
    private func calculateNumberoFDays(startDate:Date,endDate:Date) -> String {
        
        let calendar = NSCalendar.current
        
        // Replace the hour (time) of both dates with 00:00
        let date1 = calendar.startOfDay(for: startDate)
        let date2 = calendar.startOfDay(for: endDate)
        
        let components = calendar.dateComponents([.day], from: date1, to: date2)
        
        if let day  = components.day {
             return "\(day)"
        }
       
        
        return ""
        
    }
    
}
