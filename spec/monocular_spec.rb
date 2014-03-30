require 'spec_helper'
require 'monocular'

describe Monocular do
  let(:monocular) { Monocular::Monocular.new }
  describe '#extract_name' do
    it 'returns the name of a gem from a line' do
      line = "gem 'ruby-openid', :git => 'git://github.com/kendagriff/ruby-openid.git', :ref => '79beaa419d4754e787757f2545331509419e222e'"
      name = monocular.extract_name(line)
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
      it "returns description" do
        gem_spec = double('Gem::Specificiation', :description => 'Sass adapter for the Rails asset pipeline.')
        desc = monocular.description_from(gem_spec)
        expect( desc ).to eq 'Sass adapter for the Rails asset pipeline.'
      end
    end
    context('when Gem only has a summary') do
      it "returns the summary" do
        gem_spec = double('Gem::Specificiation', :description => '', :summary => 'Sass adapter for the Rails asset pipeline.')
        desc = monocular.description_from(gem_spec)
        expect( desc ).to eq 'Sass adapter for the Rails asset pipeline.'
      end
    end
    context('when neither') do
      it "returns no description available" do
        gem_spec = double('Gem::Specificiation', :description => '', :summary => '')
        desc = monocular.description_from(gem_spec)
        expect( desc ).to eq 'No Description Available'
      end
    end
  end
  describe '#word_wrap' do
    it 'formats text in 80 character lines' do
      unformatted_text = "Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum."
      formatted_text = monocular.word_wrap(unformatted_text)
      formatted_text.each_line do |line|
        expect( line.length ).to be < 100
      end
    end
  end
end
