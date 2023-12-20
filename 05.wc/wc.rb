# frozen_string_literal: true

require 'optparse'

# メインの処理
def main
  options = ARGV.getopts('lwc')
  specified_files = ARGV
  loaded_files = $stdin.read
  all_option_values = all_falsy?(options)

  display_by_specified_files_and_options(loaded_files, specified_files, options, all_option_values)
end

def display_by_specified_files_and_options(loaded_files, specified_files, options, all_option_values)
  if loaded_files.empty? || (!loaded_files.empty? && !specified_files.empty?)
    display_word_count(specified_files, options, all_option_values)
  else
    display_standard_input(loaded_files, options, all_option_values)
  end
end

def display_standard_input(loaded_files, options, all_option_values)
  stdin_row = build_file_count(loaded_files)

  display_file_count(stdin_row, options, all_option_values)
end

def display_word_count(files, options, all_option_values)
  wc_rows = files.map { |file| build_file_count(File.read(file), file_name: file) }
  wc_rows << calc_total_count(wc_rows) if files.count > 1

  wc_rows.each do |wc_row|
    display_file_count(wc_row, options, all_option_values)
  end
end

def display_file_count(row, options, all_option_values)
  file_counts = []
  file_counts << row[:line_count].to_s.rjust(8) if options['l'] || all_option_values
  file_counts << row[:word_count].to_s.rjust(8) if options['w'] || all_option_values
  file_counts << row[:byte_count].to_s.rjust(8) if options['c'] || all_option_values
  file_counts << " #{row[:name]}" unless row[:name].empty?
  puts file_counts.join
end

def all_falsy?(options)
  options.values.none?
end

def build_file_count(file, file_name: '')
  {
    line_count: file.scan(/\n/).size,
    word_count: file.scan(/\s+/).size,
    byte_count: file.bytesize,
    name: file_name
  }
end

def calc_total_count(files)
  {
    line_count: files.select.sum { |file| file[:line_count] },
    word_count: files.select.sum { |file| file[:word_count] },
    byte_count: files.select.sum { |file| file[:byte_count] },
    name: 'total'
  }
end

main
