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

def stdout_calender(params)
  header = "#{params[:month]}月 #{params[:year]}"
  puts header
  # Todo:show calendr 

end

stdout_calender(params)
