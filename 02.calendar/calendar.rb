#!/usr/bin/env ruby

require 'date'
require 'optparse'

# コマンドライン引数の変数
options = ARGV.getopts('y:', 'm:')
target_year = options['y'].to_i
target_month = options['m'].to_i

# 日付の変数
today = Date.today
year = today.year
month = today.month
one_week = %w(日 月 火 水 木 金 土)
if target_year == 0 && target_month == 0
  first_day = Date.new(year, month, 1)
  last_day = Date.new(year, month, -1)
elsif target_year == 0
  first_day = Date.new(year, target_month, 1)
  last_day = Date.new(year, target_month, -1)
else
  first_day = Date.new(target_year, target_month, 1)
  last_day = Date.new(target_year, target_month, -1)
end

# カレンダー初日の空欄
blank = '   ' * first_day.wday

# 処理
puts first_day.strftime('%m月 %Y').center(20)
puts one_week.join(' ')
print blank
(first_day..last_day).each do |d|
  printf('%2d ', d.day)
  puts "\n" if d.wday == 6
end
