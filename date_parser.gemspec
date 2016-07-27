Gem::Specification.new do |s|
  s.name        = 'DateParser'
  s.version     = '0.1.1'
  s.date        = '2016-07-26'
  s.summary     = "Quickly parse natural language into dates robustly."
  s.description = "DateParser is a simple, fast, and effective way to " +
                  "parse dates from natural language text in a robust way."
  s.authors     = ["Ryan Kwon"]
  s.email       = 'rynkwn@gmail.com'
  s.files       = ["lib/date_parser.rb", 
  
                   "lib/date_parser/date_utils.rb",
                   "lib/date_parser/natural_date_parsing.rb",
                   "lib/date_parser/utils.rb"]
  s.test_files  = ["lib/spec/date_parser_spec.rb"]
  
  s.extra_rdoc_files = %w[README.md NEWS.md]
  s.homepage    = 'https://github.com/rynkwn/DateParser'
  s.license     = 'MIT'
end