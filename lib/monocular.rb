require 'monocular/version'
require 'yaml'
require 'date'

module Monocular
  class << self

    # Gem specifications are read in as YAML
    def specs_for(gem_name)
      spec = YAML.load(`gem specification #{gem_name}`)
      return spec if spec
      Gem.latest_spec_for(gem_name)
    end

    # Get the description or summary of a gem if available
    def description_for(gem_spec)
      if gem_spec.respond_to?(:description) && gem_spec.description
        gem_spec.description
      elsif gem_spec.respond_to?(:summary) && gem_spec.summary
        gem_spec.summary
      else
        "No Description Available"
      end
    end

    # limit lines to 80 characters
    def word_wrap(description)
      description.gsub!(/\n/, " ")
      lines = []
      words = description.split(" ")
      while words.any?
        line = "# "
        until line.size >= 80
          line << "#{words.shift} "
        end
        lines << line
      end
      lines.join("\n")
    end

    # form the commented out describe block
    def describe(gem_name)
      gem_spec = specs_for(gem_name)
      description = description_for(gem_spec)
      word_wrap(description)
    end

    # annotate the gem file with title, description and gem
    def annotate(line)
      gem_name = line.scan(/gem '(.*?)',?/).flatten.first
      if gem_name
        [ describe(gem_name), line, "" ].join("\n")
      else
        line
      end
    end

    def annotate!
      # backup gemfile
      system("cp Gemfile Gemfile.bak")
      gem_lines = []
      File.read("Gemfile").each_line do |line|
        # Skip commented lines
        next if line.start_with?("#")
        # annotate gem and add to lines
        gem_lines << annotate(line)
      end
      # write to gemfile
      File.open("Gemfile", "w+") do |f|
        f.puts("# == Annotated on #{Date.today.to_s} ==")
        gem_lines.each do |line|
          f.puts(line)
        end
      end
    end

  end
end
