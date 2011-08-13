" TODO make this evaluable
"
" Reference:
" http://doc.ruby-lang.org/ja/1.9.2/doc/spec=2fliteral.html#symbol
"
"   : identifier
"   : variable name
"   : operator (which can be defined as method)
"
"   :'foo-bar'
"   :"foo-bar"
"   :"foo #{:nested}" (TODO implement)
"   %s{foo-bar} (TODO implement)
"
" Reference:
" http://doc.ruby-lang.org/ja/1.9.2/doc/spec=2fbnf.html
"
" It Should select
"
"   SYMBOL
"
"     FNAME
"
"       OPERATION
"         IDENTIFIER
"          :foo
"          :_foo
"          :fooBAR_4
"         IDENTIFIER! / IDENTIFIER?
"          :foo_bar!
"          :foo4aR?
"       AND
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
"        :`
"        :+@
"        :-@
"        :[]
"        :[]=
"
"     VARNAME
"
"       GLOBAL
"         :$foo_Bar
"         :$f
"         :$(
"         :$-\
"         :$-  (XXX the spec is `:$-any_char`, so we match `$- ` with space, too. Might make conflicts.)
"       @IDENTIFIER
"        :@foo
"       @@IDENTIFIER
"        :@@foo
"
"     EXTRA (not in BNF?)
"        :foo=
"        :'foo bar'
"        :'foo\ \\\'bar'
"        :'foo
"             \\\'bar'
"        :'foo \\\'
"             \\'bar' don't match here
"        :"foo bar"
"        :"foo \"\\\"foo"
"
"        :"foo  \"\\\\"foo"bar
"        :"foo \\"\\\\"foo"
"
"        :"every\nTHING"
"
"
"
" It Should not select:
"
"   :4oobar
"   (:foobar)
"   :許功蓋
"   :文foo字
"   :@@@foo
"   :@@-oo
"   \:foo
"   ]:foo
"   }:foo
"   ":foo
"   ':foo
"   ::foo
"   :foo#bar
"   :!=
"   :!~
