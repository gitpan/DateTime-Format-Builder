#line 1 "inc/Module/Versions/Report.pm - /opt/perl/5.8.0/lib/site_perl/5.8.0/Module/Versions/Report.pm"

require 5;
package Module::Versions::Report;
$VERSION = '1.02';

#line 81

sub report {
  my @out;
  push @out,
    "\n\nPerl v",
    defined($^V) ? sprintf('%vd', $^V) : $],
    " under $^O ",
    (defined(&Win32::BuildNumber) and defined &Win32::BuildNumber())
      ? ("(Win32::BuildNumber ", &Win32::BuildNumber(), ")") : (),
    (defined $MacPerl::Version)
      ? ("(MacPerl version $MacPerl::Version)") : (),
    "\n"
  ;

  # Ugly code to walk the symbol tables:
  my %v;
  my @stack = ('');  # start out in %::
  my $this;
  my $count = 0;
  my $pref;
  while(@stack) {
    $this = shift @stack;
    die "Too many packages?" if ++$count > 1000;
    next if exists $v{$this};
    next if $this eq 'main'; # %main:: is %::

    #print "Peeking at $this => ${$this . '::VERSION'}\n";
    
    if(defined ${$this . '::VERSION'} ) {
      $v{$this} = ${$this . '::VERSION'}
    } elsif(
       defined *{$this . '::ISA'} or defined &{$this . '::import'}
       or ($this ne '' and grep defined *{$_}{'CODE'}, values %{$this . "::"})
       # If it has an ISA, an import, or any subs...
    ) {
      # It's a class/module with no version.
      $v{$this} = undef;
    } else {
      # It's probably an unpopulated package.
      ## $v{$this} = '...';
    }
    
    $pref = length($this) ? "$this\::" : '';
    push @stack, map m/^(.+)::$/ ? "$pref$1" : (), keys %{$this . '::'};
    #print "Stack: @stack\n";
  }
  push @out, " Modules in memory:\n";
  delete @v{'', '<none>'};
  foreach my $p (sort {lc($a) cmp lc($b)} keys %v) {
    #$indent = ' ' x (2 + ($p =~ tr/:/:/));
    push @out,  '  ',
      # $indent,
      $p, defined($v{$p}) ? " v$v{$p};\n" : ";\n";
  }
  push @out, sprintf "[at %s (local) / %s (GMT)]\n",
    scalar(localtime), scalar(gmtime);
  return join '', @out;
}

sub print_report { print '', report(); }

$Already = 0;

sub import {
  # so "use Module::Versions::Report;" sets up the END block, but
  # a mere "use Module::Versions::Report ();" doesn't.
  unless($Already) {
    eval 'END { print_report(); }';
    die "Extremely unexpected error in ", __PACKAGE__, ": $@" if $@;
    $Already = 1;
  }
  return;
}
1;

__END__

