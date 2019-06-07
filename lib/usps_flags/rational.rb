# frozen_string_literal: false

# Monkey patch to add some formatting methods to Rational.
#
# @author Julian Fiander
# @since 0.1.5
class USPSFlags
  class Rational
    def initialize(rational)
      @rational = rational
    end

    # Converts Rational to String
    #
    # If Rational is an improper fraction, removes the integer part to convert to a mixed fraction.
    #
    # @example Mixed fraction
    #   Rational(4,3).to_simplified_s #=> "1 1/3"
    # @return [String] If less than 1, fraction. If greater than 1, a mixed fraction.
    def to_simplified_s
      @rational < 1 ? @rational.to_s : [@rational.truncate.to_s, (@rational - @rational.truncate).to_s].join(' ')
    end

    # Converts Rational to Array
    #
    # If Rational is an improper fraction, removes the integer part to convert to a mixed fraction.
    #
    # @example Mixed fraction
    #   Rational(4,3).to_simplified_a #=> [1, Rational(1,3)]
    # @return [Array] If less than 1, fraction. If greater than 1, a mixed fraction.
    def to_simplified_a
      @rational < 1 ? @rational.to_s : [@rational.truncate, (@rational - @rational.truncate)]
    end
  end
end
