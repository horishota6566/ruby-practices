#!/usr/bin/env ruby

# frozen_string_literal: true

require 'optparse'
require 'etc'
require_relative 'file_info'
require_relative 'long_list'
require_relative 'short_list'

class LsCommand
  def initialize(args)
    @flags = read_flags(args)
  end

  def run
    list = build_list
    puts list.lines
  end

  private

  def read_flags(args)
    flags = { a: false, r: false, l: false }

    OptionParser.new do |opt|
      opt.on('-a') { |v| flags[:a] = v }
      opt.on('-r') { |v| flags[:r] = v }
      opt.on('-l') { |v| flags[:l] = v }

      opt.parse(args)
    end

    flags
  end

  def fetch_file_names
    pattern = '*'
    flags = @flags[:a] ? File::FNM_DOTMATCH : 0

    file_names = Dir.glob(pattern, flags).sort

    @flags[:r] ? file_names.reverse : file_names
  end

  def build_list
    file_names = fetch_file_names

    if @flags[:l]
      file_infos = file_names.map { |name| FileInfo.new(name) }
      LongList.new(file_infos)
    else
      ShortList.new(file_names)
    end
  end
end

if $PROGRAM_NAME == __FILE__
  ls_command = LsCommand.new(ARGV)
  ls_command.run
end
