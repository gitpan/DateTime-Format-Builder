#line 1 "inc/Test/Signature.pm - /opt/perl/5.8.0/lib/site_perl/5.8.0/Test/Signature.pm"
package Test::Signature;

#line 40

use strict;
use Exporter;
use vars qw( $VERSION @ISA @EXPORT @EXPORT_OK );
$VERSION = '1.04';
@ISA = qw( Exporter );
@EXPORT = qw( signature_ok );
@EXPORT_OK = qw( signature_force_ok );

use Test::Builder;

my $test = Test::Builder->new();

#line 76

sub signature_ok
{
    my $name  = shift || 'Valid signature';
    my $force = shift || 0;
    SKIP: {
	if ( !-s 'SIGNATURE' )
	{
	    $test->skip( "No SIGNATURE file found." );
	}
	elsif ( !eval { require Socket; Socket::inet_aton('pgp.mit.edu') })
	{
	    $test->skip( "Cannot connect to the keyserver." );
	}
	elsif ( !eval { require Module::Signature; 1 } )
	{
	    if ($force)
	    {
		$test->ok(0, $name);
		$test->diag(<<"EOF");
You need Module::Signature for this distribution.
With that, you can have the contents of the archive verified.
EOF
	    }
	    else
	    {
		$test->skip( "No Module::Signature installed." );
		$test->diag(<<"EOF");
Next time around, consider installing Module::Signature,
so you can verify the integrity of this distribution.
EOF
	    }
	}
	else
	{
	    $test->diag(<<"EOF");

Using Module::Signature v$Module::Signature::VERSION

EOF
	    $test->ok(
		Module::Signature::verify() == Module::Signature::SIGNATURE_OK()
		=> $name);
	}
    }
}

#line 137

sub signature_force_ok
{
    signature_ok( $_[0]||undef, 1);
}

1;
__END__

#line 314
