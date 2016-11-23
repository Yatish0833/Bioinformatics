
from bm_preproc import BoyerMoore
from kmer_index import Index
from subSeq import SubseqIndex


def boyer_moore(p, p_bm, t):
    """ Do Boyer-Moore matching. p=pattern, t=text,
        p_bm=BoyerMoore object for p """
    i = 0
    occurrences = []
    while i < len(t) - len(p) + 1:
        shift = 1
        mismatched = False
        for j in range(len(p)-1, -1, -1):
            if p[j] != t[i+j]:
                skip_bc = p_bm.bad_character_rule(j, t[i+j])
                skip_gs = p_bm.good_suffix_rule(j)
                shift = max(shift, skip_bc, skip_gs)
                mismatched = True
                break
        if not mismatched:
            occurrences.append(i)
            skip_gs = p_bm.match_skip()
            shift = max(shift, skip_gs)
        i += shift
    return occurrences



def boyer_moore_with_counts(p, p_bm, t):
    """ Do Boyer-Moore matching. p=pattern, t=text,
        p_bm=BoyerMoore object for p """
    i = 0
    occurrences = []
    numAlign=0
    numchar=0
    while i < len(t) - len(p) + 1:
        shift = 1
        numAlign+=1
        mismatched = False
        for j in range(len(p)-1, -1, -1):
            numchar+=1
            if p[j] != t[i+j]:
                skip_bc = p_bm.bad_character_rule(j, t[i+j])
                skip_gs = p_bm.good_suffix_rule(j)
                shift = max(shift, skip_bc, skip_gs)
                mismatched = True
                break
        if not mismatched:
            occurrences.append(i)
            skip_gs = p_bm.match_skip()
            shift = max(shift, skip_gs)
        i += shift
    return (occurrences,numAlign,numchar)


def readGenome(filename):
    genome = ''
    with open(filename, 'r') as f:
        for line in f:
            # ignore header line with genome information
            if not line[0] == '>':
                genome += line.rstrip()
    return genome


def approximate_match(p,t,n):
    segment_length= int(round(len(p)/(n+1)))
    all_matches=set()
    matchcount=0
    for i in range(n+1):
        start=i*segment_length
        end=min((i+1)*segment_length,len(p))
        p_index=Index(t,8)
        matches=p_index.query(p[start:end])
        #print(len(matches))
        matchcount+= len(matches)
        
        for m in matches:
            if m < start or m-start+len(p) > len(t):
                continue
            mismatches=0
            for j in range(0,start):
                if not p[j]== t[m-start+j]:
                    mismatches+=1
                    if mismatches > n:
                        break
            for j in range(end, len(p)):
                if not p[j]== t[m-start+j]:
                    mismatches+=1
                    if mismatches >n:
                        break
            if mismatches <=n:
                all_matches.add(m-start)
                
    return(list(all_matches),matchcount)


def approximate_match_with_subSeq(p,t,p_index,n):
    segment_length= int(round(len(p)/(n+1)))
    all_matches=set()
    matchcount=0
    for i in range(3):
        start=i*segment_length
        end=min((i+1)*segment_length,len(p))
        
        matches=p_index.query(p[i:])
        matchcount+= len(matches)
        
        for m in matches:
            if m < start or m-start+len(p) > len(t):
                continue
            mismatches=0
            for j in range(0,start):
                if not p[j]== t[m-start+j]:
                    mismatches+=1
                    if mismatches > n:
                        break
            for j in range(end, len(p)):
                if not p[j]== t[m-start+j]:
                    mismatches+=1
                    if mismatches >n:
                        break
            if mismatches <=n:
                all_matches.add(m-start)
                
    return(list(all_matches),matchcount)
 


infile = 'chr1.GRCh38.excerpt.fasta'  
outfile='test.fasta'


lowercase_alphabet = 'ATGC'

genome=readGenome(infile)

p = 'GGCGCGGTGGCTCACGCCTGTAAT'
occ,match=approximate_match(p,genome,2)
print(len(occ),match)


#t = 'to-morrow and to-morrow and to-morrow creeps in this petty pace'
#p = 'GGCGCGGTGGCTCACGCCTGTAAT'
#subseq_ind = SubseqIndex(genome, 8, 3)
#print(subseq_ind.query(p[2:]))


#occurrences, num_index_hits = approximate_match_with_subSeq(p, genome,subseq_ind, 2)
#print(occurrences)
#print(num_index_hits)


