
mkdir working
cd working
# Replace MYSECRETKEY with the contents of the key
sed  "s/MYSECRETKEY/$MYKEY/g" ../s3cfg > s3cfg
s3cmd put -P ../README.md -c s3cfg s3://cov2tree/README.md
wget -q https://hgwdev.gi.ucsc.edu/~angie/UShER_SARS-CoV-2/public-latest.metadata.tsv.gz
wget -q https://raw.githubusercontent.com/theosanderson/taxonium/master/taxoniumtools/test_data/hu1.gb
wget -q https://hgwdev.gi.ucsc.edu/~angie/UShER_SARS-CoV-2/public-latest.all.masked.pb.gz
wget -q https://raw.githubusercontent.com/theosanderson/treeShears/master/treeshears.py

gunzip public-latest.all.masked.pb.gz
python treeshears.py -i public-latest.all.masked.pb -o public-latest.all.masked.sheared.pb

sudo pip3 install taxoniumtools chronumental
usher_to_taxonium --input public-latest.all.masked.sheared.pb --output ./public.jsonl.gz --metadata public-latest.metadata.tsv.gz --genbank hu1.gb --columns genbank_accession,country,date,pangolin_lineage --chronumental --chronumental_steps=300
s3cmd put -P public.jsonl.gz -c s3cfg s3://cov2tree/latest_public.jsonl.gz 
