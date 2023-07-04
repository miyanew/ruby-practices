#!/usr/bin/env ruby
# frozen_string_literal: false

require 'optparse'
require 'date'

opt = OptionParser.new

params = {}
opt.on('-m [value]', 'this parameter is month') { |v| params[:month] = v.to_i }
opt.on('-y [value]', 'this parameter is year') { |v| params[:year] = v.to_i }
opt.parse!(ARGV)

def stdout_alert
  puts 'Usage: cal [-m month] [-y year]'
  exit
end

# -y オプションの単独使用を許容しない
stdout_alert if params[:month].nil? && !params[:year].nil?

# コマンド引数が未入力のときはシステム日付をセットする
params[:month] ||= Date.today.month
params[:year] ||= Date.today.year

# コマンド引数で指定した対象月のカレンダーを表示させる関数
#  Macローカル環境の/usr/bin/calの出力形式を模して表示する
#  表示列は日曜日から始まり土曜日で終わる。行範囲は6行を確保する。対象月以外の日付は空白にする
#  今日の日付の部分の色を反転させて表示する
WIDTH_MONTH_DISPLAY = 20
NUM_OF_DISPLAYROWS = 6
NUM_OF_DISPLAYCOLS = Date::DAYNAMES.length
WIDTH_DATE_DISPLAY = 2

def stdout_calender(params)
  month_target = params[:month]
  year_target = params[:year]
  space = ' '

  lbl_month_year = "#{month_target}月 #{year_target}".center(WIDTH_MONTH_DISPLAY, space)
  puts lbl_month_year

  lbl_weekdays = %w[日 月 火 水 木 金 土].join(space)
  puts lbl_weekdays

  day_from = Date.new(year_target, month_target, 1)
  day_from = day_from.prev_day(1) until day_from.sunday?
  day_to = day_from + (NUM_OF_DISPLAYCOLS * NUM_OF_DISPLAYROWS - 1)

  (day_from..day_to).each do |day|
    if day.month == month_target
      if day == Date.today
        printf("\e[7m%s\e[0m", format_by_date(day.day.to_s))
      else
        print(format_by_date(day.day.to_s))
      end
    else
      print(format_by_date(space))
    end
    print(space)
    print("\n") if day.saturday?
  end
end

def format_by_date(date_text)
  space = ' '
  date_text.rjust(WIDTH_DATE_DISPLAY, space)
end

stdout_calender(params)
