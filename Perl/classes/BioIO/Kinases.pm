package BioIO::Kinases;
use warnings;
use strict;
use feature qw(say);
use Carp qw(confess);
#use lib '/Users/Yatish/Desktop/Fall\ 2015/Programming/codes/assignment7';
#use BioIO::Config qw(getErrorString4WrongNumberArguments);
#use BioIO::MyIO qw(getFh);
use Data::Dumper;




#-------------------------------------------------------------------------------
# scalar context: $kinaseObj = BioIO::Kinases->new($fileInName);
#-------------------------------------------------------------------------------
# new is a constructor, when you build a new obj, it calls _readKinases.
# The object has two attributes 'aoh' which stores an Array of Hashes, and numberOfKinases
# Which is the number of kinases stores in the object
#-------------------------------------------------------------------------------
sub new{
	my ($class, $file) = @_;
	my $filledUsage = 'Usage: ' . (caller(0))[3] . '($class, $file)';
    @_ == 2 or confess getErrorString4WrongNumberArguments(), $filledUsage;
    my $aoh;
    if ( defined $file ) {
        $aoh = _readKinases($file); # private class method used to create the array of hashes
    }
    
    return bless( {
    			        _aoh 		    => $aoh,
    			        _numberOfKinases => scalar @$aoh,
    			      }, $class  
    			    );
    
}

#-------------------------------------------------------------------------------
# scalar context (reference to an array of hashes) $aoh = _readKinases($fileInName)
#-------------------------------------------------------------------------------
# _readKinases receives a file containing kinase info. It goes through the
# field, creates an AoH, where each hash contains the kinase info for one line.
# It then returns a reference to the AoH
#------------------------------------------------------------------------------

sub _readKinases{
	my ($fhIn)= @_;
	my $filledUsage = 'Usage: ' . (caller(0))[3] . '($file)';
    @_ == 1 or confess getErrorString4WrongNumberArguments(), $filledUsage;
    my @aoh;
	
	while(my $line = <$fhIn>){
		chomp $line;
		my $hash = {};
		my ($symbol, $name, $date, $location, $omim_accession) = split /\|/, $line; 
		$hash->{"symbol"}=$symbol;
		$hash->{"name"}=$name;
		$hash->{"date"}=$date;
		$hash->{"location"}=$location;
		$hash->{"omim_accession"}=$omim_accession;
		push @aoh, $hash;
		
	}
	return(\@aoh);
}

#-------------------------------------------------------------------------------
# void context $kinaseObj->printKinases($fileOutName, ['symbol', 'name', 'location']);
# void context $kinaseObj->printKinases($fileOutName, ['symbol', 'name', 'location', 'omim_accession']);
#-------------------------------------------------------------------------------
# printKinases receives 2 args: a filename indicating output, and reference to an array, that's a 
# list of fields. It prints all the kinases in a Kinases object, according to the
# requested list of keys.
#-------------------------------------------------------------------------------
sub printKinases{
	my ($self, $fhOut, $refArrFields) = @_;
	my $filledUsage = 'Usage: ' . (caller(0))[3] . '($self, $fhOut, $refArrFields)';
    @_ == 3 or confess getErrorString4WrongNumberArguments(), $filledUsage;
	
	foreach my $item (@{ $self->getAoh }) {
		foreach my $ele (@$refArrFields){
			if (exists $item->{$ele}){
				print $fhOut $item->{$ele},"\t";
			}else{
				 confess "Invalid value name '" , $ele, "'";
			}
		}
		print $fhOut "\n";
	}
	
}

#-------------------------------------------------------------------------------
# scalar context(Kinases Object) $kinaseObj2 = $kinaseObj->filterKinases( { name=>'tyrosine' } );
# scalar context(Kinases Object) $kinaseObj2 = $kinaseObj->filterKinases( { name=>'tyrosine', symbol=>'EPLG4' } );
#-------------------------------------------------------------------------------
# filterKinases receives a hash reference with field-criterion for filtering the Kinases of
# interest. It returns a new Kinases object which contains the kinases meeting the requirement (filter parameters)
# passed into the method.  This method must us named parameters, since you could
# pass any of the keys to the hashes found in the AOH: symbol, name, location, date, omim_accession.
# If no filters are passed in, then it would just return another Kinases object with all the same entries
# This could be used to create an exact copy of the object. Remember, creating a exact copy of an object, requires
# a new object with new data, you can't just create a copy, i.e. $kinaseObj2 = $kinaseObj would not work.
#-------------------------------------------------------------------------------
sub filterKinases{
	my ($self,$refHash)=@_;
	my $filledUsage = 'Usage: ' . (caller(0))[3] . '($self,$refHash)';
    @_ == 2 or confess getErrorString4WrongNumberArguments(), $filledUsage;

	my %hash;
    my @filteredAoh;
    while (my ($key,$value) = each (%$refHash)){
    	foreach my $item (@{ $self->getAoh }){
    		if($item->{$key}=~ /\b$value\b/i){
    			push @filteredAoh,$item;
    		}
    	}
    }
    
    bless( {
    			        _aoh 		    => \@filteredAoh,
    			        _numberOfKinases => scalar @filteredAoh,
    			      }, ref($self)
    			    );
  
}

#-------------------------------------------------------------------------------
# array context foreach my $item (@{ $self->getAoh }){
#-------------------------------------------------------------------------------
# accessor function to access the attribut _aoh of any object instance
#-------------------------------------------------------------------------------
sub getAoh{
	my ($self) = @_;
	my $filledUsage = 'Usage: ' . (caller(0))[3] . '($self)';
    @_ == 1 or confess getErrorString4WrongNumberArguments(), $filledUsage;
    
    return($self->{_aoh});
}
#-------------------------------------------------------------------------------
# scalar context my $num = $kinaseObj->getNumberOfKinases();
#-------------------------------------------------------------------------------
# accessor function to access the attribut _numberOfKinases of any object instance
#-------------------------------------------------------------------------------
sub getNumberOfKinases{
	my ($self) = @_;
	my $filledUsage = 'Usage: ' . (caller(0))[3] . '($self)';
    @_ == 1 or confess getErrorString4WrongNumberArguments(), $filledUsage;
    
    return($self->{_numberOfKinases});
}

#-------------------------------------------------------------------------------
# hash context $kinaseObj->getElementInArray('name')
#-------------------------------------------------------------------------------
# accessor function to access any element in array of hash
#-------------------------------------------------------------------------------
sub getElementInArray{
	my ($self,$arrIndex)=@_;
	my $filledUsage = 'Usage: ' . (caller(0))[3] . '($self,$arrIndex)';
    @_ == 2 or confess getErrorString4WrongNumberArguments(), $filledUsage;
    
    foreach my $item (@{ $self->getAoh }){
    	if(exists($item->{$arrIndex})){
    		return($item);
    	}else{
    		return;
    	}
    }
}
1;
