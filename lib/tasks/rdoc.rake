require 'rdoc/task'
RDoc::Task.new :rdoc do |rdoc|
  rdoc.main = "README.rdoc"

    rdoc.rdoc_files.include("README.rdoc", "doc/*.rdoc", "app/**/*.rb", "lib/*.rb", "config/**/*.rb")
      #change above to fit needs
      #
        rdoc.title = "Coordinate"
          rdoc.options << "--all" 
        end
