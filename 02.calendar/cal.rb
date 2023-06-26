#!/usr/bin/env ruby
# frozen_string_literal: false

require 'optparse'
require 'date'

opt = OptionParser.new

params = {}
opt.on('-m [value]', 'this parameter is month') { |v| params[:month] = v }
opt.on('-y [value]', 'this parameter is year') { |v| params[:year] = v }
opt.parse!(ARGV)

def stdout_alert
  puts 'Usage: cal [-m month] [-y year]'
  exit
end

# -y オプションの単独使用を許容しない
stdout_alert if params[:month].nil? && !params[:year].nil?

# コマンド引数が未入力のときはシステム日付をセットする
params[:month] ||= Date.today.month.to_s
params[:year] ||= Date.today.year.to_s

# コマンド引数で指定した対象月のカレンダーを表示させる関数
#  Macローカル環境の/usr/bin/calの出力形式を模して表示する
#  表示列は日曜日から始まり土曜日で終わる。行範囲は6行を確保する。対象月以外の日付は空白にする
#  今日の日付の部分の色を反転させて表示する
def stdout_calender(params)
  month_target = params[:month]
  year_target = params[:year]
  space = ' '

  width_month_display = 20
  lbl_month_year = "#{month_target}月 #{year_target}".center(width_month_display, space)
  puts lbl_month_year

  lbl_weekdays = %w[日 月 火 水 木 金 土].join(space)
  puts lbl_weekdays

  day_from = Date.new(year_target.to_i, month_target.to_i, 1)
  day_from = day_from.prev_day(1) while day_from.wday != 0
  num_of_displayrows = 6
  day_to = day_from + (Date::DAYNAMES.length * num_of_displayrows - 1)

  width_date_display = 2
  (day_from..day_to).each do |day|
    if day == Date.today
      printf("\e[7m%s\e[0m", day.day.to_s.rjust(width_date_display, space))
      print(space)
    elsif day.month.to_s == month_target
      print(day.day.to_s.rjust(width_date_display, space).concat(space))
    else
      print(space.rjust(width_date_display, space).concat(space))
    end

    print "\n" if day.wday == 6
  end
end

stdout_calender(params)
