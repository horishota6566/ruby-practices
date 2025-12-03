# frozen_string_literal: true

# !/usr/bin/env ruby

require 'date'

def generate_calendar(year: Date.today.year, month: Date.today.month)
  [
    "      #{month}月 #{year}",
    '日 月 火 水 木 金 土',
    *body(year, month)
  ].join("\n")
end

def body(year, month)
  first_date = Date.new(year, month, 1)
  last_date = Date.new(year, month, -1)

  blanks = Array.new(first_date.wday)

  full_days = [*blanks, *(1..last_date.day)]

  format = ->(n) { n.to_s.rjust(2) }

  full_days.each_slice(7).map do |days|
    days.map(&format).join(' ')
  end
end

if $PROGRAM_NAME == __FILE__
  require 'optparse'
  opt = OptionParser.new

  options = {}

  opt.on('-m VAL') { |v| options[:month] = v.to_i }
  opt.on('-y VAL') { |v| options[:year] = v.to_i }

  opt.parse!(ARGV)
  calendar = generate_calendar(**options)
  puts calendar
end
