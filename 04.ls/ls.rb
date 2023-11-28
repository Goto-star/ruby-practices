#!/usr/bin/env ruby
# frozen_string_literal: true

require 'etc'
require 'optparse'

SPLIT_NUMBER = 3

FILE_TYPE = {
  '01' => 'p',
  '02' => 'c',
  '04' => 'd',
  '06' => 'b',
  '10' => '-',
  '12' => 'l',
  '14' => 's'
}.freeze

FILE_PERMISSION = {
  '0' => '---',
  '1' => '--x',
  '3' => '-w-',
  '4' => 'r--',
  '5' => 'r-x',
  '6' => 'rw-',
  '7' => 'rwx'
}.freeze

def main
  options = ARGV.getopts('arl')
  files = options['a'] ? Dir.glob('*', File::FNM_DOTMATCH) : Dir.glob('*')
  sorted_files = options['r'] ? files.reverse : files
  options['l'] ? display_detailed_files(sorted_files) : display_files(sorted_files)
end

def display_detailed_files(files)
  detailed_files = build_detailed_files(files)
  block_total = calc_block_total(detailed_files)
  puts "total #{block_total}"

  max_width = calc_max_width(detailed_files)
  detailed_files.each do |detailed_file|
    print "#{detailed_file[:file_mode]}  "
    print "#{detailed_file[:hard_links_count].to_s.rjust(max_width[:link])} "
    print "#{detailed_file[:owner].ljust(max_width[:owner])}  "
    print "#{detailed_file[:group].ljust(max_width[:group])}  "
    print "#{detailed_file[:file_size].to_s.rjust(max_width[:file_size])} "
    print "#{detailed_file[:day_time]} "
    print "#{detailed_file[:file_name]}\n"
  end
end

def build_detailed_files(files)
  files.map do |file|
    file_stat = File.stat(file)
    {
      block: file_stat.blocks,
      file_mode: symbolize_file_mode(file_stat),
      hard_links_count: file_stat.nlink,
      owner: Etc.getpwuid(file_stat.uid).name,
      group: Etc.getgrgid(file_stat.gid).name,
      file_size: file_stat.size,
      day_time: file_stat.mtime.strftime('%_m %_d %H:%M'),
      file_name: File.basename(file)
    }
  end
end

def calc_block_total(detailed_files)
  detailed_files.sum { |detailed_file| detailed_file[:block] }
end

def calc_max_width(detailed_files)
  {
    link: detailed_files.map { |detailed_file| detailed_file[:hard_links_count].to_s.size }.max,
    owner: detailed_files.map { |detailed_file| detailed_file[:owner].size }.max,
    group: detailed_files.map { |detailed_file| detailed_file[:group].size }.max,
    file_size: detailed_files.map { |detailed_file| detailed_file[:file_size].to_s.size }.max
  }
end

def symbolize_file_mode(file_stat)
  numerical_file_mode = file_stat.mode.to_s(8).rjust(6, '0')
  symbolic_file_permission = convert_file_permission(numerical_file_mode.slice(3, 3))
  symbolic_file_type = FILE_TYPE[numerical_file_mode.slice(0, 2)]
  "#{symbolic_file_type}#{symbolic_file_permission}"
end

def convert_file_permission(file_mode_numbers)
  file_mode_numbers.gsub(/./, FILE_PERMISSION)
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
