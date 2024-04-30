## This script makes pairs of orthologs and paralogs from orthofinder orthogroups.txt
import sys
import os
import shutil
import itertools
import re

# inputs
species_file = sys.argv[1]

#.txt
orthogroup_file = sys.argv[2]

# make paralogs and orthologs directories
CURRENT_DIR = os.getcwd()

PARALOGS_path = CURRENT_DIR + "/paralogs/"
if not os.path.exists(PARALOGS_path):
    os.makedirs(PARALOGS_path)
else:
    shutil.rmtree(PARALOGS_path)
    os.makedirs(PARALOGS_path)
    
ORTHOLOGS_path = CURRENT_DIR + "/orthologs/"
if not os.path.exists(ORTHOLOGS_path):
    os.makedirs(ORTHOLOGS_path)
else:
    shutil.rmtree(ORTHOLOGS_path)
    os.makedirs(ORTHOLOGS_path)

# species list get all pairwise including within
species_list = []
with open(species_file, 'r') as SF:
    for S in SF:
        species_list.append(S.strip('\n'))
        
pairs = list(itertools.product(species_list, species_list))


for P in pairs:
    # paralog pairs
    if P[0] == P[1]:
        with open(PARALOGS_path+P[0] + "_" + P[1] + "_paralogs.tsv", 'w') as PARA_OUT:
            print("Running paralog " + P[0] + " and " + P[1])
            with open(orthogroup_file, 'r') as OF:
                for OG in OF:
                    OG = OG.split(" ")
                    all = []
                    for G in OG:
                        G = G.strip('\n')
                        if P[0] in G:
                            all.append(G.strip('\n'))
                    for a in range(1,len(all)):
                        PARA_OUT.write(all[0]+"\t"+all[a]+"\n")
                    
    # ortholog pairs
    elif P[0] != P[1]:
        with open(ORTHOLOGS_path+P[0] + "_" + P[1] + "_orthologs.tsv", 'w') as ORTH_OUT:
            print("Running orthologs " + P[0] + " and " + P[1])
            with open(orthogroup_file, 'r') as OF:
                for OG in OF:
                    if OG.startswith("OG"):
                        OG = OG.replace(",", "").replace('\t', " ")
                        OG = OG.split(" ")
                        SP_1 = []
                        SP_2 = []
                        for G in OG:
                            G = G.strip('\n')
                            G = G.strip(',')
                            if P[0] in G:
                                SP_1.append(G)
                            if P[1] in G:
                                SP_2.append(G)
                        SP_all = list(itertools.product(SP_1, SP_2))
                        for SP in SP_all:
                            new_SP = []
                            if SP[0] != SP[1]:
                                new_SP.append(SP)
                                ORTH_OUT.write(SP[0]+"\t"+SP[1]+"\n")


