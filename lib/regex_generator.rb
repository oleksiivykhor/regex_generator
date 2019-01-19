require 'regex_generator/version'
require 'byebug'
require 'regex_generator/generator'
require 'regex_generator/characters_recognizer'
require 'regex_generator/exceptions'

module RegexGenerator
  def self.generate(target, text)
    RegexGenerator::Generator.new(target, text).generate
  end
end
