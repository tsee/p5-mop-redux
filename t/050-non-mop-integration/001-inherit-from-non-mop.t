#!/usr/bin/perl

use strict;
use warnings;

use Test::More;
use Test::Fatal;

use mop;

{
    package BaseObject;
    use strict;
    use warnings;

    sub new { bless {} => shift }

    sub hello { 'Object::hello' }
}


class Foo (extends => 'BaseObject') {

    method bar { 'Foo::bar' }    

    submethod gorch { 'Foo::gorch' }
}

class Bar (extends => 'Foo') {
    
    method baz { 'Bar::baz' }    
}

my $foo = Foo->new;
is($foo->bar, 'Foo::bar', '... got the value we expected from $foo->bar');
is($foo->gorch, 'Foo::gorch', '... got the value we expected from $foo->gorch');

is(Foo->bar, 'Foo::bar', '... got the value we expected from Foo->bar');
is(Foo->gorch, 'Foo::gorch', '... got the value we expected from Foo->gorch');

my $bar = Bar->new;
is($bar->baz, 'Bar::baz', '... got the value we expected from $bar->baz');
is($bar->bar, 'Foo::bar', '... got the value we expected from $bar->bar');
like(exception { $bar->gorch }, qr/^Could not find gorch in/, '... cannot call gorch with $bar');

is(Bar->baz, 'Bar::baz', '... got the value we expected from Bar->baz');
is(Bar->bar, 'Foo::bar', '... got the value we expected from Bar->bar');
like(exception { Bar->gorch }, qr/^Could not find gorch in/, '... cannot call gorch with Bar');

is(Bar->hello, 'Object::hello', '... got the value we expected from Bar->hello');
is(Foo->hello, 'Object::hello', '... got the value we expected from Foo->hello');

is_deeply(
    mop::mro::get_linear_isa('Foo'),
    [ 'Foo', 'BaseObject' ],
    '... got the expected linear isa'
);

is_deeply(
    mop::mro::get_linear_isa('Bar'),
    [ 'Bar', 'Foo', 'BaseObject' ],
    '... got the expected linear isa'
);

done_testing;


