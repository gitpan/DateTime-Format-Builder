# $Id: basic.t,v 1.3 2003/06/24 07:16:28 koschei Exp $
use lib 'inc';
use blib;
use strict;
use Module::Versions::Report qw();
use Test::More tests => 5;
END { diag '', Module::Versions::Report::report() }

BEGIN {
    use_ok 'DateTime::Format::Builder';
}

my $class = 'DateTime::Format::Builder';

# Does new() work properly?
{
    eval { $class->new('fnar') };
    ok(( $@ and $@ =~ /takes no param/), "Too many parameters exception" );

    my $obj = eval { $class->new() };
    ok( !$@, "Created object" );
    isa_ok( $obj, $class );

    eval { $obj->parse_datetime( "whenever" ) };
    ok(( $@ and $@ =~ /No parser/), "No parser exception" );

}
