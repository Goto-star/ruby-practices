# frozen_string_literal: true

require_relative 'simple_file'
require_relative 'detailed_file'

class LsCommand
  def initialize(options)
    @options = options
  end

  def output
    files = @options['a'] ? Dir.glob('*', File::FNM_DOTMATCH) : Dir.glob('*')
    sorted_files = @options['r'] ? files.reverse : files
    @options['l'] ? DetailedFile.new(sorted_files).display : SimpleFile.new(sorted_files).display
  end
end
