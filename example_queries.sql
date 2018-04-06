
# Find the significant hits for a CpG

SELECT * FROM assoc_meta, snp, cpg 
	WHERE assoc_meta.snp = snp.id 
	AND assoc_meta.cpg = cpg.id 
	AND cpg.id IN ({0}) 
	AND pval < {1}
	ORDER BY pval

# Here {0} is a list of CpGs e.g. "cg123, cg234, cg345"
# {1} is a p-value e.g. 1e-7


# Find the significant hits for a SNP

SELECT * FROM assoc_meta, snp, cpg 
	WHERE assoc_meta.snp = snp.id 
	AND assoc_meta.cpg = cpg.id 
	AND snp.rsid IN ({0}) 
	AND pval < {1}
	ORDER BY pval

# Here {0} is a list of SNP rsids (not the SNP IDs) e.g. "rs123, rs234, rs345"
# {1} is a p-value e.g. 1e-7


# Find SNP-CpG associations within a particular region

SELECT * FROM assoc_meta, snp, cpg 
	WHERE assoc_meta.snp = snp.id 
	AND assoc_meta.cpg = cpg.id 
	AND ((snp.chr = {0} AND snp.pos >= {1} AND snp.pos <= {2}) OR (cpg.chr = {0} AND cpg.pos >= {1} AND cpg.pos <= {2}))
	AND pval < {3}
	ORDER BY pval

# Here {0} is a chromosome, {1} is the lower bound for the region, {2} is the upper bound for the region, {3} is a p-value threshold


# Find SNP-CpG associations within a particular gene
# To do this we need to have a list of genes with chromosome start and stop positions
# This might be easier to do in two queries

SELECT * FROM gene
	WHERE name = {0}
# gives start_pos and stop_pos

SELECT * FROM assoc_meta, snp, cpg 
	WHERE assoc_meta.snp = snp.id 
	AND assoc_meta.cpg = cpg.id 
	AND ((snp.chr = {1} AND snp.pos >= {2} AND snp.pos <= {3}) OR (cpg.chr = {1} AND cpg.pos >= {2} AND cpg.pos <= {3}))
	AND pval < {4}
	ORDER BY pval

# Here {1} is the gene chromosome from query (1), {2} is the gene start position, {3} is the gene stop position, {4} is a p-value threshold


