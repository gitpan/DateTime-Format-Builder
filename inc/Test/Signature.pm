#line 1 "inc/Test/Signature.pm - /opt/perl/5.8.0/lib/site_perl/5.8.0/Test/Signature.pm"
package Test::Signature;

#line 40

use strict;
use Exporter;
use vars qw( $VERSION @ISA @EXPORT @EXPORT_OK );
$VERSION = '1.05';
@ISA = qw( Exporter );
@EXPORT = qw( signature_ok );
@EXPORT_OK = qw( signature_force_ok );

use Test::Builder;

my $test = Test::Builder->new();

#line 76

sub action_skip { $test->skip( $_[0] ) }
sub action_ok   { $test->ok( 0, $_[0] ) }

sub signature_ok
{
    my $name  = shift || 'Valid signature';
    my $force = shift || 0;
    my $action = $force ? \&action_ok : \&action_skip;
    SKIP: {
	if ( !-s 'SIGNATURE' )
	{
	    $action->( "No SIGNATURE file found." );
	}
	elsif ( !eval { require Module::Signature; 1 } )
	{
            $action->(
                "Next time around, consider installing Module::Signature, ".
                "so you can verify the integrity of this distribution." );
	}
	elsif ( !eval { require Socket; Socket::inet_aton('pgp.mit.edu') })
	{
	    $action->( "Cannot connect to the keyserver." );
	}
	else
	{
	    $test->ok(
		Module::Signature::verify() == Module::Signature::SIGNATURE_OK()
		=> $name);
	}
    }
}

#line 123

sub signature_force_ok
{
    signature_ok( $_[0]||undef, 1);
}

1;
__END__

#line 300
