package BioIO::Seq;
use Moose;
use Carp;
use feature qw(say);
use lib '/Users/Yatish/Desktop/Fall 2015/Programming/codes/final';
use BioIO::MyIO qw(getFh);
use BioIO::Config qw(getErrorString4WrongNumberArguments);
use Moose::Util::TypeConstraints;
use MooseX::StrictConstructor;
use namespace::autoclean();

#Attributes
has 'gi' => (
			isa => 'Int',
            is => 'rw',
			required => 1,
			);
			
has 'seq' => (
			isa => 'Str',
            is => 'rw',
			required => 1,
			);
has 'def' => (
			isa => 'Str',
            is => 'rw',
			required => 1,
			);
has 'accn' => (
			isa => 'Str',
            is => 'rw',
			required => 1,
			);			
	
sub writeFasta{
	my ($self,$outfile,$width) = @_;
	my $filledUsage = 'Usage: ' . (caller(0))[3] . '($self,$outfile,$width)';
    @_ == 3 or @_==2 or confess getErrorString4WrongNumberArguments(), $filledUsage;
    
	if(!defined($width)){
		$width=70;
	}
	my $fhOut = getFh('>',$outfile);
	my $len = length($self->seq);
	my $def =$self->def;
	$def=~s/\n//g;
	$def=~s/\s\s+/ /g;
	$def=~s/\.//g;
	say $fhOut (">gi|",$self->gi,"|ref",$self->accn,"|",$def);
	my $str = $self->seq;
	my $s;
	say $fhOut "$s" while $s = substr $str, 0, $width, '';
}

sub subSeq{
	my($self,$begin,$end)=@_;
	my $filledUsage = 'Usage: ' . (caller(0))[3] . '($self,$begin,$end)';
    @_ == 3 or confess getErrorString4WrongNumberArguments(), $filledUsage;
    
	my $seq = $self->seq;
	$seq=~s/\n//g;
	my $subSeq;
	if(!defined($begin) || !defined($end)){
		die "Begin and end are not defined , $!";
	}
	elsif ($begin-1 < 0 || $begin > length($seq) || $end < 0 || $end > length($seq)){
		die "Either Begin or end lies outside the length of a sequence, $!";
	}
	else{
		$subSeq = substr($seq,$begin-1,($end-$begin+1));
	}
	
	my $seqObj = BioIO::Seq->new(gi =>$self->gi, seq =>$subSeq, def =>$self->def, accn =>$self->accn);
	return($seqObj);
}

sub checkCoding{
	my($self)=@_;
	my $filledUsage = 'Usage: ' . (caller(0))[3] . '($self)';
    @_ == 1 or confess getErrorString4WrongNumberArguments(), $filledUsage;
    
	my $seq=$self->seq;
	
	if(substr($seq,0,3) =~ /ATG/ && substr($seq,length($seq)-3,length($seq)) =~ /(TAA|TAG|TGA)/){
		return 1;
	}else{
		return;
	}
}


sub checkCutSite{
	my($self,$pattern)= @_;
	my $filledUsage = 'Usage: ' . (caller(0))[3] . '($self,$pattern)';
    @_ == 2 or confess getErrorString4WrongNumberArguments(), $filledUsage;
    
	my $origPattern = $pattern;
	my $matchedSeq;
	
	if($pattern=~/r/ig ){
		$pattern=~s/r/[A|G]/ig;	
	}
	if($pattern=~/y/ig ){
		$pattern=~s/y/[C|T]/ig;
	}
	if($pattern=~/n/ig ){
		$pattern=~s/n/[A|T|G|C]/ig;
	}
	
	
	my $seq = $self->seq;
	
	my $position;
	if($seq=~/$pattern/ig){
		$position = ($-[0]+1);
		$matchedSeq =$&;
		#$matchedSeq = substr $seq,$position-1,length($origPattern);
	}
	if(defined($position)){
		return($position,$matchedSeq);
	}else{
		return(undef,undef);
	}
}			
1;			