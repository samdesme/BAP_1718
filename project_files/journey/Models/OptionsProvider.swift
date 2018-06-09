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
    
    class func provideOptions(forChartType options: String, series: [Any], type: String, xValues: [String]) -> HIOptions {
        var categories = [String]()
        var step: NSNumber?
        
        if type == "day" {
            categories = xValues
            step = 1
        }
        
        if type == "month" {
            categories = xValues
            step = 1
        }
        
        if type == "year" {
            categories = xValues
            step = 1
        }
        
        
        if options == "column" {
            let hioptions = HIOptions()
            
            let chart = HIChart()
            chart.backgroundColor = HIColor(linearGradient: ["x1": 0, "y1": 0, "x2": 0, "y2": 1], stops: [[0, "rgb(66, 218, 113)"], [1, "rgb(80, 140, 200)"]])
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
            plotOptions.column.color = HIColor(rgba: 255, green: 255, blue: 255, alpha: 0.6)
            plotOptions.column.borderRadius = 2
            plotOptions.column.borderWidth = 0
            hioptions.plotOptions = plotOptions
            
            let credits = HICredits()
            credits.enabled = false
            hioptions.credits = credits
            
            let title = HITitle()
            title.text = "Graph Column"
            title.align = "left"
            title.style = HIStyle()
            title.style.fontFamily = "Arial"
            title.style.fontSize = "14px"
            title.style.color = "rgba(255, 255, 255, 0.6)"
            title.y = 16
            hioptions.title = title
            
            let subtitle = HISubtitle()
            subtitle.text = "Subtitle"
            if subtitle.text.characters.count > 0 {
                subtitle.text = subtitle.text + " total"
            }
            subtitle.align = "left"
            subtitle.style = ["fontFamily": "Arial", "fontSize": "10px", "color": "rgba(255, 255, 255, 0.6)"]
            subtitle.y = 28
            hioptions.subtitle = subtitle
            
            let tooltip = HITooltip()
            tooltip.headerFormat = ""
            hioptions.tooltip = tooltip
            
            let xaxis = HIXAxis()
            xaxis.tickColor = HIColor(rgba: 255, green: 255, blue: 255, alpha: 0.0)
            xaxis.lineColor = HIColor(rgba: 255, green: 255, blue: 255, alpha: 0.3)
            xaxis.labels = HILabels()
            xaxis.labels.style = HIStyle()
            xaxis.labels.style.color = "rgb(255, 255, 255)"
            xaxis.labels.style.textOutline = "10px Arial"
            xaxis.labels.step = step
            xaxis.categories = categories
            hioptions.xAxis = [xaxis]
            
            let yaxis = HIYAxis()
            yaxis.lineWidth = 1
            yaxis.gridLineWidth = 0
            yaxis.lineColor = HIColor(rgba: 255, green: 255, blue: 255, alpha: 0.3)
            yaxis.labels = HILabels()
            yaxis.labels.style = HIStyle()
            yaxis.labels.style.color = "rgb(255, 255, 255)"
            yaxis.labels.style.textOutline = "10px Arial"
            yaxis.labels.x = -5
            yaxis.title = HITitle()
            yaxis.title.text = ""
            yaxis.visible = true
            hioptions.yAxis = [yaxis]
            
            let column = HIColumn()
            column.tooltip = HITooltip()
            column.tooltip.headerFormat = ""
            column.tooltip.valueSuffix = " kcal"
            column.showInLegend = false
            column.data = series
            column.name = "Column name"
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
            
            /*
            let exporting = HIExporting()
            exporting.enabled = true
            hioptions.exporting = exporting
            */
            
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
            
            /*
            let subtitle = HISubtitle()
            subtitle.text = "Subtitle"
            if subtitle.text.characters.count > 0 {
                subtitle.text = subtitle.text + " total"
            }
            subtitle.align = "left"
            subtitle.style = ["fontFamily": "Arial", "fontSize": "10px", "color": "rgba(255, 255, 255, 0.6)"]
            subtitle.y = 28
            hioptions.subtitle = subtitle
            */
            
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
            spline.data = series
            spline.name = "Mood"
            hioptions.series = [spline]
            
            
            return hioptions
        }
        
        return HIOptions()
    }
}

