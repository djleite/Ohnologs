# This wrapper runs the orthofinder and ohnolog pipelines
# It iterates over the orthofinder inflation parameter


eval "$(conda shell.bash hook)"

PIPELINE='/working/dir/for/the/pipeline'

# inflation parameter for orthofinder
for i in 1.4 1.5 1.6

do

# make the base directory
mkdir run_${i}

# copy the raw pipeline
cp -r raw_pipeline/* run_${i}

# cd to working directory
cd run_${i}

printf "#################################\n#################################\n######## running iter ${i} #########\n\n"
printf "########### step orthology"
# run orthology
orthofinder.py -I ${i} -f ${PIPELINE}/run_${i}/fastas -t 30 -o ${PIPELINE}/run_${i}/orthofinder

printf "########### step make files"
# make the paralogs and ortholog files
# use the personal script to get pairs of orthologs and paralogs
python get_pairs.py ${PIPELINE}/run_${i}/species_list.txt ${PIPELINE}/run_${i}/orthofinder/*/Orthogroups/Orthogroups.txt

# start ohnolog prediction pipeline

# I made a conda env called ohnologs that all the Perl dependencies are installed
conda activate ohnologs

printf "########### step 1\n"
#make dirs
cd ${PIPELINE}/run_${i}/2_ParameterFiles/
perl create_parameters.pl

printf "########### step 2\n"
#make dirs
cd ${PIPELINE}/run_${i}/3_SyntenyOutputFiles
perl create_output-dirs.pl

printf "########### step 3\n"
#run first step
cd ${PIPELINE}/run_${i}/1_SyntenyScripts/
perl OHNOLOGS_OutgroupComparison_CL.pl '../2_ParameterFiles/CARROT/outgroup' '../3_SyntenyOutputFiles/CARROT/outgroup' 2>&1 | tee CARROT_og.log &
perl OHNOLOGS_OutgroupComparison_CL.pl '../2_ParameterFiles/TACGIG/outgroup' '../3_SyntenyOutputFiles/TACGIG/outgroup' 2>&1 | tee TACGIG_og.log &

perl OHNOLOGS_SelfComparison_CL.pl '../2_ParameterFiles/CARROT/self' '../3_SyntenyOutputFiles/CARROT/self' 2>&1 | tee CARROT_self.log &
perl OHNOLOGS_SelfComparison_CL.pl '../2_ParameterFiles/TACGIG/self' '../3_SyntenyOutputFiles/TACGIG/self' 2>&1 | tee TACGIG_self.log &


wait


printf "########### step 4\n"
#combine windows
cd ${PIPELINE}/run_${i}/4_CombineWindows
perl 0_create_dirs.pl
perl 1_CombinePairsFromDifferentWindows_Self_All.pl
perl 2_CombinePairsFromDifferentOutgroupWindow_All.pl
perl 3_CombinePairsFromDifferentOutgroup_All.pl


printf "########### step 5\n"
cd ${PIPELINE}/run_${i}/5_CombineSelfOutgroup
perl 0_create_dirs.pl 
perl 1_CombinePairs_Outgroups_and_Self_All.pl

printf "########### step 6\n"
cd ${PIPELINE}/run_${i}/6_CombineAllVertebrates
Rscript spiders_weights.R
perl 0_create_dirs.pl
perl 1_Combine_OhnoPairs_AllSpiders_mp_v2.pl
perl 2_getGeoMean_spiders_2R_weighted-mean.pl
perl 3_filterWithinWindows.pl

printf "########### step 7\n"
cd ${PIPELINE}/run_${i}/7_FilterOhnologs
perl 0_create_dirs.pl
perl Generate_Criteria-\[0\]-Pairs.pl
perl Generate_Criteria-\[A\]-Pairs.pl
perl Generate_Criteria-\[B\]-Pairs.pl
perl Generate_Criteria-\[C\]-Pairs.pl

printf "########### step 8\n"
cd ${PIPELINE}/run_${i}/8_GenerateOhnoFamilies
perl 0_create_dirs.pl
for s in CARROT TACGIG
	do
	for x in 0 A B C
		do
		perl 1_DepthFirstSearchOhnolgFamilies_cl.pl $s $x
		done
	done

for s in CARROT TACGIG
	do
	for x in 0 A B C
		do
		perl 1b_filterSize1families_cl.pl $s $x
		done
	done

conda deactivate

cd ${PIPELINE}

done



