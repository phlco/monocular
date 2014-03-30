require 'monocular/version'
require 'yaml'
require 'date'
require 'pry'

module Monocular
  class Monocular
    attr_accessor :gem_lines

    def initialize
      @gem_lines = []
    end

    def self.annotate!
      worker = self.new
      worker.backup_gemfile
      worker.parse_gemfile
      worker.annotate_gems
      worker.write_to_gemfile
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
      gem_lines.map! { |line| annotate(line) }
    end

    def annotate(line)
      gem_name = extract_name(line)
      if gem_name
        [word_wrap(description_from(specs_for(gem_name))), line, ''].join("\n")
      else
        line
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
    end

    def specs_for(gem_name)
      spec = YAML.load(`gem specification #{gem_name}`)
      if spec
        return spec
      else
        return Gem.latest_spec_for(gem_name)
      end
    end

    def description_from(gem_spec)
      print "."
      if gem_spec.respond_to?(:description) && !gem_spec.description.nil? && !gem_spec.description.empty?
        gem_spec.description
      elsif gem_spec.respond_to?(:summary) && !gem_spec.summary.nil? && !gem_spec.summary.empty?
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
