#!/usr/bin/env ruby
# frozen_string_literal: true

require 'etc'

require 'optparse'

SPLIT_NUMBER = 3

def main
  options = ARGV.getopts('l')
  files = Dir.glob('*')
  options['l'] ? display_long_format(files) : display_files(files)
end

def display_long_format(files)
  long_formats = fetch_long_format(files)
  total_block_number = calc_total_block_number(long_formats)
  max_width = calc_max_width(long_formats)

  puts "total #{total_block_number}"
  long_formats.each do |format|
    print "#{format[:file_mode]}  "
    print "#{format[:hard_links_count].to_s.rjust(max_width[:link])} "
    print "#{format[:owner].rjust(max_width[:owner])}  "
    print "#{format[:group].rjust(max_width[:group])}  "
    print "#{format[:file_size].to_s.rjust(max_width[:file_size])} "
    print "#{format[:day_time]} "
    print "#{format[:file_name]}\n"
  end
end

def fetch_long_format(files)
  long_formats = []

  files.each do |file|
    file_info = File.stat(file)
    long_format = {
      block: file_info.blocks,
      file_mode: fetch_file_mode(file_info),
      hard_links_count: file_info.nlink,
      owner: Etc.getpwuid(file_info.uid).name,
      group: Etc.getgrgid(file_info.gid).name,
      file_size: file_info.size,
      day_time: fetch_last_modified_day(file_info),
      file_name: File.basename(file)
    }
    long_formats << long_format
  end
  long_formats
end

def calc_total_block_number(long_formats)
  blocks = []

  long_formats.each do |long_format|
    file_block = long_format[:block]
    blocks << file_block
  end
  blocks.sum
end

def calc_max_width(long_formats)
  {
    link: long_formats.map { |long_format| long_format[:hard_links_count].to_s.size }.max,
    owner: long_formats.map { |long_format| long_format[:owner].size }.max,
    group: long_formats.map { |long_format| long_format[:group].size }.max,
    file_size: long_formats.map { |long_format| long_format[:file_size].to_s.size }.max
  }
end

def fetch_file_mode(file_info)
  file_mode_of_numeric = file_info.mode.to_s(8)
  file_mode_symbolic = convert_file_mode(file_mode_of_numeric.slice(3, 3))
  file_type_of_symboric = convert_file_type(file_mode_of_numeric.slice(0, 2))
  "#{file_type_of_symboric}#{file_mode_symbolic}"
end

def convert_file_type(file_type_number)
  {
    '01' => 'p',
    '02' => 'c',
    '04' => 'd',
    '06' => 'b',
    '10' => '-',
    '12' => 'l',
    '14' => 's'
  }[file_type_number]
end

def convert_file_mode(file_mode_numbers)
  file_mode_symbolic = []
  file_mode_numbers.chars.each do |number|
    file_mode = {
      '0' => '---',
      '1' => '--x',
      '3' => '-w-',
      '4' => 'r--',
      '5' => 'r-x',
      '6' => 'rw-',
      '7' => 'rwx'
    }[number]
    file_mode_symbolic << file_mode
  end
  file_mode_symbolic.join
end

def fetch_last_modified_day(file_info)
  last_modified_day = file_info.mtime
  last_modified_day.strftime('%_m %_d %H:%M')
end

def display_files(files)
  max_row_number = (files.length.to_f / SPLIT_NUMBER).ceil
  grouped_files = files.each_slice(max_row_number).to_a
  blank_numbers = grouped_files[0].length - grouped_files[-1].length
  grouped_files[-1] += Array.new(blank_numbers, nil)

  file_table = grouped_files.transpose
  max_name_length = files.map(&:size).max
  file_table.each do |row_files|
    row_files.each do |file|
      print file.to_s.ljust(max_name_length + 1)
    end
    print("\n")
  end
end

main
