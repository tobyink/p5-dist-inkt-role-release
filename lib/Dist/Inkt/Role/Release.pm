use 5.010001;
use strict;
use warnings;

package Dist::Inkt::Role::Release;

our $AUTHORITY = 'cpan:TOBYINK';
our $VERSION   = '0.001';

use Moose::Role;
use Types::Standard -types;
use namespace::autoclean;

has should_release_on_build => ( is => "ro", isa => Bool, default => 0, init_arg => "should_release" );

sub Release
{
	my $self = shift;
	my $file = Path::Tiny::path($_[0] || sprintf('%s.tar.gz', $self->targetdir));
	
	-f $file or $self->BuildTarball($_[0]);
	
	if (system("cpan-upload", $file))
	{
		$self->log("Could not upload to CPAN!");
		die("cpan-upload failed; stopping");
	}
}

after BuildAll => sub {
	my $self = shift;
	$self->Release if $self->should_release_on_build;
};

1;

__END__

=pod

=encoding utf-8

=head1 NAME

Dist::Inkt::Role::Release - automatically upload a distrbution to the CPAN

=head1 SYNOPSIS

   distink-dist --should_release=1

=head1 BUGS

Please report any bugs to
L<http://rt.cpan.org/Dist/Display.html?Queue=Dist-Inkt-Role-Release>.

=head1 SEE ALSO

L<Dist::Inkt>

=head1 AUTHOR

Toby Inkster E<lt>tobyink@cpan.orgE<gt>.

=head1 COPYRIGHT AND LICENCE

This software is copyright (c) 2014 by Toby Inkster.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=head1 DISCLAIMER OF WARRANTIES

THIS PACKAGE IS PROVIDED "AS IS" AND WITHOUT ANY EXPRESS OR IMPLIED
WARRANTIES, INCLUDING, WITHOUT LIMITATION, THE IMPLIED WARRANTIES OF
MERCHANTIBILITY AND FITNESS FOR A PARTICULAR PURPOSE.

