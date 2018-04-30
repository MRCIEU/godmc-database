DROP TABLE IF EXISTS cohort;
DROP TABLE IF EXISTS cpg;
DROP TABLE IF EXISTS snp;
DROP TABLE IF EXISTS gene;
DROP TABLE IF EXISTS assoc_meta;
DROP TABLE IF EXISTS assoc_cohort;

CREATE TABLE IF NOT EXISTS cohort (
    name VARCHAR(20) NOT NULL,
    samplesize INT NOT NULL,
    origin TINYTEXT,
    tissue TINYTEXT,
    cohort_type TINYTEXT NOT NULL,
    phase BOOL NOT NULL,
    nsnp INT NOT NULL,
    ncpg INT NOT NULL,
    genotype_array TINYTEXT NOT NULL,
    methylation_array TINYTEXT NOT NULL,
    imputation_reference TINYTEXT NOT NULL,
    imputation_software TINYTEXT NOT NULL,
    normalisation_software TINYTEXT NOT NULL,
    normalisation_method TINYTEXT NOT NULL,
    sampleQC_methylation TINYTEXT NOT NULL,
    probeQC_methylation TINYTEXT NOT NULL,
    postnormalization_QC TINYTEXT NOT NULL,
    covariates TINYTEXT NOT NULL,
    cellcounts TINYTEXT NOT NULL,
    cellcounts_reference TINYTEXT NOT NULL,
    average_age DOUBLE NOT NULL,
    lambda_nocisadj DOUBLE NOT NULL,
    lambda_cisadj DOUBLE NOT NULL,
    m_value DOUBLE NOT NULL,
    m_sd DOUBLE NOT NULL,
    m_se DOUBLE NOT NULL,
    proportion_male DOUBLE NOT NULL,
    PRIMARY KEY (name)
);

CREATE TABLE IF NOT EXISTS cpg (
    name VARCHAR(20) NOT NULL,
    probetype TINYTEXT NOT NULL,
    chr TINYTEXT NOT NULL,
    pos INT NOT NULL,
    assoc_class TINYTEXT NOT NULL,
    qc_zhou BOOL NOT NULL,
    qc_twinsuk BOOL NOT NULL,
    weighted_mean DOUBLE NOT NULL,
    weighted_sd DOUBLE NOT NULL,
    samplesize INT NOT NULL,
    PRIMARY KEY (name)
);

CREATE TABLE IF NOT EXISTS snp (
    name VARCHAR(20) NOT NULL,
    rsid TINYTEXT NOT NULL,
    chr TINYTEXT NOT NULL,
    pos INT NOT NULL,
    allele1 TINYTEXT NOT NULL,
    allele2 TINYTEXT NOT NULL,
    freq1_1000G DOUBLE NOT NULL,
    nchrs_1000G DOUBLE NOT NULL,
    type TINYTEXT NOT NULL,
    snp_tested TINYTEXT NOT NULL,
    assoc_class TINYTEXT NOT NULL,
    min_pval DOUBLE NOT NULL,
    max_abs_Effect DOUBLE NOT NULL,
    mqtl_clumped TINYTEXT NOT NULL,
    snp_qc TINYTEXT NOT NULL,
    PRIMARY KEY (name),
    INDEX(rsid(7))
);

CREATE TABLE IF NOT EXISTS assoc_meta (
    cpg VARCHAR(20) NOT NULL,
    snp VARCHAR(20) NOT NULL,
    beta_a1 DOUBLE NOT NULL,
    se DOUBLE NOT NULL,
    pval DOUBLE NOT NULL,
    samplesize INT NOT NULL,
    allele1 DOUBLE NOT NULL,
    allele2 DOUBLE NOT NULL,
    freq_a1 DOUBLE NOT NULL,
    freq_se DOUBLE NOT NULL,
    cistrans BOOL NOT NULL,
    num_studies INT NOT NULL,
    direction TINYTEXT NOT NULL,
    hetisq DOUBLE NOT NULL,
    hetchisq DOUBLE NOT NULL,
    hetpval DOUBLE NOT NULL,
    tausq DOUBLE NOT NULL,
    beta_are_a1 DOUBLE NOT NULL,
    se_are DOUBLE NOT NULL,
    pval_are DOUBLE NOT NULL,
    se_mre DOUBLE NOT NULL,
    pval_mre DOUBLE NOT NULL,
    chunk INT NOT NULL,
    PRIMARY KEY(cpg, snp),
    INDEX(cpg),
    INDEX(snp)
) PARTITION BY KEY();


CREATE TABLE IF NOT EXISTS assoc_cohort (
    cpg VARCHAR(20) NOT NULL,
    snp VARCHAR(20) NOT NULL,
    cohort VARCHAR(20) NOT NULL,
    beta DOUBLE NOT NULL,
    se DOUBLE NOT NULL,
    pval DOUBLE NOT NULL,
    n INT NOT NULL,
    chunk INT NOT NULL,
    PRIMARY KEY(cpg, snp, cohort),
    INDEX(cpg),
    INDEX(snp)
) PARTITION BY KEY();

CREATE TABLE IF NOT EXISTS gene (
    name VARCHAR(20) NOT NULL,
    chr TINYTEXT NOT NULL,
    start_pos INT NOT NULL,
    stop_pos INT NOT NULL,
    start_original INT NOT NULL,
    stop_original INT NOT NULL,
    source TINYTEXT NOT NULL,
    strand_original TINYTEXT NOT NULL,
    gene_type  TINYTEXT NOT NULL,
    PRIMARY KEY(name)
);

