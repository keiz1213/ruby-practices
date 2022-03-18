# frozen_string_literal: true

require 'etc'
require 'date'

class Entry
  attr_reader :name, :stat

  def initialize(name)
    @name = name
    @stat = File::Stat.new(name)
  end

  def line(l_max, o_max, g_max, f_max)
    file_type = self.file_type
    permission = self.permission
    link = self.link
    owner = self.owner
    group = self.group
    file_size = self.file_size
    mtime = self.mtime
    "#{file_type}#{permission}#{link.rjust(l_max + 2)} #{owner.ljust(o_max + 1)}#{group.rjust(g_max + 1)} #{file_size.rjust(f_max + 1)}#{mtime} #{@name}"
  end

  def blocks
    stat.blocks
  end

  def link
    stat.nlink.to_s
  end

  def owner
    Etc.getpwuid(stat.uid).name.to_s
  end

  def group
    Etc.getgrgid(stat.gid).name.to_s
  end

  def file_size
    stat.size.to_s
  end

  private

  def file_type
    mode = stat.mode.to_s(8)
    if mode.start_with? '40'
      'd'
    else
      '-'
    end
  end

  def permission
    mode = stat.mode.to_s(8)
    new_mode = mode.slice(-3..5)
    permissions = new_mode.chars.map do |permission|
      {
        '0' => '---', '1' => '--x', '2' => '-w-', '3' => '-wx', '4' => 'r--', '5' => 'r-x', '6' => 'rw-', '7' => 'rwx'
      }[permission]
    end
    permissions.join
  end

  def mtime
    year = Date.today.year.to_s
    mtime = stat.mtime
    if year == mtime.strftime('%Y')
      mtime.strftime('%_3m%_3d%_6R')
    else
      mtime.strftime('%_3m%_3d%_6Y')
    end
  end
end
