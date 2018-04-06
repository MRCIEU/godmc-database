DROP TABLE IF EXISTS cohort;
DROP TABLE IF EXISTS cpg;
DROP TABLE IF EXISTS snp;
DROP TABLE IF EXISTS gene;
DROP TABLE IF EXISTS assoc_meta;
DROP TABLE IF EXISTS assoc_cohort;

CREATE TABLE IF NOT EXISTS cohort (
    id VARCHAR NOT NULL,
    name TINYTEXT NOT NULL,
    n INT NOT NULL,
    origin TINYTEXT
    tissue TINYTEXT
    cohort_type TINYTEXT NOT NULL,
    phase1 BOOL NOT NULL,
    phase2 BOOL NOT NULL,
    nsnp INT NOT NULL,
    ncpg INT NOT NULL,
    genotype_array TINYTEXT NOT NULL,
    methylation_array TINYTEXT NOT NULL,
    imputation_reference TINYTEXT NOT NULL,
    imputation_software TINYTEXT NOT NULL,
    normalisation_software TINYTEXT NOT NULL,
    normalisation_method TINYTEXT NOT NULL,
    covariates TINYTEXT NOT NULL,
    cellcounts TINYTEXT NOT NULL,
    cellcounts_reference TINYTEXT NOT NULL,
    average_age DOUBLE NOT NULL,
    lambda1 DOUBLE NOT NULL,
    lambda1 DOUBLE NOT NULL,
    m_value DOUBLE NOT NULL,
    percentage_male DOUBLE NOT NULL
    PRIMARY KEY (id)
);

CREATE TABLE IF NOT EXISTS cpg (
    name VARCHAR NOT NULL,
    chr INT NOT NULL,
    pos INT NOT NULL,
    assoc_class TINYTEXT NOT NULL,
    qc_zhou BOOL NOT NULL,
    qc_twinsuk BOOL NOT NULL,
    weighted_mean DOUBLE NOT NULL,
    weighted_sd DOUBLE NOT NULL,
    sample_size INT NOT NULL,
    PRIMARY KEY (name)
);

CREATE TABLE IF NOT EXISTS snp (
    name VARCHAR NOT NULL,
    rsid TINYTEXT NOT NULL,
    chr INT NOT NULL,
    pos INT NOT NULL,
    allele1 TINYTEXT NOT NULL,
    allele2 TINYTEXT NOT NULL,
    freq1 DOUBLE NOT NULL,
    freq1_se DOUBLE NOT NULL,
    type TINYTEXT NOT NULL,
    assoc_class TINYTEXT NOT NULL,
    PRIMARY KEY (name),
    INDEX(rsid(7))
);

CREATE TABLE IF NOT EXISTS assoc_meta (
    cpg VARCHAR NOT NULL,
    snp VARCHAR NOT NULL,
    beta DOUBLE NOT NULL,
    se DOUBLE NOT NULL,
    pval DOUBLE NOT NULL,
    n INT NOT NULL,
    sentinel BOOL NOT NULL
    cistrans BOOL NOT NULL,
    num_studies INT NOT NULL,
    direction TINYTEXT NOT NULL,
    hetisq DOUBLE NOT NULL,
    hetchisq DOUBLE NOT NULL,
    hetpval DOUBLE NOT NULL,
    tausq DOUBLE NOT NULL,
    beta_are DOUBLE NOT NULL,
    se_are DOUBLE NOT NULL,
    pval_are DOUBLE NOT NULL,
    se_mre DOUBLE NOT NULL,
    pval_mre DOUBLE NOT NULL,
    chunk INT NOT NULL,
    PRIMARY KEY(cpg, snp),
    INDEX(cpg),
    INDEX(snp)
) PARTITION BY HASH(cpg);


CREATE TABLE IF NOT EXISTS assoc_cohort (
    cpg VARCHAR NOT NULL,
    snp VARCHAR NOT NULL,
    cohort VARCHAR NOT NULL,
    beta DOUBLE NOT NULL,
    se DOUBLE NOT NULL,
    pval DOUBLE NOT NULL,
    n INT NOT NULL,
    chunk INT NOT NULL,
    PRIMARY KEY(cpg, snp, cohort),
    INDEX(cpg),
    INDEX(snp)
) PARTITION BY HASH(cpg);


CREATE TABLE IF NOT EXISTS gene (
    name VARCHAR NOT NULL,
    chr INT NOT NULL,
    start_pos INT NOT NULL,
    stop_pos INT NOT NULL
    PRIMARY KEY(name)
);



