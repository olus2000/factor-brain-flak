! Copyright (C) 2023 Aleksander Sabak.
! See http://factorcode.org/license.txt for BSD license.
USING: accessors assocs combinators combinators.short-circuit
kernel math sequences sets splitting strings.parser vectors ;
IN: brain-flak


ERROR: unclosed-brain-flak-expression program ;
ERROR: mismatched-brain-flak-brackets program ;
ERROR: leftover-program-after-compilation program leftover ;


<PRIVATE

: matches ( a b -- ? )
  { { CHAR: ( CHAR: ) }
    { CHAR: [ CHAR: ] }
    { CHAR: { CHAR: } }
    { CHAR: < CHAR: > }
    { CHAR: ) CHAR: ( }
    { CHAR: ] CHAR: [ }
    { CHAR: } CHAR: { }
    { CHAR: > CHAR: < } } at = ;

: glue ( a stack2 stack1 b -- a+b stack2 stack1 ) roll + -rot ;

: (()) ( ret stack2 stack1 -- ret stack2 stack1 ) 1 glue ;

: ([]) ( ret stack2 stack1 -- ret stack2 stack1 )
  dup length glue ;

: ({}) ( ret stack2 stack1 -- ret stack2 stack1 )
  dup [ pop glue ] unless-empty ;

: (<>) ( ret stack2 stack1 -- ret stack2 stack1 ) swap ;

: ()) ( ret stack2 stack1 quot -- ret stack2 stack1 )
  0 -roll call rot [ suffix! ] keep glue ; inline

: (]) ( ret stack2 stack1 quot -- ret stack2 stack1 )
  0 -roll call rot neg glue ; inline

: (}) ( ret stack2 stack1 quot -- ret stack2 stack1 )
  0 -roll [ dup { [ empty? ] [ last 0 = ] } 1|| ] swap until
  rot glue ; inline

: (>) ( ret stack2 stack1 quot -- ret stack2 stack1 )
  0 -roll call rot drop ; inline

: compile-bf-subexpr ( vec string-like -- vec string-like )
  [ { { [ dup empty? ] [ f ] }
      { [ dup first ")]}>" in? ] [ f ] }
      { [ "()" ?head-slice ] [ [ \ (()) suffix! ] dip t ] }
      { [ "[]" ?head-slice ] [ [ \ ([]) suffix! ] dip t ] }
      { [ "{}" ?head-slice ] [ [ \ ({}) suffix! ] dip t ] }
      { [ "<>" ?head-slice ] [ [ \ (<>) suffix! ] dip t ] }
      [ 0 <vector> swap [ rest-slice ] [ first ] bi
        [ compile-bf-subexpr [ [ ] clone-like suffix! ] dip
          [ dup empty?
            [ dup seq>> unclosed-brain-flak-expression ]
            [ rest-slice ] if ] [ ?first ] bi
        ] dip
        over matches
        [ over seq>> mismatched-brain-flak-brackets ] unless
        { { CHAR: ) [ [ \ ()) suffix! ] dip ] }
          { CHAR: ] [ [ \ (]) suffix! ] dip ] }
          { CHAR: } [ [ \ (}) suffix! ] dip ] }
          { CHAR: > [ [ \ (>) suffix! ] dip ] } } case t ]
    } cond ] loop ;

PRIVATE>


: compile-brain-flak ( string -- quote )
  [ "()[]{}<>" in? ] filter dup
  V{ dup V{ } clone-like 0 0 <vector> rot } clone
  swap compile-bf-subexpr
  [ overd leftover-program-after-compilation ] unless-empty
  { 2nip swap clone-like } append! [ ] clone-like nip ;

SYNTAX: b-f" parse-string compile-brain-flak append! ;
