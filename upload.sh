
mkdir working
cd working
sed  's/MYSECRETKEY/'$VLTR_KEY'/g' ../s3cfg > s3cfg
wget -q https://hgwdev.gi.ucsc.edu/~angie/UShER_SARS-CoV-2/public-latest.metadata.tsv.gz
wget -q https://raw.githubusercontent.com/theosanderson/taxonium/master/taxoniumtools/test_data/hu1.gb
wget -q https://hgwdev.gi.ucsc.edu/~angie/UShER_SARS-CoV-2/public-latest.all.masked.pb.gz

sudo pip3 install taxoniumtools
usher_to_taxonium --input public-latest.all.masked.pb.gz --output ./public.jsonl.gz --metadata public-latest.metadata.tsv.gz --genbank hu1.gb --columns genbank_accession,country,date,pangolin_lineage
s3cmd put public.jsonl.gz s3://cov2tree/latest_public.jsonl.gz