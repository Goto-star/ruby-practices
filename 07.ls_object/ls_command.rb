require 'optparse'
require_relative 'file_display.rb'

class LsCommand
  SPLIT_NUMBER = 3

  def initialize(args)
    @options = ARGV.getopts('arl')
  end

  def run
    files = @options ? Dir.glob('*', File::FNM_DOTMATCH) : Dir.glob('*')
    sorted_files = @options['r'] ? files.reverse : files
    FileDisplay.new(@options['l'], sorted_files).display
  end
end

LsCommand.new(ARGV).run
