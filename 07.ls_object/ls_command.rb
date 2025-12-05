#!/usr/bin/env ruby

# frozen_string_literal: true

require 'optparse'
require 'etc'
require_relative 'file_info'
require_relative 'long_list'
require_relative 'short_list'

class LsCommand
  def initialize
    @params = parse_params
    @file_names = fetch_file_names(@params)
    @file_infos = @params[:l] ? @file_names.map { |name| FileInfo.new(name) } : nil
  end

  def run
    list = @params[:l] ? LongList.new(@file_infos) : ShortList.new(@file_names)
    puts list
  end

  private

  def parse_params
    params = {}

    OptionParser.new do |opt|
      opt.on('-a') { params[:a] = true }
      opt.on('-r') { params[:r] = true }
      opt.on('-l') { params[:l] = true }

      opt.parse(ARGV)
    end

    params
  end

  def fetch_file_names(params)
    pattern = '*'
    flags = params[:a] ? File::FNM_DOTMATCH : 0

    file_names = Dir.glob(pattern, flags).sort

    params[:r] ? file_names.reverse : file_names
  end
end

LsCommand.new.run if $PROGRAM_NAME == __FILE__
