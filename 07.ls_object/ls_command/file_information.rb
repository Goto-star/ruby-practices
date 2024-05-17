# frozen_string_literal: true

require 'etc'

class FileInformation
  def initialize(file)
    @file = file
    @file_stat = File.stat(file)
  end

  def block
    @file_stat.blocks
  end

  def file_mode
    @file_stat.mode
  end

  def hard_links_count
    @file_stat.nlink
  end

  def owner
    Etc.getpwuid(@file_stat.uid).name
  end

  def group
    Etc.getgrgid(@file_stat.gid).name
  end

  def file_size
    @file_stat.size
  end

  def day_time
    @file_stat.mtime.strftime('%_m %_d %H:%M')
  end

  def file_name
    File.basename(@file)
  end
end