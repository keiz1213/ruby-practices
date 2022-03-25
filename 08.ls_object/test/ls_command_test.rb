# frozen_string_literal: true

require 'minitest/autorun'
require_relative '../lib/vertical_output'

class LsCommandTest < Minitest::Test

  TARGET_PATHNAME = 'test/fixtures'

  def test_without_argument
    expected = <<~TEXT
    bar.rb     foo.rb     
    baz.rb     lib        
    bin        test       
    TEXT
    input = Input.new(ARGV)
    paths = input.paths
    options = input.options
    output = VerticalOutput.new(paths,options)
    assert_output(expected) { output.display }
  end

  def test_argument_with_path_for_a_file
    expected = <<~TEXT
    foo.rb     
    TEXT
    ARGV << 'foo.rb'
    input = Input.new(ARGV)
    paths = input.paths
    options = input.options
    output = VerticalOutput.new(paths,options)
    assert_output(expected) { output.display }
    ARGV.clear
  end

  def test_argument_with_path_for_files
    expected = <<~TEXT
    foo.rb     baz.rb     
    bar.rb     
    TEXT
    ARGV << 'foo.rb'
    ARGV << 'bar.rb'
    ARGV << 'baz.rb'
    input = Input.new(ARGV)
    paths = input.paths
    options = input.options
    output = VerticalOutput.new(paths,options)
    assert_output(expected) { output.display }
    ARGV.clear
  end

  def test_argument_with_path_and_L_option_for_files
    expected = `ls -l foo.rb bar.rb baz.rb`
    ARGV << 'bar.rb'
    ARGV << 'baz.rb'
    ARGV << 'foo.rb'
    ARGV << '-l'
    input = Input.new(ARGV)
    paths = input.paths
    options = input.options
    output = VerticalOutput.new(paths,options)
    assert_output(expected) { output.display }
    ARGV.clear
  end

  def test_argument_with_path_for_directory
    expected = <<~TEXT
    1111111.txt            baz.rb                 
    111111111111111111     foo.rb                 
    bar.rb                 zzzzzzzzzzzz.txt       
    TEXT
    ARGV << TARGET_PATHNAME
    input = Input.new(ARGV)
    paths = input.paths
    options = input.options
    output = VerticalOutput.new(paths,options)
    assert_output(expected) { output.display }
    ARGV.clear
  end

  def test_argument_with_path_and_R_option_for_directory
    expected = <<~TEXT
    zzzzzzzzzzzz.txt       bar.rb                 
    foo.rb                 111111111111111111     
    baz.rb                 1111111.txt            
    TEXT
    ARGV << TARGET_PATHNAME
    ARGV << '-r'
    input = Input.new(ARGV)
    paths = input.paths
    options = input.options
    output = VerticalOutput.new(paths,options)
    assert_output(expected) { output.display }
    ARGV.clear
  end

  def test_argument_with_path_and_A_option_for_directory
    expected = <<~TEXT
    .                      bar.rb                 
    ..                     baz.rb                 
    1111111.txt            foo.rb                 
    111111111111111111     zzzzzzzzzzzz.txt       
    TEXT
    ARGV << TARGET_PATHNAME
    ARGV << '-a'
    input = Input.new(ARGV)
    paths = input.paths
    options = input.options
    output = VerticalOutput.new(paths,options)
    assert_output(expected) { output.display }
    ARGV.clear
  end

  def test_argument_with_path_and_L_option_for_directory
    expected = `ls -l #{TARGET_PATHNAME}`
    ARGV << TARGET_PATHNAME
    ARGV << '-l'
    input = Input.new(ARGV)
    paths = input.paths
    options = input.options
    output = VerticalOutput.new(paths,options)
    assert_output(expected) { output.display }
    ARGV.clear
  end

  def test_argument_with_path_and_all_option_for_directory
    expected = `ls -arl #{TARGET_PATHNAME}`
    ARGV << TARGET_PATHNAME
    ARGV << '-arl'
    input = Input.new(ARGV)
    paths = input.paths
    options = input.options
    output = VerticalOutput.new(paths,options)
    assert_output(expected) { output.display }
    ARGV.clear
  end
end
