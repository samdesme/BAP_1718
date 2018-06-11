//
//  OptionsProvider.swift
//  journey
//
//  Created by sam de smedt on 05/06/2018.
//  Copyright © 2018 sam de smedt. All rights reserved.
//

import UIKit
import Highcharts

class OptionsProvider {
    
    class func provideOptions(forChartType options: String, series: [Any], xValues: [String]) -> HIOptions {
        var categories = [String]()
        var step: NSNumber?
        var values = [Any]()
    
            categories = xValues
            step = 1
        values = series
    
        if(series.count == 0){
            values.append(0)
            categories.append("No data yet")
        }
        
        print("options: \(String(describing: options))")
        

        
        
        if options == "column" {
            let hioptions = HIOptions()
            
            let chart = HIChart()
            chart.backgroundColor = HIColor(linearGradient: ["x1": 0, "y1": 0, "x2": 0, "y2": 1], stops: [[0, "rgba(255, 255, 255, 0)"], [1, "rgba(202, 159, 201, 0)"]])
            chart.borderRadius = 6
            chart.type = options
            hioptions.chart = chart
            
            let exporting = HIExporting()
            exporting.enabled = true
            hioptions.exporting = exporting
            
            let navigation = HINavigation()
            navigation.buttonOptions = HIButtonOptions()
            navigation.buttonOptions.symbolStroke = HIColor(rgba: 255, green: 255, blue: 255, alpha: 0.4)
            navigation.buttonOptions.theme = HITheme()
            navigation.buttonOptions.theme.fill = "rgba(0,0,0,0.0)"
            hioptions.navigation = navigation
            
            let plotOptions = HIPlotOptions()
            plotOptions.column = HIColumn()
            plotOptions.column.color = HIColor(rgba: 202, green: 159, blue: 201, alpha: 1)
            plotOptions.column.borderRadius = 2
            plotOptions.column.borderWidth = 0
            hioptions.plotOptions = plotOptions
            
            let credits = HICredits()
            credits.enabled = false
            hioptions.credits = credits
            
            let title = HITitle()
            title.text = ""
            title.align = "left"
            title.style = HIStyle()
            title.style.fontFamily = "Arial"
            title.style.fontSize = "14px"
            title.style.color = "rgba(202, 159, 201, 0.6)"
            title.y = 16
            hioptions.title = title
            
            let tooltip = HITooltip()
            tooltip.headerFormat = ""
            hioptions.tooltip = tooltip
            
            let xaxis = HIXAxis()
            xaxis.tickColor = HIColor(rgba: 255, green: 255, blue: 255, alpha: 0.0)
            xaxis.lineColor = HIColor(rgba: 202, green: 159, blue: 201, alpha: 1)
            xaxis.labels = HILabels()
            xaxis.labels.style = HIStyle()
            xaxis.labels.style.color = "rgba(202, 159, 201, 0)"
            xaxis.labels.style.textOutline = "10px Arial"
            xaxis.labels.step = step
            xaxis.categories = categories
            hioptions.xAxis = [xaxis]
            
            let yaxis = HIYAxis()
            yaxis.lineWidth = 1
            yaxis.gridLineWidth = 0
            yaxis.allowDecimals = false
            yaxis.lineColor = HIColor(rgba: 202, green: 159, blue: 201, alpha: 1)
            yaxis.labels = HILabels()
            yaxis.labels.style = HIStyle()
            yaxis.labels.style.color = "rgb(202, 159, 201)"
            yaxis.labels.style.textOutline = "10px Arial"
            yaxis.labels.x = -5
            yaxis.title = HITitle()
            yaxis.title.text = ""
            yaxis.visible = true
            hioptions.yAxis = [yaxis]
            
            let column = HIColumn()
            column.tooltip = HITooltip()
            column.tooltip.headerFormat = ""
            column.tooltip.valueSuffix = ""
            column.showInLegend = false
            column.data = series
            column.name = "Amount"
            hioptions.series = [column]
            
            return hioptions
        }
        
        if options == "spline" {
            let hioptions = HIOptions()
            
            let chart = HIChart()
            chart.backgroundColor = HIColor(linearGradient: ["x1": 0, "y1": 0, "x2": 0, "y2": 1], stops: [[0, "rgba(132, 103, 144, 0)"], [1, "rgba(163, 95, 103, 0)"]])
            chart.borderRadius = 6
            chart.type = options
            hioptions.chart = chart
            
            let navigation = HINavigation()
            navigation.buttonOptions = HIButtonOptions()
            navigation.buttonOptions.symbolStroke = HIColor(rgba: 255, green: 255, blue: 255, alpha: 0.4)
            navigation.buttonOptions.theme = HITheme()
            navigation.buttonOptions.theme.fill = "rgba(0,0,0,0.0)"
            hioptions.navigation = navigation
            
            let plotOptions = HIPlotOptions()
            plotOptions.spline = HISpline()
            plotOptions.spline.color = HIColor(rgba: 255, green: 255, blue: 255, alpha: 1)
            hioptions.plotOptions = plotOptions
            
            
            let credits = HICredits()
            credits.enabled = false
            hioptions.credits = credits
            
            let title = HITitle()
            title.text = ""
            title.align = "center"
            title.style = HIStyle()
            title.style.fontFamily = "Arial"
            title.style.fontSize = "14px"
            title.style.color = "rgba(255, 255, 255, 1)"
            title.y = 16
            hioptions.title = title
            
            let tooltip = HITooltip()
            tooltip.headerFormat = ""
            hioptions.tooltip = tooltip
            
            let xaxis = HIXAxis()
            xaxis.tickColor = HIColor(rgba: 255, green: 255, blue: 255, alpha: 0.0)
            xaxis.lineColor = HIColor(rgba: 255, green: 255, blue: 255, alpha: 1)
            xaxis.labels = HILabels()
            xaxis.labels.style = HIStyle()
            xaxis.labels.style.color = "rgb(255, 255, 255)"
            xaxis.labels.style.textOutline = "10px Arial"
            xaxis.labels.step = step
            xaxis.categories = categories
            hioptions.xAxis = [xaxis]
            
            let yaxis = HIYAxis()
            yaxis.min = 1
            yaxis.max = 5
            yaxis.lineWidth = 1
            yaxis.allowDecimals = false
            yaxis.gridLineWidth = 0
            yaxis.lineColor = HIColor(rgba: 255, green: 255, blue: 255, alpha: 1)
            yaxis.labels = HILabels()
            yaxis.labels = HILabels()
            yaxis.labels.style = HIStyle()
            yaxis.labels.style.color = "rgba(255, 255, 255, 0.5)"
            yaxis.labels.style.textOutline = "10px Arial"
            yaxis.labels.x = -5
            yaxis.title = HITitle()
            yaxis.title.text = ""
            hioptions.yAxis = [yaxis]
            
            let spline = HISpline()
            spline.tooltip = HITooltip()
            spline.tooltip.headerFormat = ""
            spline.tooltip.valueSuffix = ""
            spline.showInLegend = false
            spline.data = values
            spline.name = "Mood"
            hioptions.series = [spline]
            
            
            return hioptions
        }
        
        return HIOptions()
    }
}

