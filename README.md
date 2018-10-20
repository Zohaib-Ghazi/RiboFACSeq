# RiboFACSeq: A new method for investigating metabolic and transport pathways in bacterial cells by combining a riboswitch-based sensor, fluorescence-activated cell sorting and next-generation sequencing

The elucidation of the cellular processes involved in vitamin and cofactor biosynthesis is a challenging task. In life sciences, 
the conventional approaches to these investigations rely on the discovery and purification of the products (i.e proteins and metabolites) 
of a particular transport or biosynthetic pathway. However, the purification of low-abundance proteins or metabolites is a formidable undertaking 
that presents considerable technical challenges. As a solution, we present an alternative approach to such studies that circumvents the purification step. 

The proposed approach takes advantage of: 
1. The molecular detection capabilities of a **riboswitch-based sensor** to detect the cellular levels of its cognate molecule, as a means to probe the integrity of the transport and biosynthetic pathways of the target molecule in cells; 
2. The high-throughput screening ability of **fluorescence-activated cell sorters** to isolate cells in which only these specific pathways are disrupted, and; 
3. The ability of **next-generation sequencing** to quickly identify the genes of the FACS-sorted populations. 

This approach was named [**RiboFACSeq**](https://www.ncbi.nlm.nih.gov/pubmed/29211762).

As a **proof-of-concept**, an adenosylcobalamin (AdoCbl)-responsive riboswitch-based sensor was used in this study to demonstrate that RiboFACSeq 
can be used to **track** and **sort** cells carrying genetic mutations in __known__ AdoCbl transport and biosynthesis genes with desirable sensitivity and specificity.

## Motivation

As specified in the [publication](https://www.ncbi.nlm.nih.gov/pubmed/29211762), we assessed the recovery of AdoCbl-specific mutants from
spiked samples containing known mixtures of them (i.e. ΔbtuB, ΔcobC, ΔcobU, ΔcobS, ΔcobT and ΔexbB), an unrelated mutant (ΔcarB) and WT cells.
To track the various cell-types, each of these strains were genetically modified by the incorporation of a unique 9-nucleotide "barcode", as follows: 
 
1. WT:'ATGTGTGTA'
2. __ΔbtuB__:'ATGGCTTGT'
3. __ΔcobC__:'ATGATCTGT'
4. __ΔcobU__:'ATGCTGTGT'
5. __ΔcobS__:'ATGTTCTGT'
6. __ΔcobT__:'ATGCCTTGT'
7. __ΔexbB__:'ATGGTATGT' 
8. __ΔcarB__:'ATGTGTTGT'


## Getting Started

These instructions will get you a copy of the project up and running on your local machine for development and testing purposes. See deployment for notes on how to deploy the project on a live system.


### Prerequisites

What things you need to install the software and how to install them

```
Give examples
```

### Installing

A step by step series of examples that tell you have to get a development env running

Say what the step will be

```
Give the example
```

And repeat

```
until finished
```

End with an example of getting some data out of the system or using it for a little demo

## Running the tests

Explain how to run the automated tests for this system

### Break down into end to end tests

Explain what these tests test and why

```
Give an example
```

### And coding style tests

Explain what these tests test and why

```
Give an example
```

## Authors

* **Zohaib Ghazi** - [ZohaibGhazi](https://github.com/Zohaib-Ghazi)

## License

This project is licensed under the MIT License - see the [LICENSE.md](LICENSE.md) file for details

## Acknowledgments

* Hat tip to anyone who's code was used
* Inspiration
* etc
