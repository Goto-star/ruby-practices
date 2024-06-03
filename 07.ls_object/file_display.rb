require 'etc'
require_relative 'file_format'

class FileDisplay
  SPLIT_NUMBER = 3

  include FileFormat

  def initialize(l_option, files)
    @l_option = l_option
    @files = files
  end

  def display
    if @l_option
      display_detailed_files(@files)
    else
      display_files(@files)
    end
  end

  private

  def display_detailed_files(files)
    detailed_files = build_detailed_files(files)
    block_total = calc_block_total(detailed_files)
    puts "total #{block_total}"
    max_width = calc_max_width(detailed_files)

    detailed_files.each do |detailed_file|
      print "#{symbolize_file_mode(detailed_file[:file_stat])} "
      print "#{detailed_file[:hard_links_count].to_s.rjust(max_width[:link])} "
      print "#{detailed_file[:owner].ljust(max_width[:owner])} "
      print "#{detailed_file[:group].ljust(max_width[:group])} "
      print "#{detailed_file[:file_size].to_s.rjust(max_width[:file_size])} "
      print "#{detailed_file[:day_time]} "
      print "#{detailed_file[:file_name]}\n"
    end
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

  def build_detailed_files(files)
    files.map do |file|
      file_stat = File.stat(file)
      {
        file_stat: file_stat,
        block: file_stat.blocks,
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
end
