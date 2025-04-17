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
  count = calculate_text_count(text)
  filtered = filter_count(options, count)
  print_count(filtered)
end

def process_files(options, file_names)
  file_contents = file_names.map { |name| File.read(name) }
  counts = file_names.zip(file_contents).map do |file_name, text|
    calculate_text_count(text).merge(label: file_name)
  end
  counts << generate_total_count(counts).merge(label: 'total') if counts.size >= 2

  filtered = counts.map do |count|
    filter_count(options, count).merge(count.slice(:label))
  end
  filtered.each { |count| print_count(count) }
end

def calculate_text_count(text)
  {
    lines: text.split("\n").size,
    words: text.split("\s").size,
    bytes: text.bytes.size
  }
end

def generate_total_count(counts)
  {
    lines: counts.sum { |count| count[:lines] },
    words: counts.sum { |count| count[:words] },
    bytes: counts.sum { |count| count[:bytes] }
  }
end

def filter_count(options, count)
  return count if options.empty?

  option_to_key = { l: :lines, w: :words, c: :bytes }

  option_to_key.each_with_object({}) do |(option, key), selected|
    selected[key] = count[key] if options[option]
  end
end

def print_count(count)
  keys = %i[lines words bytes].select { |key| count.key?(key) }

  format = keys.map { '%8d' }.join
  values = keys.map { |key| count[key] }

  if count[:label]
    format += ' %s'
    values << count[:label]
  end

  puts format(format, *values)
end

main if $PROGRAM_NAME == __FILE__
