require 'monocular/version'
require 'yaml'
require 'date'

module Monocular

  def self.annotate!
    Monocular.new do |m|
      m.backup_gemfile
      m.parse_gemfile
      m.annotate_gems
      m.write_to_gemfile
    end
    puts "Done"
  end

  class Monocular
    attr_accessor :gem_lines

    def initialize
      @gem_lines = []
      self
    end

    def backup_gemfile
      system('cp Gemfile Gemfile.bak')
    end

    def parse_gemfile
      File.read('Gemfile').each_line do |line|
        # Skip commented lines
        next if line.start_with?('#')
        # annotate gem and add to lines
        gem_lines << line
      end
    end

    def annotate_gems
      gem_lines.map! do |line|
        gem_name = extract_name(line)
        if gem_name
          [word_wrap(description_from(specs_for(gem_name))), line, ''].join("\n")
        else
          line
        end
      end
    end

    def write_to_gemfile
      File.open('Gemfile', 'w+') do |f|
        f.puts("# == Annotated on #{Date.today} ==")
        gem_lines.each { |line| f.puts(line) }
      end
    end

    def extract_name(line)
      line.scan(/gem '(.*?)',?/).flatten.first
      print "."
    end

    def specs_for(gem_name)
      spec = YAML.load(`gem specification #{gem_name}`)
      return spec if spec
      Gem.latest_spec_for(gem_name)
    end

    def description_from(gem_spec)
      if gem_spec.respond_to?(:description) && gem_spec.description
        gem_spec.description
      elsif gem_spec.respond_to?(:summary) && gem_spec.summary
        gem_spec.summary
      else
        'No Description Available'
      end
    end

    def word_wrap(description)
      # split on new line or space
      words = description.split(/[\n|\s]/)
      lines = []
      while words.any?
        line = '# '
        line  << "#{words.shift} " until line.size >= 80
        lines << line
      end
      lines.join("\n")
    end
  end
end
