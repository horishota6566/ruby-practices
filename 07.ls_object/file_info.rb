# frozen_string_literal: true

class FileInfo
  attr_reader :blocks, :type, :permissions, :links, :owner, :group, :size, :updated, :name

  def initialize(file_name)
    file_stat = File.lstat(file_name)
    mode = file_stat.mode
    user_entry = Etc.getpwuid(file_stat.uid)
    group_entry = Etc.getgrgid(file_stat.gid)

    @blocks = file_stat.blocks
    @type = convert_mode_to_type(mode)
    @permissions = convert_mode_to_rwx(mode)
    @links = file_stat.nlink
    @owner = user_entry.name
    @group = group_entry.name
    @size = file_stat.size
    @updated = file_stat.mtime.strftime('%b %_d %R')
    @name = File.symlink?(file_name) ? "#{file_name} -> #{File.readlink(file_name)}" : file_name
  end

  def to_h
    {
      type: type,
      permissions: permissions,
      links: links,
      owner: owner,
      group: group,
      size: size,
      updated: updated,
      name: name
    }
  end

  private

  def convert_mode_to_type(mode)
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
end
