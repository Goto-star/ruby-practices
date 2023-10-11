#!/usr/bin/env ruby
# frozen_string_literal: true

SPLIT_NUMBER = 3

def group_files
  obtained_files = Dir.glob('*')
  max_length = (obtained_files.length.to_f / SPLIT_NUMBER).ceil

  grouped_files = obtained_files.each_slice(max_length).to_a
  blank_numbers = grouped_files[0].length - grouped_files[-1].length
  grouped_files[-1] += Array.new(blank_numbers, nil)
  grouped_files
end

def transpose_columns_and_rows(classified_files)
  vertical_files = classified_files.transpose
  max_name_length = Dir.glob('*').map(&:size).max

  vertical_files.each do |files|
    files.each do |file|
      printf("%-#{max_name_length}s\s", file)
    end
    print("\n")
  end
end

transpose_columns_and_rows(group_files)
