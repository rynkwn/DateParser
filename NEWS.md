# NaturalTime 0.1.0

* Improved parsing algorithm.

** No longer allow "sub-solutions" inside stricter solutions.

I.e., "June 3rd, 2014" will only return "June 3rd, 2014", and not a variety of
solutions like parsed("June"), parsed(June 3rd), e.t.c.
