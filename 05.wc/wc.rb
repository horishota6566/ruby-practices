#!/usr/bin/env ruby
# frozen_string_literal: true

require 'optparse'

def main
  params = parse_arguments

  if params[:file_names].empty?
    process_stdin(params[:options])
  else
    process_files(params[:options], params[:file_names])
  end
end

def parse_arguments
  option_parser = OptionParser.new
  options = {}

  option_parser.on('-l', 'Print lines')
  option_parser.on('-w', 'Print words')
  option_parser.on('-c', 'Print bytes')

  option_parser.parse!(ARGV, into: options)

  { options: options, file_names: ARGV }
end

def process_stdin(options)
  text = $stdin.read
  statistic = calculate_text_statistic(text)
  filtered = filter_statistic(options, statistic)
  print_statistic(filtered)
end

def process_files(options, file_names)
  file_contents = file_names.map { |name| File.read(name) }
  statistics = file_names.zip(file_contents).map do |file_name, text|
    calculate_text_statistic(text).merge(label: file_name)
  end
  statistics << generate_total_statistic(statistics).merge(label: 'total') if statistics.size >= 2

  filtered = statistics.map do |statistic|
    filter_statistic(options, statistic).merge(statistic.slice(:label))
  end
  filtered.each { |statistic| print_statistic(statistic) }
end

def calculate_text_statistic(text)
  {
    lines: text.split("\n").size,
    words: text.split("\s").size,
    bytes: text.bytes.size
  }
end

def generate_total_statistic(statistics)
  {
    lines: statistics.sum { |statistic| statistic[:lines] },
    words: statistics.sum { |statistic| statistic[:words] },
    bytes: statistics.sum { |statistic| statistic[:bytes] }
  }
end

def filter_statistic(options, statistic)
  return statistic if options.empty?

  option_to_key = { l: :lines, w: :words, c: :bytes }

  option_to_key.each_with_object({}) do |(option, key), selected|
    selected[key] = statistic[key] if options[option]
  end
end

def print_statistic(statistic)
  keys = %i[lines words bytes].select { |key| statistic.key?(key) }

  format = keys.map { '%8d' }.join
  values = keys.map { |key| statistic[key] }

  if statistic[:label]
    format += ' %s'
    values << statistic[:label]
  end

  puts format(format, *values)
end

main if $PROGRAM_NAME == __FILE__
