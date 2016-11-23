//
//  eCalendar.swift
//  Calendar
//
//  Created by Vladimir Saprykin on 19.11.16.
//  Copyright © 2016 Vladimir Saprykin. All rights reserved.
//

import UIKit

@IBDesignable class eCalendar : UIView {
    
    //MARK: - View
    var width : CGFloat = 0
    var heigth : CGFloat = 0
    
    //MARK: - Calendar's structure variables
    var daysOfWeek : [String] = []
    
    ///Contain components of each day
    var month : [DateComponents] = []
    ///Contains labels with day's appropriate text
    var dayLabels : [UILabel] = []
    
    var IndexOfSelected : Int = 0 //TODO: Valutare se creare una struttura := {UILabel, DateComponents}
    var labelSelected : UILabel = UILabel()
    
    ///Counter of distance from this month and month to view
    var offset : Int = 0
    
    ///Today date
    let today = (Calendar.current.dateComponents([.day, .month, .year], from: Date() as Date))
    
    var yearSelected = (Calendar.current.dateComponents([.year], from: Date())).year!
    var monthSelected : Int = 0
    
    ///Use it for associate events to date changes
    dynamic var dateSelected = Date()
    
    //MARK: Customization
    @IBInspectable var fillColor : UIColor = UIColor.clear
    @IBInspectable var borderColor : UIColor = UIColor.black
    @IBInspectable var dayTextColor : UIColor = UIColor.black
    
    @IBInspectable var selectedFillCollor : UIColor = UIColor.green
    @IBInspectable var selectedBorderColor : UIColor = UIColor.black
    @IBInspectable var selectedDayTextColor : UIColor = UIColor.blue
    
    @IBInspectable var backColor: UIColor = UIColor.lightGray
    
    override func draw(_ rect: CGRect) {
        
        //Calculate dimension of each label
        width = self.frame.width/7
        heigth = self.frame.height/7
        daysOfWeek = initDayNames()
        labelize()
    }
    
    ///Create, store and add to view all eCalendar labels
    private func labelize(){
        
        monthSelected = today.month! + self.offset
        if monthSelected == 0{
            monthSelected = 12
            self.offset = 12 - today.month!
            yearSelected = yearSelected - 1
        } else if monthSelected == 13{
            monthSelected = 1
            self.offset = -(today.month!-1)
            yearSelected = yearSelected + 1
        } else{
            monthSelected = today.month! + self.offset
        }
        
        for view in self.subviews{
            view.removeFromSuperview()
        }
        dayLabels = []
        
        self.month = getCalendar()
        
        let toMargin : CGFloat = (width - heigth)/2
        
        for x in 0...6{
            let viewRect = CGRect(x: CGFloat(toMargin + CGFloat(x) * width), y: 0, width: heigth, height: heigth)
            let label = UILabel(frame: viewRect)
            label.textAlignment = NSTextAlignment.center
            label.font = UIFont(name: label.font.fontName, size: heigth/3)
            label.text = daysOfWeek[x]
            self.addSubview(label)
        }
        for y in 0...5{
            for x in 0...6{
                let index = (y*7) + x
                let viewRect = CGRect(x: CGFloat(toMargin + CGFloat(x) * width), y: CGFloat(CGFloat(y+1)*heigth) ,width: heigth, height: heigth)
                let label = UILabel(frame: viewRect)
                
                label.textAlignment = .center
                label.font = UIFont(name: label.font.fontName, size: heigth / 1.4)
                label.text = String(month[index].day!)
                
                label.layer.masksToBounds = true
                label.layer.cornerRadius = CGFloat(heigth/2)
                
                label.textColor = dayTextColor
                
                dayLabels.append(label)
                if month[index].month != monthSelected{
                    
                    label.textColor = UIColor.lightGray
                }else {
                    label.isUserInteractionEnabled = true
                    
                    label.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(eCalendar.tapOnDay(_:))))
                    if (month[index].day) == today.day && self.offset == 0 && month[index].year == self.today.year{
                        self.IndexOfSelected = index
                        
                        label.backgroundColor = fillColor
                        label.layer.borderColor = dayTextColor.cgColor
                        label.font = UIFont.boldSystemFont(ofSize: label.font.pointSize)
                        label.layer.borderWidth = 0
                        labelSelected = label
                        SelectDay(label: label, date: month[index])
                    }
                }
                self.addSubview(label)
            }
        }
    }
    
    ///Perform customization methods for selection
    private func SelectDay(label : UILabel, date : DateComponents){
        DeselectDay(label: labelSelected)
        label.textColor = selectedDayTextColor
        label.backgroundColor = selectedFillCollor
        label.layer.borderColor = selectedBorderColor.cgColor
        labelSelected = label
        dateSelected = Calendar.current.date(from: date)!
    }
    
    ///Reset selection and default label attributes
    private func DeselectDay(label : UILabel){
        label.textColor = dayTextColor
        label.backgroundColor = self.backColor
    }
    
    ///Calculate calendar
    private func getCalendar() -> [DateComponents]{
        var month : [DateComponents] = []
        
        let calendar = Calendar.current
        var components = Calendar.current.dateComponents([.day, .year, .month], from: Date())
        
        components.month! += offset
        components.year! = yearSelected
        components.day = 1
        
        let firstDateOfMonth: Date = calendar.date(from: components)!
        let firstDateComponents = calendar.dateComponents([.year, .weekOfMonth , .weekday , .day], from: firstDateOfMonth)
        
        let numOfDatesToPrepend = firstDateComponents.weekday! - 1
        
        let startDate: Date = calendar.date(byAdding: .day, value: -numOfDatesToPrepend, to: firstDateOfMonth, wrappingComponents: false)!
        
        for x in 0..<42  {
            let da = calendar.date(byAdding: .day, value: x , to: startDate, wrappingComponents: false)!
            var components = calendar.dateComponents([.year, .month, .day, .weekday], from: da)
            components.year = yearSelected
            
            month.append(components)
        }
        return month
    }
    
    
    func tapOnDay(_ sender:UITapGestureRecognizer){
        let caller = sender.view as? UILabel
        let indexOfCaller = dayLabels.index(of: caller!)
        
        SelectDay(label: caller!, date: month[indexOfCaller!])
    }
    
    ///Load Weekday array for user locale
    private func initDayNames()->[String]{
        let formatter = DateFormatter()
        let DateFormat = DateFormatter.dateFormat(fromTemplate: "EE", options: 0, locale: Locale.autoupdatingCurrent)
        formatter.dateFormat = DateFormat
        
        formatter.locale = Locale.current
        
        return formatter.veryShortWeekdaySymbols
    }
}
