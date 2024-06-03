module FileFormat
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

  def symbolize_file_mode(file_stat)
    numerical_file_mode = file_stat.mode.to_s(8).rjust(6, '0')
    symbolic_file_permission = convert_file_permission(numerical_file_mode.slice(3, 3))
    symbolic_file_type = FILE_TYPE[numerical_file_mode.slice(0, 2)]
    "#{symbolic_file_type}#{symbolic_file_permission}"
  end

  private

  def convert_file_permission(file_mode_numbers)
    file_mode_numbers.gsub(/./, FILE_PERMISSION)
  end
end
