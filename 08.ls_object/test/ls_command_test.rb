# frozen_string_literal: true

require 'minitest/autorun'
require_relative '../lib/vertical'

class LsCommandTest < Minitest::Test

  TARGET_PATHNAME = './test/fixtures'
  CURRENT_DIRECTORY = Dir.getwd

  def test_non_argument
    expected = <<~TEXT
    bar.rb     lib        
    baz.rb     test       
    foo.rb     
    TEXT
    input = Input.new(ARGV)
    path = input.path
    options = input.options
    vertical = Vertical.new(path, options)
    assert_output(expected) { vertical.display }
  end

  def test_argument_with_path
    expected = <<~TEXT
    1111111.txt            baz.rb                 
    111111111111111111     foo.rb                 
    bar.rb                 zzzzzzzzzzzz.txt       
    TEXT
    ARGV << TARGET_PATHNAME
    input = Input.new(ARGV)
    path = input.path
    options = input.options
    vertical = Vertical.new(path, options)
    assert_output(expected) { vertical.display }
    ARGV.clear
    Dir.chdir(CURRENT_DIRECTORY)
  end

  def test_argument_with_path_and_R_option
    expected = <<~TEXT
    zzzzzzzzzzzz.txt       bar.rb                 
    foo.rb                 111111111111111111     
    baz.rb                 1111111.txt            
    TEXT
    ARGV << TARGET_PATHNAME
    ARGV << '-r'
    input = Input.new(ARGV)
    path = input.path
    options = input.options
    vertical = Vertical.new(path, options)
    assert_output(expected) { vertical.display }
    ARGV.clear
    Dir.chdir(CURRENT_DIRECTORY)
  end

  def test_argument_with_path_and_A_option
    expected = <<~TEXT
    .                      bar.rb                 
    ..                     baz.rb                 
    1111111.txt            foo.rb                 
    111111111111111111     zzzzzzzzzzzz.txt       
    TEXT
    ARGV << TARGET_PATHNAME
    ARGV << '-a'
    input = Input.new(ARGV)
    path = input.path
    options = input.options
    vertical = Vertical.new(path, options)
    assert_output(expected) { vertical.display }
    ARGV.clear
    Dir.chdir(CURRENT_DIRECTORY)
  end

  def test_argument_with_path_and_L_option
    expected = `ls -l #{TARGET_PATHNAME}`
    ARGV << TARGET_PATHNAME
    ARGV << '-l'
    input = Input.new(ARGV)
    path = input.path
    options = input.options
    vertical = Vertical.new(path, options)
    assert_output(expected) { vertical.display }
    ARGV.clear
    Dir.chdir(CURRENT_DIRECTORY)
  end

  def test_argument_with_path_and_all_option
    expected = `ls -arl #{TARGET_PATHNAME}`
    ARGV << TARGET_PATHNAME
    ARGV << '-arl'
    input = Input.new(ARGV)
    path = input.path
    options = input.options
    vertical = Vertical.new(path, options)
    assert_output(expected) { vertical.display }
    ARGV.clear
    Dir.chdir(CURRENT_DIRECTORY)
  end
end
