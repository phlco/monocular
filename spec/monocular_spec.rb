require 'spec_helper'

describe Monocular do

  describe "specs_for" do
    it "returns Gem specification" do
      spec = Monocular.specs_for('bundler')
      expect( spec ).to be_instance_of Gem::Specification
    end
    it "returns nil when no gem can be found" do
      spec = Monocular.specs_for('the_undiscovered_country_of_fake_gems')
      expect( spec ).to be_nil
    end
  end

  describe "read_name" do
    it "returns a gem's name" do
      line = "gem 'rack', '~>1.1'"
      name = Monocular.read_name(line)
      expect( name ).to eq 'rack'
    end
    it "ignores lines without gems" do
      line = "source 'https://rubygems.org'"
      name = Monocular.read_name(line)
      expect( name ).to be_nil
    end
  end

  it "ignores commented lines" do
  end

  describe "description_for" do
    context("when summary or description") do
      it "gets a description" do
        description = Monocular.description_for('rack')
        expect( description ).to match "minimal, modular and adaptable interface"
      end
    end
    context("without summary or description") do
      it "returns no description" do
        description = Monocular.description_for('rack')
        expect( description ).to match 'No Description Available'
      end
    end
  end
  describe "word_wrap" do
    it "formats lines with comments" do
      text = "Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum."
      wrapped_text = Monocular.word_wrap(text)
      wrapped_text.split("\n").each do |line|
        expect( line.length ).to be < 100
      end
    end
    it "formats lines over 80 characters" do
      text = "Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum."
      wrapped_text = Monocular.word_wrap(text)
      expect( wrapped_text ).to match "\n# "
    end
  end
end
