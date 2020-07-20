use strict;
use warnings;
use Bio::EnsEMBL::Registry;
use List::Util qw(min max);

my $registry = 'Bio::EnsEMBL::Registry';

$registry->load_registry_from_db(
-host => 'ensembldb.ensembl.org', # alternatively 'useastdb.ensembl.org'
-user => 'anonymous'	
);

my $slice_adaptor = $registry->get_adaptor( 'Human', 'Core', 'Slice' );
my $gene_adaptor = $registry->get_adaptor( 'Human', 'Core', 'Gene' );
#my $transcript_adaptor = $registry->get_adaptor( 'Human', 'Core', 'Transcript');
#my $exon_adaptor = $registry->get_adaptor( 'Human', 'Core', 'Exon' );


if (my $slice = $slice_adaptor->fetch_by_region( 'chromosome', $ARGV[0] , $ARGV[1] , $ARGV[2]))
{
print "########## Mapping Started ########### \n";
print "- Retrieving Information from Slice \n";
my @Gene_Stable_IDs;
#my @Transcript_Stable_IDs;
#my @Exon_Stable_IDs;

foreach my $gene ( @{ $gene_adaptor->fetch_all_by_Slice($slice) } )
{
push(@Gene_Stable_IDs, $gene->stable_id());
}

#foreach my $transcript (@{ $transcript_adaptor->fetch_all_by_Slice($slice) } )
#{
#push(@Transcript_Stable_IDs, $transcript->stable_id());
#}

#foreach my $exon (@{ $exon_adaptor->fetch_all_by_Slice($slice) } )
#{
#push(@Exon_Stable_IDs, $exon->stable_id());
#}

print "@Gene_Stable_IDs \n";
#print "@Transcript_Stable_IDs \n";
#print "@Exon_Stable_IDs \n";

$registry->clear();

print "- Connecting to GRch37 Database \n";
my $registry_37 = 'Bio::EnsEMBL::Registry';

$registry_37->load_registry_from_db
(
	-host => 'ensembldb.ensembl.org', # alternatively 'useastdb.ensembl.org'
	-user => 'anonymous',
	-port => 3337
);

my $gene_adaptor_37 = $registry_37->get_adaptor( 'Human', 'Core', 'Gene' );
#my $transcript_adaptor_37 = $registry_37->get_adaptor( 'Human', 'Core', 'Transcript');
#my $exon_adaptor_37 = $registry_37->get_adaptor( 'Human', 'Core', 'Exon' );

my @tgt_start;
my @tgt_end;

if (@Gene_Stable_IDs)
{
print "- Mapping Genes \n";
foreach my $Gene_Stable_ID (@Gene_Stable_IDs){
eval
{
my $gene_37 = $gene_adaptor_37->fetch_by_stable_id($Gene_Stable_ID);
push(@tgt_start, $gene_37->seq_region_start());
push(@tgt_end, $gene_37->seq_region_end());
};
warn $@ if $@;
}
}

#if (@Transcript_Stable_IDs)
#{
#print "- Mapping Transcripts \n";
#foreach my $Transcript_Stable_ID (@Transcript_Stable_IDs){
#eval
#{
#my $transcript_37 = $transcript_adaptor_37->fetch_by_stable_id($Transcript_Stable_ID);
#push(@tgt_start, $transcript_37->seq_region_start());
#push(@tgt_end, $transcript_37->seq_region_end());
#};
#warn $@ if $@;
#}
#}

#if (@Exon_Stable_IDs)
#{
#print "- Mapping Exxons \n";
#foreach my $Exon_Stable_ID (@Exon_Stable_IDs){
#eval
#{
#my $exon_37 = $exon_adaptor_37->fetch_by_stable_id($Exon_Stable_ID);
#push(@tgt_start, $exon_37->seq_region_start());
#push(@tgt_end, $exon_37->seq_region_end());
#};
#warn $@ if $@;
#}
#}

else
{
print "Invalid chromosome/co-ordinates \n arg1->(1-22,x,y) \n arg2->(Starting_Coordinate) \n arg3->(Ending_Coordinate) \nExample : perl xxxxx.pl 12 63840524 80294266 \n";
}

else
{
print "Invalid chromosome/co-ordinates \n arg1->(1-22,x,y) \n arg2->(Starting_Coordinate) \n arg3->(Ending_Coordinate) \nExample : perl xxxxx.pl 12 63840524 80294266 \n";
}


if (@tgt_start && @tgt_end)
{
print "- Mapping co-ordinates to GRCh37 \n";
print "$ARGV[0]:", min(@tgt_start),"-", max(@tgt_end), "\n";
}
else
{
print "Region does not contain any Gene/Transcript/Exon in GRch37 assembly \n";
}
print "########## Mapping Completed ########## \n";
}

