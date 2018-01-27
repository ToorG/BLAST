#!/pkg/bin/perl -w
use diagnostics;  # this will generate more complete explanations of any errors
#
#program kmer4.pl
#This program expands on kmer2.pl which expands on kmer1.pl which expands
#on kmer.pl.
# This program finds all the overlapping k-mers of the input string. It builds
# an associative array where each key is one distinct k-mer in the string,
# and the associated value is a list of starting positions where that
#k-mer is found. For example, if the input is ACACTCA and k is 2, then
#one key is AC with a list of 1,3; another key is CA with a list of 2,6;
#another key is CT with a list of 4; and one key is TC with a list of 5.
#
#Note the use of derefrencing in order to build up each array in
#the hash of arrays, and its use again to join the array into a string for
#printing a comma seperated list.
#dg


print "Enter the name of the Q file containing the sequence:\n";
$filename1=<>;
open(IN, $filename1);
$dna = <IN>;
chomp $dna;
$dna_ori=$dna;
print "dna is $dna \n";
@Qstring =split(//, $dna_ori);  ##turn string into char array

print "Input the length of the window for Q: \n"; 
$k = <>;
chomp $k;

# %kmer = ();
$i = 1;
while (length($dna) >= $k) {
  $dna =~ m/(.{$k})/; 
 # print "$1, $i \n";
   if (! defined $kmer{$1}) {
    $kmer{$1} = [$i];    # here we tell Perl that the value of a kmer entry will
                         # be an array. This is done by enclosing $i with [ ].
                         # More correctly, $kmer{$1} is a reference to an array
                         # whose first value is the value of $i.
   }
 else { push (@{$kmer{$1}}, $i)}  # here we expand the array associated with key
                                  # value $1 by adding another
                                  # element to the array.  We first have to dereference
                                  # the reference $kmer{$1} which is done by enclosing
                                  # it with curly brackets.

  $i++;
  $dna = substr($dna, 1, length($dna) -1);
}

close(IN);

print "Enter the name of the S file containing the sequence:\n";
$filename2=<>;
open(IN, $filename2); #for easy testing
print "Input the lenght of the window for S: \n";
$ks=<>;
chomp $ks;
$orderOfLine=0;
$/ = "";

while ($s = <IN>)
{
	$s=~s/\n//g;
	$is=1;
	$orderOfLine+=1;
	$s_ori=$s;
	@Sstring =split(//, $s_ori);  #turn string into char array
	$count = 0;

	while (length($s) >= $ks) {
    $s =~ m/(.{$ks})/; 
    #print "$1, $i \n";
		if (defined $kmer{$1} && !defined($stringhash{$is-1}))
		{ 	foreach $position (@{$kmer{$1}})
			{
			  #print "$string\n";
				$posQ=$position;
				$posS=$is;
				#extending to the left
	 
			  $indexQLeft = $posQ - 1;
			  $indexSLeft = $posS-1;

			 
			  while ($indexQLeft >=0 && $indexSLeft>=0 && ($Qstring[$indexQLeft] eq $Sstring[$indexSLeft] ) )
			  {
				$indexQLeft--;
				$indexSLeft--;
			  }
			  $indexQRight = $posQ+($ks-1)-1;
			  $indexSRight = $posS+($ks-1)-1;

			  while ($indexQRight <=(length($dna_ori)-1) && $indexSRight <=(length($s_ori)-1)&& ($Qstring[$indexQRight] eq $Sstring[$indexSRight] ))
			  {
				$indexQRight++;
				$indexSRight++;
	 
			  }
				$L=($indexQRight-1)-($indexQLeft+1)+1;
				if ($L>=10)
			    {
					for($i=($indexSLeft+1); $i<=($indexSRight-1)-$k+1;$i++)
					{
						$stringhash{$i}=$i;
					}
					$count+=1;
					$HSP=substr($dna_ori, $indexQLeft+1,$L);
					print "HSP: $HSP, with length: $L\n";
				}
			}
			
		}
			$s=substr($s,1,length($s)-1);
			$is++;
	}
   
   #print("for $orderOfLine-the string is S, we found the above $count HSP\n\n")
   
}
close(IN);

