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

if params[:month].nil? && !params[:year].nil?
  stdout_alert
end

params[:month] ||= Date.today.month.to_s
params[:year] ||= Date.today.year.to_s


=begin
まずさきに↓をやる。並行タスクになってきた
- 年月ラベル \n 曜日ラベル \n 日付n週目 を表示する（≒カレンダーを表示する）
- 見た目をそろえる
-  年月ラベルを中央寄せする
***todo ******
- 1桁日付と2桁日付のY軸をそろえる
- 曜日ラベルと1桁日付のY軸をそろえる
- 1日が日曜以外の時は、前方に空白をいれる。
  - 日付の出力エリアは6列を確保する。

=end
def stdout_calender(params)
  lbl_month_year = "#{params[:month]}月 #{params[:year]}".center(20," ")

  # Todo:show calendr 
  lbl_weekdays = ["日","月","火","水","木","金","土"].join(" ")

  #days_of_current_month = (Date.new(params[:year].to_i,params[:month].to_i,1)..Date.new(params[:year].to_i,params[:month].to_i,-1)).map {|ymd| p ymd.day}
  stdout_days = []
  (Date.new(params[:year].to_i,params[:month].to_i,1)..Date.new(params[:year].to_i,params[:month].to_i,-1)).each do |ymd|
    stdout_day = ymd.day.to_s
    if ymd.saturday?
      stdout_day = stdout_day + "\n"
    end
    stdout_days.push(stdout_day)
  end

  puts lbl_month_year
  puts lbl_weekdays
  puts stdout_days.join(" ")
end

stdout_calender(params)
