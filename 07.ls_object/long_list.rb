# frozen_string_literal: true

class LongList
  def initialize(file_infos)
    @lines = build_lines(file_infos)
  end

  def to_s
    @lines.join("\n")
  end

  private

  def build_lines(file_infos)
    [
      build_total_line(file_infos),
      *build_detail_lines(file_infos)
    ]
  end

  def build_total_line(file_infos)
    block_total = file_infos.sum(&:blocks)
    "total #{block_total}"
  end

  def build_detail_lines(file_infos)
    keys = %i[links owner group size]
    widths = keys.to_h do |key|
      [key, file_infos.map { |info| info.public_send(key).to_s.length }.max]
    end

    file_infos.map do |info|
      format_string =
        '%<type>s%<permissions>s  ' \
        "%<links>#{widths[:links]}d " \
        "%<owner>#{widths[:owner]}s  " \
        "%<group>#{widths[:group]}s  " \
        "%<size>#{widths[:size]}d " \
        '%<updated>s %<name>s'

      format(format_string, info.to_h)
    end
  end
end
