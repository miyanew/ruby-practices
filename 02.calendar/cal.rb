#!/usr/bin/env ruby
# frozen_string_literal: false

require 'optparse'
require 'date'

opt = OptionParser.new

params = {}
opt.on('-m [value]','this parameter is month') {|v| params[:month] = v } 
opt.on('-y [value]','this parameter is year') {|v| params[:year] = v }
opt.parse!(ARGV)

def stdout_alertg
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
  num_of_leading_blank = Date.new(params[:year].to_i,params[:month].to_i,1).wday
  num_of_trailing_blank = Date::DAYNAMES.size * num_of_displayrow - Date.new(params[:year].to_i, params[:month].to_i, -1).day - num_of_leading_blank
  
  # Todo：1週目だけ日付の横位置がずれる。対象月によっては0週目が出力される（例：202304）
  day_of_month = (Date.new(params[:year].to_i,params[:month].to_i,1)..Date.new(params[:year].to_i,params[:month].to_i,-1)).to_a
  day_of_month = Array.new(num_of_leading_blank," ") + day_of_month.map do |ymd|
    if ymd.is_a?(Date)
      ymd.day.to_s.rjust(2," ")
    else
      ymd.rjust(2," ")
    end
  end
  day_of_month = Array.new(num_of_leading_blank," " * 2) + day_of_month 
  day_of_month = day_of_month + (Array.new(num_of_trailing_blank," "))

  puts lbl_month_year
  puts lbl_weekdays
  (0..(num_of_displayrow - 1)).each { |num_row| puts day_of_month[num_row * 7,7].join(" ") }
end

stdout_calender(params)
