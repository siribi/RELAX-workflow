# RELAX-workflow

This repository contains scripts for running RELAX in [HyPhy](https://hyphy.org/methods/selection-methods/) <br />

As written on the HyPhy pages: "RELAX is a hypothesis testing framework that asks whether the strength of natural selection has been relaxed or intensified along a specified set of test branches" <br />

To be able to run RELAX, you need on or several gene alignments and either a species tree or a gene tree. <br />

Before running HyPhy with these scripts, I first generated single-copy gene alignments following this code: https://github.com/siribi/CODEML_WORKFLOW and downloaded a species tree from timetree.org. (Note that the tree from timetree has branch lengths in the millions of years, so the branch-lenghts are not really useful here). <br />

**How to run the RELAX worker script:**

1. First, copy all your GUIDANCE filtered alignments over to your working directory <br />

2. Remove gene name extensions with "change_fasta_headers.sh" so that all header names are streamlined (only named after the species and corresponding to the hyphy tree) <br />

3. Double-check that the sequences are in order <br />

4. Make directories with 100 alignments in each using make_100files_directories.sh <br />

5. Make additional directories required: <br />
```
mkdir ERRORS RELAX_FALSE RELAX_TRUE RESULTS
```

6. Make the hyphy tree using the output from orthofinder, timetree.org (or other better trees) <br />
        You need to specify foreground and background branches using the [Phylotree Widget](http://phylotree.hyphy.org/) <br />
        Here is a [Phylotree Widget Tutorial](http://hyphy.org/tutorials/phylotree/) <br />
        The tree should be in Newick-format, and all species names should correspond to the sequence names <br />
```
(((Cucarg{Foreground}:0.07171,Cucsat{Foreground}:0.07627){Foreground}:0.02685,Momcha{Foreground}:0.06048){Foreground}:0.12203,(Querob{Background}:0.11705,((Alnglu{Background}:0.04836,Betpen{Background}:0.03767){Background}:0.05342,(Carill{Background}:0.02654,Jugreg{Background}:0.01812){Background}:0.08875){Background}:0.0234){Background}:0.12203):0;
```


8. Run worker_hyphy.sbatch like this (X-XXX is the number of subdirectories you have with gene alignments):
```
sbatch --array=X-XXX worker_hyphy.sbatch 
```

