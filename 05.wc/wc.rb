# frozen_string_literal: true

require 'debug'
require 'optparse'

# メインの処理
def main
  options = ARGV.getopts('lwc')
  specified_files = ARGV
  loaded_files = $stdin.read
  all_option_values = all_false_values?(options)

  loaded_files.empty? ? display_word_count(specified_files, options, all_option_values) : display_standard_input(loaded_files, options, all_option_values)
end

def display_standard_input(loaded_files, options, all_option_values)
  stdin_row = build_standard_input_attribute(loaded_files)

  print stdin_row[:line_number].to_s.rjust(8) if options['l'] || all_option_values
  print stdin_row[:word_number].to_s.rjust(8) if options['w'] || all_option_values
  print stdin_row[:byte_number].to_s.rjust(8) if options['c'] || all_option_values
  print "\n"
end

def display_word_count(files, options, all_option_values)
  wc_rows = build_word_count_attribute(files)

  wc_rows.each do |wc_row|
    print wc_row[:line_number].to_s.rjust(8) if options['l'] || all_option_values
    print wc_row[:word_number].to_s.rjust(8) if options['w'] || all_option_values
    print wc_row[:byte_number].to_s.rjust(8) if options['c'] || all_option_values
    print " #{wc_row[:name]}\n"
  end
end

def all_false_values?(options)
  options.values.all? { |value| value == false }
end

def build_word_count_attribute(files)
  wc_array = []

  files.each do |file|
    wc_array << {
      line_number: File.read(file).count("\n"),
      word_number: File.read(file).split(/\s+/).size,
      byte_number: File.read(file).bytesize,
      name: File.basename(file)
    }
  end
  wc_array << calc_total_number(wc_array) if files.count > 1

  wc_array
end

def build_standard_input_attribute(loaded_files)
  {
    line_number: loaded_files.scan(/\n/).size,
    word_number: loaded_files.scan(/\s+/).size,
    byte_number: loaded_files.bytesize
  }
end

def calc_total_number(files)
  {
    line_number: files.select.sum { |file| file[:line_number] },
    word_number: files.select.sum { |file| file[:word_number] },
    byte_number: files.select.sum { |file| file[:byte_number] },
    name: 'total'
  }
end

main
