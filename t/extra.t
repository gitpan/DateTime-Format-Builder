# $Id: extra.t,v 1.3 2003/05/23 07:39:45 koschei Exp $
use lib 'inc';
use strict;
use Test::More tests => 2;

BEGIN {
    use_ok 'DateTime::Format::Builder';
}

my $class = 'DateTime::Format::Builder';

{
    my $parser = $class->parser( {
	params => [ qw( year month day hour minute second ) ],
	regex  => qr/^(\d\d\d\d)(\d\d)(\d\d)T(\d\d)(\d\d)(\d\d)$/,
	extra  => { time_zone => 'America/Chicago' },
    } );

    my $dt = $parser->parse_datetime( "20030716T163245" );

    is( $dt->time_zone->name, 'America/Chicago' );
}
