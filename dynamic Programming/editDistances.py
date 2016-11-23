from itertools import permutations

def editDistance(x, y):
    # Create distance matrix
    D = []
    for i in range(len(x)+1):
        D.append([0]*(len(y)+1))
    # Initialize first row and column of matrix
    for i in range(len(x)+1):
        D[i][0] = i
    for i in range(len(y)+1):
        D[0][i] = 0
    # Fill in the rest of the matrix
    for i in range(1, len(x)+1):
        for j in range(1, len(y)+1):
            distHor = D[i][j-1] + 1
            distVer = D[i-1][j] + 1
            if x[i-1] == y[j-1]:
                distDiag = D[i-1][j-1]
            else:
                distDiag = D[i-1][j-1] + 1
            D[i][j] = min(distHor, distVer, distDiag)
    
    return(min(D[-1]))
    # Edit distance is the value in the bottom right corner of the matrix
    #return D[-1][-1]

def readGenome(filename):
    genome = ''
    with open(filename, 'r') as f:
        for line in f:
            # ignore header line with genome information
            if not line[0] == '>':
                genome += line.rstrip()
    return genome

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
    ctr=[]
    while True:
        start = a.find(b[:min_length], start)  # look for b's prefix in a
        if start == -1:  # no more occurrences to right
            return (0)
        # found occurrence; check for full suffix/prefix match
        if b.startswith(a[start:]):
            #ctr.append(1)
            return (len(a)-start)
        start += 1  # move just past previous match
        
        
        
def overlap_all_pairs(r,k):
    olaps=[]
    
    a=set()
    b=set()
    for a,b in permutations(set(r),2):
        
        olen= overlap(a, b, min_length=k)
        if olen >0:
            olaps.append((a,b))
    return(olaps,ctr)


reads = ['ABCDEFG', 'EFGHIJ', 'HIJABC']
print(overlap_all_pairs(reads, 3))
print(overlap_all_pairs(reads, 4))
reads = ['CGTACG', 'TACGTA', 'GTACGT', 'ACGTAC', 'GTACGA', 'TACGAT']
print(overlap_all_pairs(reads, 4))
print((overlap_all_pairs(reads, 5)))

infile = 'ERR266411_1.for_asm.fastq'  
outfile='test.fasta'


lowercase_alphabet = 'ATGC'
print(lowercase_alphabet[:2])
print(lowercase_alphabet[2:])

seqs,quals=readFastq(infile)

#p='GATTTACCAGATTGAG'

#print(editDistance(p, genome))
#occ=overlap_all_pairs(seqs, 30)
#print(occ)
#print(len(occ))
