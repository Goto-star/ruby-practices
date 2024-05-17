# frozen_string_literal: true

require_relative 'file_information'

class DetailedFile
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

  def initialize(files)
    @files = files
  end

  def display
    detailed_files = build_detailed_files(@files)
    block_total = calc_block_total(detailed_files)
    puts "total #{block_total}"

    max_width = calc_max_width(detailed_files)
    detailed_files.each do |detailed_file|
      print "#{symbolize_file_mode(detailed_file[:file_mode])}  "
      print "#{detailed_file[:hard_links_count].to_s.rjust(max_width[:link])} "
      print "#{detailed_file[:owner].ljust(max_width[:owner])}  "
      print "#{detailed_file[:group].ljust(max_width[:group])}  "
      print "#{detailed_file[:file_size].to_s.rjust(max_width[:file_size])} "
      print "#{detailed_file[:day_time]} "
      print "#{detailed_file[:file_name]}\n"
    end
  end

  private

  def build_detailed_files(files)
    files.map do |file|
      file_info = FileInformation.new(file)
      {
        block: file_info.block,
        file_mode: file_info.file_mode,
        hard_links_count: file_info.hard_links_count,
        owner: file_info.owner,
        group: file_info.group,
        file_size: file_info.file_size,
        day_time: file_info.day_time,
        file_name: file_info.file_name
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
    numerical_file_mode = file_stat.to_s(8).rjust(6, '0')
    symbolic_file_permission = convert_file_permission(numerical_file_mode.slice(3, 3))
    symbolic_file_type = FILE_TYPE[numerical_file_mode.slice(0, 2)]
    "#{symbolic_file_type}#{symbolic_file_permission}"
  end

  def convert_file_permission(file_mode_numbers)
    file_mode_numbers.gsub(/./, FILE_PERMISSION)
  end
end
