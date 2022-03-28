# frozen_string_literal: true

require 'minitest/autorun'
require_relative '../lib/vertical_output'

class LsCommandTest < Minitest::Test

  TARGET_PATHNAME = 'fixtures'

  Dir.chdir('test')

  def test_without_argument
    expected = <<~TEXT
    bar.rb                 foo.rb                 
    baz.rb                 ls_command_test.rb     
    fixtures               
    TEXT
    input = Input.new(ARGV)
    paths = input.paths
    options = input.options
    output = VerticalOutput.new(paths,options)
    assert_output(expected) { output.display }
  end

  def test_argument_with_file_name
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

  def test_argument_with_file_names
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

  def test_argument_with_file_names_and_L_option
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

  def test_argument_with_path
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

  def test_argument_with_path_and_R_option
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
    paths = input.paths
    options = input.options
    output = VerticalOutput.new(paths,options)
    assert_output(expected) { output.display }
    ARGV.clear
  end

  def test_argument_with_path_and_L_option
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

  def test_argument_with_path_and_all_option
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
