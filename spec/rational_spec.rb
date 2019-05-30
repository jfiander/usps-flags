# frozen_string_literal: false

require 'spec_helper'

describe Rational do
  describe 'monkey patches' do
    it 'should render a simplified fraction as an Array' do
      expect(Rational(4, 3).to_simplified_a).to eql([1, Rational(1, 3)])
    end

    it 'should render a proper fraction as String' do
      expect(Rational(2, 3).to_simplified_a).to eql('2/3')
    end

    it 'should render a simplified fraction as a String' do
      expect(Rational(4, 3).to_simplified_s).to eql('1 1/3')
    end
  end
end
