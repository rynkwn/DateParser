# DateParser 0.1.2
* New option: `parse_ambiguous_dates` flag, which determines whether or not some 
looser phrases are considered dates.
* Documentation fixes.

# DateParser 0.1.1
* Critical bug fix - Helper files now sent with the gem.

# DateParser 0.1.0

* Improved parsing algorithm.
* No longer allow "sub-solutions" inside stricter solutions.
* Parser can now correctly parse sentences like "meet me on the 10th"
* Parser can now correctly parse XX/XX dates relative to a released date.
* Now parses simple 'relative words' like "yesterday" and "today" correctly.
* Many, many more functions are now released sensitive!
* Option to parse single years (Such as "1302" alone.)
* Various smaller bug fixes.