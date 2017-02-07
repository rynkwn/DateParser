# DateParser 0.1.51
* Missed a common case: XX/XX/XXXX and variations. Now resolved.
* Strengthened check for dates that could be of the form XX/XX

# DateParser 0.1.4
* Improved namespacing.
    + NaturalDateParsing and Utils now part of the DateParser namespace.
* Removed an unused utils file.
* Some documentation expansion.

# DateParser 0.1.3
* New internal checks to avoid ambiguous behavior.
    + Notably: creation_date is enforced to be a descendent of the Date class.
* New tests to ensure that the program fails when unexpected types are passed in.

# DateParser 0.1.2
* New option: `parse_ambiguous_dates` flag, which determines whether or not some 
looser phrases are considered dates.
* Documentation fixes and format improvements.
* Added more test cases to cover options in `parse`.
* Restructured test files.
* `parse` option defaults now work in all cases.

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