# DateParser

DateParser is a simple, fast, effective way of parsing dates from natural language
text in a flexible way.

# Installation
```
$ gem install date_parser
```

# Usage
```ruby
require 'date_parser'

text = "Newsflash: things happen on 02/12!"
creation_date = Date.parse("January 1st, 1994")

DateParser::parse(text, creation_date).to_s
    #=> [#<Date: 1994-02-12 ((2449396j,0s,0n),+0s,2299161j)>]


text = "We should go on the 4th if we can."
creation_date = Date.parse("July 1st 2016")

DateParser::parse(text, creation_date).to_s
    #=> [#<Date: 2016-07-04 ((2457574j,0s,0n),+0s,2299161j)>]


text = "Yesterday was certainly a day."
creation_date = Date.parse("January 12, 1994")

DateParser::parse(text, creation_date).to_s
    #=> [#<Date: 1994-01-11 ((2449364j,0s,0n),+0s,2299161j)>]


text = "The first time I asked someone on a date, I was in Iowa, it was a " +
       "winterly mid-month January, we were to go to finding nemo, I was 9, and " +
       "although she was interested, her parents said no."
creation_date = Date.parse("July 6, 2016")

DateParser::parse(text, creation_date).to_s
    #=> [#<Date: 2016-01-01 ((2457389j,0s,0n),+0s,2299161j)>]


text = "7-24-2015"
DateParser::parse(text, creation_date).to_s
    #=> [#<Date: 2015-07-24 ((2457228j,0s,0n),+0s,2299161j)>]


text = "2012-02-12"
DateParser::parse(text, creation_date).to_s
    #=> [#<Date: 2012-02-12 ((2455970j,0s,0n),+0s,2299161j)>]


text = "24-07-2015"
DateParser::parse(text, creation_date).to_s
    #=> [#<Date: 2015-07-24 ((2457228j,0s,0n),+0s,2299161j)>]


text = "In 1492 Columbus sailed the ocean blue."
creation_date = nil

DateParser::parse(text, creation_date, parse_single_years: true).to_s
    #=> [#<Date: 1492-01-01 ((2266011j,0s,0n),+0s,2299161j)>]


text = "Charlie Chaplin and Jason Earles (Hannah Montana's brother) were " +
       "alive at the same time for eight months in 1977"
creation_date = Date.parse("July 6, 2016")

DateParser::parse(text, creation_date, parse_single_years: true).to_s
    #=> [#<Date: 1977-01-01 ((2443145j,0s,0n),+0s,2299161j)>]


text = "Sunday, Sunday, Sunday!"
DateParser::parse(text, nil, unique: false).to_s
    #=> [#<Date: 2016-07-24 ((2457594j,0s,0n),+0s,2299161j)>, 
         #<Date: 2016-07-24 ((2457594j,0s,0n),+0s,2299161j)>, 
         #<Date: 2016-07-24 ((2457594j,0s,0n),+0s,2299161j)>]


text = "Sunday, Sunday, Sunday!"
DateParser::parse(text, nil, unique: true).to_s
    #=> [#<Date: 2016-07-24 ((2457594j,0s,0n),+0s,2299161j)>]


DateParser::parse("No dates here", nil).to_s
    #=> []


DateParser::parse("No dates here", 
                  nil, 
                  nil_date: Date.parse("Jan 1, 2016")
                  ).to_s
    #=> [#<Date: 2016-01-01 ((2457389j,0s,0n),+0s,2299161j)>]
```