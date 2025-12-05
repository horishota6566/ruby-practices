# frozen_string_literal: true

class ShortList
  COLUMN_COUNT = 3
  COLUMN_WIDTH_UNIT = 8

  def initialize(file_names)
    @lines = build_lines(file_names)
  end

  def to_s
    @lines.join("\n")
  end

  private

  def build_rows(file_names)
    column_size = (file_names.size + (COLUMN_COUNT - 1)) / COLUMN_COUNT
    columns = file_names.each_slice(column_size).map { |column| column + [nil] * (column_size - column.size) }
    columns.transpose
  end

  def format_row(row, column_width)
    cells = row.compact
    *heads, last = cells

    heads.map { |cell| cell.ljust(column_width) }
         .push(last)
         .join
  end

  def build_lines(file_names)
    rows = build_rows(file_names)
    max_file_name_length = file_names.map(&:length).max
    column_width = ((max_file_name_length + COLUMN_WIDTH_UNIT - 1) / COLUMN_WIDTH_UNIT) * COLUMN_WIDTH_UNIT

    rows.map { |row| format_row(row, column_width) }
  end
end
