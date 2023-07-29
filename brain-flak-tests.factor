! Copyright (C) 2023 Aleksander Sabak.
! See http://factorcode.org/license.txt for BSD license.
USING: accessors brain-flak combinators.short-circuit kernel
    strings tools.test ;
IN: brain-flak.tests


{ { } } [ { } "" compile-brain-flak call ] unit-test

{ { } } [ { } b-f"" ] unit-test

{ { } } [ { } "X" compile-brain-flak call ] unit-test

{ { } } [ { } b-f"X" ] unit-test

{ { } } [ { } "()" compile-brain-flak call ] unit-test

{ { } } [ { } b-f"()" ] unit-test

{ { } } [ { } "[]" compile-brain-flak call ] unit-test

{ { } } [ { } b-f"[]" ] unit-test

{ { } } [ { } "{}" compile-brain-flak call ] unit-test

{ { } } [ { } b-f"{}" ] unit-test

{ { } } [ { } "<>" compile-brain-flak call ] unit-test

{ { } } [ { } b-f"<>" ] unit-test

{ { 1 } } [ { } "(())" compile-brain-flak call ] unit-test

{ { 1 } } [ { } b-f"(())" ] unit-test

{ { 1 } } [ { } "((X))" compile-brain-flak call ] unit-test

{ { 1 } } [ { } b-f"((X))" ] unit-test

{ { 1 } } [ { } "(X()X)" compile-brain-flak call ] unit-test

{ { 1 } } [ { } b-f"(X()X)" ] unit-test

{ { 2 } } [ { } "(()())" compile-brain-flak call ] unit-test

{ { 2 } } [ { } b-f"(()())" ] unit-test

{ { 2 2 } } [ { } "((()()))" compile-brain-flak call ] unit-test

{ { 2 2 } } [ { } b-f"((()()))" ] unit-test

{ { 0 } } [ { } "([])" compile-brain-flak call ] unit-test

{ { 0 } } [ { } b-f"([])" ] unit-test

{ { 1 2 3 3 } } [ { 1 2 3 } "([])" compile-brain-flak call ]
unit-test

{ { 1 2 3 3 } } [ { 1 2 3 } b-f"([])" ] unit-test

{ { 1 2 2 3 } } [ { 1 2 } "([])([])" compile-brain-flak call ]
unit-test

{ { 1 2 2 3 } } [ { 1 2 } b-f"([])([])" ] unit-test

{ { 0 } } [ { } "({})" compile-brain-flak call ] unit-test

{ { 0 } } [ { } b-f"({})" ] unit-test

{ { 1 2 } } [ { 1 2 } "({})" compile-brain-flak call ] unit-test

{ { 1 2 } } [ { 1 2 } b-f"({})" ] unit-test

{ { 1 } } [ { 1 2 } "{}" compile-brain-flak call ] unit-test

{ { 1 } } [ { 1 2 } b-f"{}" ] unit-test

{ { 0 } } [ { 1 2 } "(<>)" compile-brain-flak call ] unit-test

{ { 0 } } [ { 1 2 } b-f"(<>)" ] unit-test

{ { 1 2 0 } } [ { 1 2 } "(<><>)" compile-brain-flak call ]
unit-test

{ { 1 2 0 } } [ { 1 2 } b-f"(<><>)" ] unit-test

{ { 0 } } [ { } "([[]])" compile-brain-flak call ] unit-test

{ { 0 } } [ { } b-f"([[]])" ] unit-test

{ { 1 2 -2 } } [ { 1 2 } "([[]])" compile-brain-flak call ]
unit-test

{ { 1 2 -2 } } [ { 1 2 } b-f"([[]])" ] unit-test

{ { 0 } } [ { } "([()]())" compile-brain-flak call ] unit-test

{ { 0 } } [ { } b-f"([()]())" ] unit-test

{ { 0 } } [ { } "({<>})" compile-brain-flak call ] unit-test

{ { 0 } } [ { } b-f"({<>})" ] unit-test

{ { 4 3 2 1 0 6 } }
[ { 4 } "({(({})[()])})" compile-brain-flak call ] unit-test

{ { 4 3 2 1 0 6 } } [ { 4 } b-f"({(({})[()])})" ] unit-test

{ { 0 } } [ { } "(<()()()>)" compile-brain-flak call ] unit-test

{ { 0 } } [ { } b-f"(<()()()>)" ] unit-test

{ { 1 0 } } [ { 1 2 } "(<<>({}())>)" compile-brain-flak call ]
unit-test

{ { 1 0 } } [ { 1 2 } b-f"(<<>({}())>)" ] unit-test


[ "{" compile-brain-flak call ]
[ { [ unclosed-brain-flak-expression? ]
    [ program>> "{" = ]
  } 1&& ] must-fail-with

[ "{>" compile-brain-flak call ]
[ { [ mismatched-brain-flak-brackets? ]
    [ program>> "{>" = ]
  } 1&& ] must-fail-with

[ "{}>" compile-brain-flak call ]
[ { [ leftover-program-after-compilation? ]
    [ program>> "{}>" = ]
    [ leftover>> >string ">" = ]
  } 1&& ] must-fail-with
