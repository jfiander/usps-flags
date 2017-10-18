# Monkey patch to add some formatting methods to Rational.
# 
# @author Julian Fiander
# @since 0.1.5
class Rational
  # Converts Rational to String
  #
  # If Rational is an improper fraction, removes the integer part to convert to a mixed fraction.
  #
  # @example Mixed fraction
  #   Rational(4,3).to_simplified_s #=> "1 1/3"
  # @return [String] If less than 1, fraction. If greater than 1, a mixed fraction.
  def to_simplified_s
    if self < 1
      to_s
    else
      truncated = self.truncate
      "#{truncated} #{self - truncated}"
    end
  end

  # Converts Rational to Array
  #
  # If Rational is an improper fraction, removes the integer part to convert to a mixed fraction.
  #
  # @example Mixed fraction
  #   Rational(4,3).to_simplified_a #=> [1, Rational(1,3)]
  # @return [Array] If less than 1, fraction. If greater than 1, a mixed fraction.
  def to_simplified_a
    if self < 1
      to_s
    else
      truncated = self.truncate
      [truncated, (self - truncated)]
    end
  end
end
