require 'spec_helper'
require 'monocular'

describe Monocular do
  let(:monocular) { Monocular::Moncular.new }
  describe '#extract_name' do
    it 'returns the name of a gem from a line' do
      line = "gem 'ruby-openid', :git => 'git://github.com/kendagriff/ruby-openid.git', :ref => '79beaa419d4754e787757f2545331509419e222e'"
      monocular.extract_name(line)
      expect( name ).to eq 'ruby-openid'
    end
  end
  describe '#specs_for' do
    it 'returns a Gemfile Specification' do
      specs = monocular.specs_for('ruby-openid')
      expect( specs ).to be_an_instance_of Gem::Specification
    end
  end
  describe '#description_from' do
    context('When Gem has a description') do
      gem_spec = double('Gem::Specificiation', :description => 'Sass adapter for the Rails asset pipeline.')
      desc = monocular.description_from(gem_spec)
      expect( desc ).to eq 'Sass adapter for the Rails asset pipeline.'
    end
    context('when Gem only has a summary') do
      gem_spec = double('Gem::Specificiation', :description => '', :summary => 'Sass adapter for the Rails asset pipeline.')
      desc = monocular.description_from(gem_spec)
      expect( desc ).to eq 'Sass adapter for the Rails asset pipeline.'
    end
    context('when neither') do
      desc = monocular.description_from(gem_spec)
      expect( desc ).to eq 'No Description Available'
    end
  end
  describe '#word_wrap' do
    it 'formats text in 80 character lines' do
    end
  end
end
