require 'monocular/version'
require 'yaml'
require 'date'

module Monocular
  class Monocular

    attr_accessor :gem_lines

    def initialize
      @gem_lines = []
    end

    def annotate!
      backup_gemfile
      parse_gemfile
      annotate_gems
      write_to_gemfile
    end

    def backup_gemfile
      system('cp Gemfile Gemfile.bak')
    end

    def parse_gemfile
      gem_lines = []
      File.read('Gemfile').each_line do |line|
        # Skip commented lines
        next if line.start_with?('#')
        # annotate gem and add to lines
        gem_lines << line
      end
    end

    # annotate the gem file with title, description and gem
    def annotate_gems
      gem_lines.map! do |line|
        gem_name = extract_name(line)
        if gem_name
          [describe(gem_name), line, ''].join('\n')
        else
          line
        end
      end
    end

    def write_to_gemfile
      File.open('Gemfile', 'w+') do |f|
        f.puts("# == Annotated on #{Date.today} ==")
        gem_lines.each do |line|
          f.puts(line)
        end
      end
    end

    # parses name from line in Gemfile
    def extract_name(line)
      line.scan(/gem '(.*?)',?/).flatten.first
    end

    # form the commented out describe block
    def describe(gem_name)
      gem_specs = specs_for(gem_name)
      description = description_from(gem_specs)
      word_wrap(description)
    end

    # Gem specifications are read in as YAML
    def specs_for(gem_name)
      spec = YAML.load(`gem specification #{gem_name}`)
      return spec if spec
      Gem.latest_spec_for(gem_name)
    end

    # Get the description or summary of a gem if available
    def description_from(gem_spec)
      if gem_spec.respond_to?(:description) && gem_spec.description
        gem_spec.description
      elsif gem_spec.respond_to?(:summary) && gem_spec.summary
        gem_spec.summary
      else
        'No Description Available'
      end
    end

    # limit lines to 80 characters
    def word_wrap(description)
      # split on new line or space
      words = description.split(/[\n|\s]/)
      lines = []
      while words.any?
        line = '# '
        line << "#{words.shift} " until line.size >= 80
        lines << line
      end
      lines.join('\n')
    end

  end
end
