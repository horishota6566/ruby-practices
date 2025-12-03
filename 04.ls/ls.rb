#!/usr/bin/env ruby

# frozen_string_literal: true

require 'optparse'
require 'etc'

COLUMN_COUNT = 3
COLUMN_WIDTH_UNIT = 8

def parse_params
  opt = OptionParser.new
  params = {}

  flags = ['-a', 'r', '-l']
  flags.each { |flag| opt.on(flag) }

  opt.parse(ARGV, into: params)

  params
end

def fetch_sorted_files(params)
  pattern = '*'
  flags = params[:a] ? File::FNM_DOTMATCH : 0

  files = Dir.glob(pattern, flags).sort

  params[:r] ? files.reverse : files
end

def build_rows(files)
  column_size = (files.size + (COLUMN_COUNT - 1)) / COLUMN_COUNT
  columns = files.each_slice(column_size).map { |column| column + [''] * (column_size - column.size) }
  columns.transpose
end

def format_rows(rows)
  max_filename_length = rows.flatten.map(&:length).max
  column_width = ((max_filename_length + COLUMN_WIDTH_UNIT - 1) / COLUMN_WIDTH_UNIT) * COLUMN_WIDTH_UNIT
  rows.map do |row|
    row.map { |cell| cell.ljust(column_width) }.join
  end.join("\n")
end

def convert_mode_to_filetype(mode)
  case mode & 0o170000
  when 0o040000 then 'd'
  when 0o100000 then '-'
  when 0o120000 then 'l'
  end
end

def convert_bits_to_rwx(bits)
  [
    (bits & 0b100).zero? ? '-' : 'r',
    (bits & 0b010).zero? ? '-' : 'w',
    (bits & 0b001).zero? ? '-' : 'x'
  ].join
end

def convert_mode_to_rwx(mode)
  bits = mode & 0o777
  [
    convert_bits_to_rwx(bits >> 6 & 0b111),
    convert_bits_to_rwx(bits >> 3 & 0b111),
    convert_bits_to_rwx(bits & 0b111)
  ].join
end

def build_file_infos(file)
  file_stat = File.lstat(file)
  mode = file_stat.mode
  user_entry = Etc.getpwuid(file_stat.uid)
  group_entry = Etc.getgrgid(file_stat.gid)

  {
    blocks: file_stat.blocks,
    type: convert_mode_to_filetype(mode),
    permissions: convert_mode_to_rwx(mode),
    links: file_stat.nlink,
    owner: user_entry.name,
    group: group_entry.name,
    size: file_stat.size,
    updated: file_stat.mtime.strftime('%b %_d %R'),
    name: File.symlink?(file) ? "#{File.basename(file)} -> #{File.readlink(file)}" : File.basename(file)
  }
end

def format_file_infos(file_infos)
  keys = %i[links owner group size]
  widths = keys.to_h do |key|
    [key, file_infos.map { |info| info[key].to_s.length }.max]
  end

  file_infos.map do |info|
    format_string =
      '%<type>s%<permissions>s  ' \
      "%<links>#{widths[:links]}d " \
      "%<owner>#{widths[:owner]}s  " \
      "%<group>#{widths[:group]}s  " \
      "%<size>#{widths[:size]}d " \
      '%<updated>s %<name>s'

    format(format_string, info)
  end
end

def main
  params = parse_params
  files = fetch_sorted_files(params)

  if params[:l]
    file_infos = files.map { |file| build_file_infos(file) }
    formatted = format_file_infos(file_infos)
    total = file_infos.map { |info| info[:blocks] }.sum
    puts "total #{total}\n"
    puts formatted.join("\n")
  else
    rows = build_rows(files)
    formatted = format_rows(rows)
    puts formatted
  end
end

main if $PROGRAM_NAME == __FILE__
