package App::Scaffolder::Command::puppetmodule;
{
  $App::Scaffolder::Command::puppetmodule::VERSION = '0.001001';
}
use parent qw(App::Scaffolder::Command);

# ABSTRACT: Scaffold a Puppet module

use strict;
use warnings;

use MRO::Compat;
use Path::Class::Dir;



sub get_target {
	my ($self, $opt) = @_;
	return Path::Class::Dir->new($opt->target() || $opt->name());
}



sub get_variables {
	my ($self, $opt) = @_;
	return {
		name => scalar $opt->name(),
	};
}



sub get_dist_name {
	return 'App-Scaffolder-Puppet';
}



sub get_options {
	my ($class) = @_;
	return (
		[ 'name|n=s' => 'Name of the new Puppet module that should be created' ],
	);
}


sub validate_args {
	my ($self, $opt, $args) = @_;

	$self->next::method($opt, $args);
	unless ($self->contains_base_args($opt) || $opt->name()) {
		$self->usage_error("Parameter 'name' required");
	}
	return;
}



sub get_extra_template_dirs {
	my ($self, $command) = @_;

	my $template_dir_name = 'scaffolder_templates';
	my @extra_template_dirs = grep { -d $_ && -r $_ } (
		Path::Class::Dir->new('', 'etc', 'puppet', $template_dir_name),
		Path::Class::Dir->new('', 'usr', 'local', 'etc', 'puppet', $template_dir_name),
	);

	return (
		$self->next::method($command),
		@extra_template_dirs,
	);
}



1;


__END__
=pod

=head1 NAME

App::Scaffolder::Command::puppetmodule - Scaffold a Puppet module

=head1 VERSION

version 0.001001

=head1 SYNOPSIS

	# Create scaffold to install the 'vim' package:
	$ scaffolder puppetmodule --template package --name vim

	# Create scaffold to install the 'apache2' package and setup the corresponding service:
	$ scaffolder puppetmodule --template service --name apache2

=head1 DESCRIPTION

App::Scaffolder::Command::puppetmodule scaffolds Puppet modules. By default, it
provides two simple templates:

=over

=item *

C<package>: Create Puppet module to install a package.

=item *

C<service>: Create Puppet module to setup a service.

=back

In addition to the default template search path (see
L<App::Scaffolder|App::Scaffolder> for details), this command will also look for
templates in C</etc/puppet/scaffolder_templates> or
C</usr/local/etc/puppet/scaffolder_templates> if they exist.

=head1 METHODS

=head2 get_target

Specialized C<get_target> version which uses the name if no target was given.

=head2 get_variables

Specialized C<get_variables> version which returns the name of the module.

=head2 get_dist_name

Return the name of the dist this command is in.

=head2 get_options

Return additional options for this command.

=head2 get_extra_template_dirs

Extend the template search path with C</etc/puppet/scaffolder_templates> or
C</usr/local/etc/puppet/scaffolder_templates> if they exist.

=head3 Result

The extended list with template directories.

=head1 SEE ALSO

=over

=item *

L<https://puppetlabs.com/puppet/puppet-open-source> - Puppet

=item *

L<http://docs.puppetlabs.com/puppet/2.7/reference/modules_fundamentals.html> - Module Fundamentals

=back

=head1 AUTHOR

Manfred Stock <mstock@cpan.org>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2014 by Manfred Stock.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut

