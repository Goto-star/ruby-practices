#!/usr/bin/env ruby
# frozen_string_literal: true

require 'optparse'

SPLIT_NUMBER = 3

def main
  options = ARGV.getopts('a')
  files = get_files(options['a'])
  display_files(files)
end

def get_files(params)
  if params
    Dir.glob('*', File::FNM_DOTMATCH)
  else
    Dir.glob('*')
  end
end

def display_files(files)
  max_row_number = (files.length.to_f / SPLIT_NUMBER).ceil
  grouped_files = files.each_slice(max_row_number).to_a
  blank_numbers = grouped_files[0].length - grouped_files[-1].length
  grouped_files[-1] += Array.new(blank_numbers, nil)

  vertical_files = grouped_files.transpose
  max_name_length = files.map(&:size).max
  vertical_files.each do |files|
    files.each do |file|
      print file.to_s.ljust(max_name_length + 1)
    end
    print("\n")
  end
end

main
