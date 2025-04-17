#!/usr/bin/env ruby
# frozen_string_literal: true

require 'optparse'

def main
  params = parse_arguments

  process_files(params[:options], params[:file_names])
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

def process_files(options, file_names)
  sources = if file_names.empty?
              [{ text: $stdin.read }]
            else
              file_names.map { |name| { text: File.read(name), label: name } }
            end

  counts = sources.map do |source|
    calculate_text_count(source[:text]).merge(label: source[:label])
  end

  if file_names.size >= 2
    total = generate_total_count(counts).merge(label: 'total')
    counts << total
  end

  counts.each do |count|
    filtered = filter_count(options, count).merge(count.slice(:label))
    print_count(filtered)
  end
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
  formatted_counts = keys.map { |key| count[key].to_s.rjust(8) }.join

  line = count[:label] ? "#{formatted_counts} #{count[:label]}" : formatted_counts

  puts line
end

main if $PROGRAM_NAME == __FILE__
