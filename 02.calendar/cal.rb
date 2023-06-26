#!/usr/bin/env ruby
# frozen_string_literal: false

require 'optparse'
require 'date'

opt = OptionParser.new

params = {}
opt.on('-m [value]','this parameter is month') {|v| params[:month] = v } 
opt.on('-y [value]','this parameter is year') {|v| params[:year] = v }
opt.parse!(ARGV)

def stdout_alert
  puts 'Alert'
  exit
end

# -y オプション単独使用は許容しない
if params[:month].nil? && !params[:year].nil?
  stdout_alert
end

params[:month] ||= Date.today.month.to_s
params[:year] ||= Date.today.year.to_s

def stdout_calender(params)
  lbl_month_year = "#{params[:month]}月 #{params[:year]}".center(20," ")

  lbl_weekdays = ["日","月","火","水","木","金","土"].join(" ")

  num_of_displayrow = 6
  num_of_displaycol = Date::DAYNAMES.size
  num_of_leading_blank = Date.new(params[:year].to_i,params[:month].to_i,1).wday
  num_of_trailing_blank = num_of_displaycol * num_of_displayrow - Date.new(params[:year].to_i, params[:month].to_i, -1).day - num_of_leading_blank
  
  day_of_month = (Date.new(params[:year].to_i,params[:month].to_i,1)..Date.new(params[:year].to_i,params[:month].to_i,-1)).to_a
  day_of_month = day_of_month.map { |ymd| ymd.day.to_s.rjust(2," ") }
  day_of_month = Array.new(num_of_leading_blank," ".rjust(2," ")) + day_of_month 
  day_of_month = day_of_month + (Array.new(num_of_trailing_blank," ".rjust(2," ")))

  puts lbl_month_year
  puts lbl_weekdays
  num_of_displayrow.times { |num_row| puts day_of_month[num_row * num_of_displaycol,num_of_displaycol].join(" ")}
 end

stdout_calender(params)
