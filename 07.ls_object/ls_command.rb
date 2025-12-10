#!/usr/bin/env ruby

# frozen_string_literal: true

require 'optparse'
require 'etc'
require_relative 'file_info'
require_relative 'long_list'
require_relative 'short_list'

class LsCommand
  def initialize(args)
    @params = parse_params(args)
  end

  def run
    list = build_list
    puts list.lines
  end

  private

  def parse_params(args)
    params = {}

    OptionParser.new do |opt|
      opt.on('-a') { params[:a] = true }
      opt.on('-r') { params[:r] = true }
      opt.on('-l') { params[:l] = true }

      opt.parse(args)
    end

    params
  end

  def fetch_file_names
    pattern = '*'
    flags = @params[:a] ? File::FNM_DOTMATCH : 0

    file_names = Dir.glob(pattern, flags).sort

    @params[:r] ? file_names.reverse : file_names
  end

  def build_list
    file_names = fetch_file_names

    if @params[:l]
      file_infos = file_names.map { |name| FileInfo.new(name) }
      LongList.new(file_infos)
    else
      ShortList.new(file_names)
    end
  end
end

ls_command = LsCommand.new(ARGV)
ls_command.run if $PROGRAM_NAME == __FILE__
