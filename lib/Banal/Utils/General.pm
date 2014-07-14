#===============================================
package Banal::Utils::General;

use utf8;
require Exporter;
no warnings;

use Data::Dumper;

@ISA = qw(Exporter);
@EXPORT_OK = qw(load_class run_cmd run_perl debug_dump_vars);

#----------------------------------
# Function, not a method!
#----------------------------------
sub load_class {
	my $oclass		= shift;
	my $prefixes	= shift || [''];
	my $opts		= shift || {};
	
	my $verbose		= $opts->{verbose} || 0;
	my $on_fail		= $opts->{on_fail} || 'warn';

	my $class;
	
	foreach my $pfx (@$prefixes) {
		$class = $pfx . $oclass;
		if (eval "require ($class);") {	
			warn "load_class => Just required class '$class'\n";
			return $class;
		} else {
			if ($verbose >= 6) {
				my $msg = "load_class  => Tried to load(require) class '$oclass' via package name '$class' without any luck. Oh well. Next time perhaps.\n";
			
				print STDERR $msg;
			} 
		}
	}	
	
	if ($on_fail) {
		my $msg = "load_class  => Unable to load(require) class '$oclass'\n";
	
		print STDERR 	$msg if ($on_fail =~ /^print$/i);
		warn 			$msg if ($on_fail =~ /^warn$/i);
		die  			$msg if ($on_fail =~ /^die$/i);
	}
	
	return;
}


##############################################################################"
# Utility functions
##############################################################################"

#-------------------------------------------------------------
sub run_cmd {
	my ($opts, $cmd) 	= @_;
	my $verbose 		= $opts->{verbose} || $opts->{debug};
	my $dryrun			= $opts->{dryrun};
	my $prompt			= $dryrun ? 'sys  would >  ' : 'sys  cmd >  ';
	return unless $cmd;
	
	print $prompt . $cmd . "\n" if $verbose;	
	
	my $output;
	unless ($dryrun) 	{	$output = `$cmd`;													}
	else 				{ 	$output = $dryrun ? 'Command NOT executed (dry-run mode)' : eval($cmd); }
	
	print "$output\n" if ($output && $verbose > 5);	
	
}

#-------------------------------------------------------------
sub run_perl {
	my ($opts, $cmd) 	= @_;
	my $verbose 		= $opts->{verbose} || $opts->{debug};
	my $dryrun			= $opts->{dryrun};
	my $prompt			= $dryrun ? 'perl would >  ' : 'perl cmd >  ';
	
	return unless $cmd;
	
	print $prompt . $cmd . "\n" if $verbose;
	
	my $output;
	unless ($dryrun) 	{	$output = eval($cmd);													}
	else 				{ 	$output = $dryrun ? 'Command NOT executed (dry-run mode)' : eval($cmd); }
	
	print "$output\n" if ($output && $verbose > 5);	
}

#---------------------------------
sub debug_dump_vars {
		my $msg = shift;
		 
		print STDERR "$msg:DUMP:\n";
		$Data::Dumper::Sortkeys = 1;
		print STDERR Data::Dumper->Dump([@_]);	
}

1;


__END__

=head1 NAME

Banal::Utils::General - General purpose totally banal and trivial utilities.


=head1 SYNOPSIS

    use Banal::Utils::General qw(load_class run_cmd run_perl debug_dump_vars);
    
    ...

=head1 EXPORT

None by default.

=head1 EXPORT_OK

load_class 
run_cmd 
run_perl 
debug_dump_vars


=head1 SUBROUTINES / FUNCTIONS

=head2 load_class($class_name [, $prefixes, $opts])

Given a class name, attempts to load it via require. If given a list of prefixes, this routine will try to load the class with each prefix until success or until the list of prefixes is exhausted.

RETURNS the actual class name (with the eventual prefix) on success, nothing (undef or empty list, depending on the calling context) otherwise.

OPTIONS ($opts):
	on_fail		:  	warn|die|print|ignore
					Can optionally "die" or "warn" (the default) or print an error message (on STDERR) on failure.
					Any other value will simply be ignored.

	verbose		:  	0 (slient) .. 9 (most verbose)
					Print messages (on STDERR) of various levels of verbosity during different stages of the routine. 


=head2 run_cmd ($opts, $cmd)

Execute a system command (given by $cmd) via the backtick (`) operator and return the result.

Can also be called in simulation mode (with the "dry_run" option set) which will cause the routine to simply return a string that describes what would have been done in a real (non-simulation) call, without actually doing anything.


=head2 run_perl ($opts, $cmd)

Evaluate a perl expression (given by $cmd) via the "eval" operator and return the result.

Can also be called in simulation mode (with the "dry_run" option set) which will cause the routine to simply return a string that describes what would have been done in a real (non-simulation) call, without actually doing anything.


=head2 debug_dump_vars ($msg, ...)

Uses Data::Dumper to print (on STDERR) a message (given by $msg) followed by the array of the rest of its arguments. 


=head1 AUTHOR

"aulusoy", C<< <"dev (at) ulusoy.name"> >>

=head1 BUGS

Please report any bugs or feature requests to C<bug-banal-utils at rt.cpan.org>, or through
the web interface at L<http://rt.cpan.org/NoAuth/ReportBug.html?Queue=Banal-Utils>.  I will be notified, and then you'll
automatically be notified of progress on your bug as I make changes.




=head1 SUPPORT

You can find documentation for this module with the perldoc command.

    perldoc Banal::Utils::File


You can also look for information at:

=over 4

=item * RT: CPAN's request tracker (report bugs here)

L<http://rt.cpan.org/NoAuth/Bugs.html?Dist=Banal-Utils>

=item * AnnoCPAN: Annotated CPAN documentation

L<http://annocpan.org/dist/Banal-Utils>

=item * CPAN Ratings

L<http://cpanratings.perl.org/d/Banal-Utils>

=item * Search CPAN

L<http://search.cpan.org/dist/Banal-Utils/>

=back


=head1 ACKNOWLEDGEMENTS


=head1 LICENSE AND COPYRIGHT

Copyright 2014 "aulusoy".

This program is free software; you can redistribute it and/or modify it
under the terms of the the Artistic License (2.0). You may obtain a
copy of the full license at:

L<http://www.perlfoundation.org/artistic_license_2_0>

Any use, modification, and distribution of the Standard or Modified
Versions is governed by this Artistic License. By using, modifying or
distributing the Package, you accept this license. Do not use, modify,
or distribute the Package, if you do not accept this license.

If your Modified Version has been derived from a Modified Version made
by someone other than you, you are nevertheless required to ensure that
your Modified Version complies with the requirements of this license.

This license does not grant you the right to use any trademark, service
mark, tradename, or logo of the Copyright Holder.

This license includes the non-exclusive, worldwide, free-of-charge
patent license to make, have made, use, offer to sell, sell, import and
otherwise transfer the Package with respect to any patent claims
licensable by the Copyright Holder that are necessarily infringed by the
Package. If you institute patent litigation (including a cross-claim or
counterclaim) against any party alleging that the Package constitutes
direct or contributory patent infringement, then this Artistic License
to you shall terminate on the date that such litigation is filed.

Disclaimer of Warranty: THE PACKAGE IS PROVIDED BY THE COPYRIGHT HOLDER
AND CONTRIBUTORS "AS IS' AND WITHOUT ANY EXPRESS OR IMPLIED WARRANTIES.
THE IMPLIED WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR
PURPOSE, OR NON-INFRINGEMENT ARE DISCLAIMED TO THE EXTENT PERMITTED BY
YOUR LOCAL LAW. UNLESS REQUIRED BY LAW, NO COPYRIGHT HOLDER OR
CONTRIBUTOR WILL BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, OR
CONSEQUENTIAL DAMAGES ARISING IN ANY WAY OUT OF THE USE OF THE PACKAGE,
EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.


=cut

1; # End of Banal::Utils::General


