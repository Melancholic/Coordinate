desc 'Generate Entity Relationship Diagram'
task :generate_erd do
  system "erd --inheritance --filetype=dot --direct --attributes=foreign_keys,content"
  system "dot -Tpng erd.dot > erd.png"
  File.delete('erd.dot')
end
task :generate_erd_pdf do
  system "erd --inheritance --filetype=dot --direct --attributes=foreign_keys,content"
  system "dot -Tpdf erd.dot > erd.pdf"
  File.delete('erd.dot')
end
