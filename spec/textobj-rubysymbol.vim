" TODO make this evaluable
"
" Reference:
" http://web.njit.edu/all_topics/Prog_Lang_Docs/html/ruby/yacc.html
"
" It Should select
"
"   SYMBOL
"
"     FNAME
"
"       IDENTIFIER
"        :foo
"        :_foo
"        :fooBAR_4
"       AND
"        :..
"        :|
"        :^
"        :&
"        :<=> 
"        :== 
"        :=== 
"        :=~
"        :> 
"        :>= 
"        :< 
"        :<=
"        :+ 
"        :- 
"        :* 
"        :/ 
"        :% 
"        :**
"        :<< 
"        :>> 
"        :~
"        :+@ 
"        :-@ 
"        :[] 
"        :[]=
"
"     VARNAME
"
"       GLOBAL
"         :$foo_Bar
"         :$f (TODO implement)
"         :$-f (TODO implement)
"       @IDENTIFIER
"        :@foo
"       IDENTIFIER
"
" 
"     EXTRA (not in BNF?)
"        :@@foo
"        :foo?
"        :foo!
"        :foo=
"        :許功蓋
"        :自求foo多福
"        :"foo bar" (TODO implement)
"        :"every\nTHING" (TODO implement)
"
"
"
" It Should not select:
"
"   :4oobar (TODO implement)
"   (:foobar)
"   :@@@foo
"   ::foo (TODO implement)
"   :foo#bar
"   :!=
"   :!~
