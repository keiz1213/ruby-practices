# frozen_string_literal: true

require 'etc'
require 'date'
require 'pathname'

class Entry
  MODE_TABLE = {
    '0' => '---',
    '1' => '--x',
    '2' => '-w-',
    '3' => '-wx',
    '4' => 'r--',
    '5' => 'r-x',
    '6' => 'rw-',
    '7' => 'rwx'
  }.freeze

  attr_reader :name, :file_type, :permission, :link, :owner, :group, :file_size, :time, :blocks

  def initialize(name)
    stat = File::Stat.new(name)

    @name = Pathname(name).basename.to_s
    @file_type = format_type(stat)
    @permission = format_permission(stat.mode)
    @link = stat.nlink.to_s
    @owner = Etc.getpwuid(stat.uid).name.to_s
    @group = Etc.getgrgid(stat.gid).name.to_s
    @file_size = stat.size.to_s
    @time = format_mtime(stat)
    @blocks = stat.blocks
  end

  def line(link_max, owner_max, group_max, file_size_max)
    [
      file_type.to_s,
      permission.to_s,
      "#{link.rjust(link_max + 2)} ",
      owner.ljust(owner_max + 1).to_s,
      "#{group.rjust(group_max + 1)} ",
      file_size.rjust(file_size_max + 1).to_s,
      "#{time} ",
      name.to_s
    ].join
  end

  private

  def format_type(stat)
    stat.ftype == 'file' ? '-' : 'd'
  end

  def format_permission(mode)
    new_mode = mode.to_s(8).slice(-3..5)
    permissions = new_mode.chars.map do |permission|
      MODE_TABLE[permission]
    end
    permissions.join
  end

  def format_mtime(stat)
    year = Date.today.year.to_s
    mtime = stat.mtime
    year == mtime.strftime('%Y') ? mtime.strftime('%_3m%_3d%_6R') : mtime.strftime('%_3m%_3d%_6Y')
  end
end
