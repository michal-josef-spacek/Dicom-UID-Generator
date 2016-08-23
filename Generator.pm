package Dicom::UID::Generator;

# Pragmas.
use strict;
use warnings;

# Modules.
use Class::Utils qw(set_params);
use DateTime::HiRes;
use English;
use Readonly;

# Version.
our $VERSION = 0.01;

# Constants.
Readonly::Scalar our $EMPTY_STR => q{};

# Constructor.
sub new {
	my ($class, @params) = @_;

	# Create object.
	my $self = bless {}, $class;

	# Library number.
	$self->{'library_number'} = undef;

	# Model number.
	$self->{'model_number'} = undef;

	# Serial number.
	$self->{'serial_number'} = undef;

	# UID counter.
	$self->{'uid_counter'} = 0;

	# Process parameters.
	set_params($self, @params);

	return $self;
}

# Create series instance UID.
sub create_series_instance_uid {
	my $self = shift;
	return $self->create_uid($self->_root_uid.'.1.3');
}

# Create SOP instance UID.
sub create_sop_instance_uid {
	my $self = shift;
	return $self->create_uid($self->_root_uid.'.1.4');
}

# Create study instance UID.
sub create_study_instance_uid {
	my $self = shift;
	return $self->create_uid($self->_root_uid.'.1.2');
}

# Create UID.
sub create_uid {
	my ($self, $prefix) = @_;
	my $uid = $prefix;
	$uid .= '.'.$PID;
	$uid .= '.'.DateTime::HiRes->now->set_time_zone('Europe/Prague')->strftime('%Y%m%d%H%M%S%3N');
	$self->{'uid_counter'}++;
	$uid .= '.'.$self->{'uid_counter'};
	return $uid;
}

# Add part of UID.
sub _add_part {
	my ($self, $uid_part_sr, $part) = @_;
	if (defined $self->{$part}) {
		if (${$uid_part_sr} ne $EMPTY_STR) {
			${$uid_part_sr} .= '.';
		}
		${$uid_part_sr} .= $self->{$part};
	}
	return;
}

# Get root UID.
sub _root_uid {
	my $self = shift;
	my $uid_part = $EMPTY_STR;
	$self->_add_part(\$uid_part, 'library_number');
	$self->_add_part(\$uid_part, 'model_number');
	$self->_add_part(\$uid_part, 'serial_number');
	return $uid_part;
}

1;

__END__
