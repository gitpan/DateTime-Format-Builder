# $Id: clone.t,v 1.1 2003/03/25 04:25:40 koschei Exp $
use strict;
use Test::More tests => 6;

BEGIN {
    use_ok 'DateTime::Format::Builder';
}

my $class = 'DateTime::Format::Builder';

my $clone_it = sub {
    my $obj = shift;
    my $method = shift||"new";
    my $clone = $obj->$method();
    isa_ok( $clone => $class );
    my $p1 = $obj->get_parser();
    my $p2 = $clone->get_parser();
    is( $p1 => $p2, "Parser cloned");
};


my $obj = $class->new();
isa_ok( $obj => $class );

for my $method (qw( new clone ))
{
    $clone_it->( $obj, $method );
}
