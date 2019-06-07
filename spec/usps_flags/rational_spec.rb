# frozen_string_literal: false

require 'spec_helper'

describe USPSFlags::Rational do
  it 'renders a simplified fraction as an Array' do
    expect(described_class.new(Rational(4, 3)).to_simplified_a).to eql([1, Rational(1, 3)])
  end

  it 'renders a proper fraction as String' do
    expect(described_class.new(Rational(2, 3)).to_simplified_a).to eql('2/3')
  end

  it 'renders a simplified fraction as a String' do
    expect(described_class.new(Rational(4, 3)).to_simplified_s).to eql('1 1/3')
  end
end
