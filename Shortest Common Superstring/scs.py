import itertools
from itertools import permutations
import collections




def readFastq(filename):
    sequences = []
    qualities = []
    with open(filename) as fh:
        while True:
            fh.readline()  # skip name line
            seq = fh.readline().rstrip()  # read base sequence
            fh.readline()  # skip placeholder line
            qual = fh.readline().rstrip() # base quality line
            if len(seq) == 0:
                break
            sequences.append(seq)
            qualities.append(qual)
    return sequences, qualities

def overlap(a, b, min_length=3):
    """ Return length of longest suffix of 'a' matching
        a prefix of 'b' that is at least 'min_length'
        characters long.  If no such overlap exists,
        return 0. """
    start = 0  # start all the way at the left
    while True:
        start = a.find(b[:min_length], start)  # look for b's suffx in a
        if start == -1:  # no more occurrences to right
            return 0
        # found occurrence; check for full suffix/prefix match
        if b.startswith(a[start:]):
            return len(a)-start
        start += 1  # move just past previous match

def scs(ss):
    """ Returns shortest common superstring of given
        strings, which must be the same length """
    shortest_sup = None
    for ssperm in itertools.permutations(ss):
        sup = ssperm[0]  # superstring starts as first string
        for i in range(len(ss)-1):
            # overlap adjacent strings A and B in the permutation
            olen = overlap(ssperm[i], ssperm[i+1], min_length=1)
            # add non-overlapping portion of B to superstring
            sup += ssperm[i+1][olen:]
        if shortest_sup is None or len(sup) < len(shortest_sup):
            shortest_sup = sup  # found shorter superstring
    return shortest_sup  # return shortest

def scs_list(ss):
    """ Returns shortest common superstring of given
        strings, which must be the same length """
    shortest_sup = []
    for ssperm in itertools.permutations(ss):
        sup = ssperm[0]  # superstring starts as first string
        for i in range(len(ss)-1):
            # overlap adjacent strings A and B in the permutation
            olen = overlap(ssperm[i], ssperm[i+1], min_length=1)
            # add non-overlapping portion of B to superstring
            sup += ssperm[i+1][olen:]
        
        shortest_sup.append(sup)  # found shorter superstring
       
        
    return (sorted(shortest_sup,key=len))  # return shortest




def pick_maximal_overlap(reads,k):
    reada,readb=None,None
    best_olen=0
    for a,b in itertools.permutations(reads,2):
        olen=overlap(a,b,min_length=k)
        if olen> best_olen:
            reada,readb=a,b
            best_olen=olen
    return reada,readb,best_olen

def greedy_scs(reads,k):
    reada,readb,olen=pick_maximal_overlap(reads,k)
    while olen>0:
        reads.remove(reada)
        reads.remove(readb)
        reads.append(reada+readb[olen:])
        reada,readb,olen = pick_maximal_overlap(reads,k)
    return ''.join(reads)



infile = 'ads1_week4_reads.fq' 

seqs,quals=readFastq(infile)
genome=greedy_scs(seqs,30)
#print(genome)
print(len(genome))
print(collections.Counter(genome))
#print(greedy_scs(seqs,30))

'''
#strings = ['ABC', 'BCA', 'CAB']
#strings = ['GAT', 'TAG', 'TCG', 'TGC', 'AAT', 'ATA']
#string= ['CCT','CTT','TGC','TGG','GAT','ATT']

a=(scs_list(string))
print(scs(string))
print((scs_list(string)))

mini=len(min(a))
#print(filter(a, lambda x: len(x)== 11))
ctr=0
for s in a:
    if (len(s)==mini):
        #print(s)
        ctr+=1
        
print(ctr)
'''
