#line 1 "inc/YAML/Family.pm - /opt/perl/5.8.2/lib/site_perl/5.8.2/YAML/Family.pm"
package YAML::Family;

sub new {
    my ($class, $self) = @_;
    bless \$self, $class
}

sub short {
    ${$_[0]}
}

sub canonical {
    ${$_[0]}
}

1;
