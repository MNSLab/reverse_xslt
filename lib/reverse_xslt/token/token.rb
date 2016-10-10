module ReverseXSLT
  module Token
    class Token
      attr_reader :type, :value
      attr_accessor :children, :matching

      def ==(other)
        self.class == other.class && type == other.type && value == other.value && children == other.children
      end

      def initialize(type, value)
        @type = type
        @value = value
        @children = []
        @matching = nil
      end

      def clone
        res = self.class.new
        res.instance_variable_set('@type', type)
        res.instance_variable_set('@value', value)
        res.children = children.map(&:clone)
        res
      end

      def self.tokenize(text)
        text.gsub(/[a-z]+:/, '').gsub(/(?<=[^_a-z])(not|or|and)(?=[^_a-z])/, '_').gsub(/(?<=[^_a-z])(not|or|and)\z/, '_').gsub(/^(not|or|and)(?=[^_a-z])/, '_').gsub(/[^_a-z]/, '_').gsub(/[_]+/, '_').gsub(/\A_+/, '').gsub(/_+\z/, '')
      end

      private

      def extract_element_attribute(element, attr)
        if element.respond_to? :attr
          element.attr(attr)
        else
          element.to_s
        end
      end
    end
  end
end

require 'reverse_xslt/token/tag_token'
require 'reverse_xslt/token/text_token'
require 'reverse_xslt/token/if_token'
require 'reverse_xslt/token/value_of_token'
require 'reverse_xslt/token/for_each_token'
