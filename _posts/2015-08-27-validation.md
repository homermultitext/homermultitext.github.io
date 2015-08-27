---
title:  "Beyond crowd sourcing: validation and verification in the HMT project"
layout: post
---


How do you coordinate contributions from a hundred editors and ensure the quality of the resulting archive?  For the HMT project, that is not a hypothetical question.  Our reponse involves a combination of software and project organization that differs in some significant ways from other digital projects.  This post summarizes the technological systems we use.   A later post will separately describe the work flow we follow as we work in teams.

## Replication, validation, verification ##

First, definition of some key terms:  we distinguish *replication*, *validation* and *verification*.

By *replication*, we mean that we, or anyone else, can recreate every step of the work flow leading to publication in the HMT archive.  In 2015, our editorial teams work in a [virtual machine](http://homermultitext.github.io/vm2015/) with all the software needed to edit material for the HMT archive, so we can create and edit a team project using only tools included in our VM.  The editorial projects and the VM itself are maintained in publicly visible github repositories, so anyone (within or outside the project) has access to the entire history of work.  

But replicating the process of creation can not by itself ensure the quality of our archive.  We do not have the resources to duplicate the extraordinary effort required to edit complex manuscripts with scholia.  More significantly, repeating a process can only hope to uncover random errors:  a faithful replication of the same process will faithfully replicate systematic errors.  The VM therefore includes software to validate and help verify the contents of the repository (and of course these steps, too, can be replicated by anyone).  

By *validation*, we mean *a fully automated task* that assesses some part of the repository in a method different from and independent of how the material was created.  By *verification* we mean *a human judgment*, often assisted by software, that some material has been validated properly.  

Spell checkers and proof reading illustrate these concepts.  A spell checker can *validate* automatically and independently of the author's initial writing that all words in a text are possible English words. It cannot identify invalid use of valid English words.  Proof readers who judge that all words are used properly *verify* the text.
Proof reading alone may be a dubious way to verify texts, however, since it is not a fundamentally different process from the the author's own reading of the text.  Human beings do not tend to make random mistakes in composing or copying texts (as editors of manuscripts have known for centuries).  A better approach could be a *computer-assisted verification*:  proof readers might also be given specific passages to check for known common mistakes, such as repeating the same word twice in succession, a very rare phenomenon in English, but [difficult to catch by proof reading](https://en.wikipedia.org/wiki/Paris_in_the_Spring).  Viewing a list of passages to check in isolation from the flow of the text alters the experience of reading to make it somewhat less prone to repeat the same  errors.

## Organization of team work in the HMT project

All editorial work in the HMT project is done in teams, typically two or three collaborators.  Team members share their own github repository;  only the HMT project editors and architects have write access to the repository with the project's central data archive.  Editing is organized by physical units (for manuscripts, a physical page).  When teams complete a unit, they must validate and verify their work before submitting it for inclusion in the project archive.  

If a page passes 100% of the automated validation tests, and the team judges that it also passes all of the associated verification tests, they file an issue  indicating that the page (identified by its unique URN) is ready for inclusion in the central repository.  One of the editors or architects then tries to replicate the validation and verification tests for the page:  if both are successful, the page is added to the project archive.

Because every team can validate its work in progress, they not only catch testable errors before they submit material for editorial review; they can also rapidly iterate through ever improving versions of their work until they pass all tests.  This experience helps them understand the editorial process and learn the project's editorial standards very rapidly.   The technological underpinnings are largely invisible to the editors.  They start from an empty template repository:  when they follow the default organization of files in the repository, they can use an included shell script to validate and verify a page with a single parameter identifying the page.  Entering  `validate.sh urn:cite:hmt:msA.239r` in a terminal, for example, is enough to run a comprehensive evaluation of folio 239 recto of the Venetus A manuscript.

## Analysis of an editorial repository in the HMT project ##

The analysis of an editorial repository is managed by a [gradle](https://gradle.org/) build system called HMT MOM (for Mandatory Ongoing Maintenance; see the [MOM web page](http://homermultitext.github.io/hmt-mom/)).   The build system runs a variety of tasks:  some are generically applicable to any digital scholarly edition; others are specific to the Homer Multitext project.

### Generic analyses ###

The HMT project insists that we document our diplomatic editions in relation to specific physical artifacts and to documentary images.  Texts, artifacts and images are cited with URNs (CTS URNs for texts, CITE URNs for artifacts and images),  so the first tier of testing within this generic model *validates* the syntax of these URN references.  MOM additionally validates the referential integrity of all citations by checking that *all* textual references indexed to a physical page and *only* textual references indexed to a page are also indexed to a default image for that page, and conversely that *all* texts indexed to the default image and *only* texts indexed to the default image are also indexed to the physical page. 

Even if these references are all valid and consistent, however, editors might have overlooked a passage on a manuscript page so that it leaves no reference to validate.   To help editors *verify* that their edition is complete, the build system prepares a color-coded visualization similar to [this view of folio 13 recto of the Venetus A manuscript][see13r], that allows teams to scan the visualization for missing content.

### HMT-specific tests ###

If the generic scholarly relations of edition, artifact and image are valid, MOM continues by analyzing whether XML editions comply with the specific standards of the HMT project.  The first step is to validate the *syntax* of all XML documents against an appropriate schema, and if that test passes, then to analyze multiple aspects of the *contents* of the XML documents.

All texts are tokenized and each token is classified as a named entity (personal, geographic or ethnic group name), lexical entity, number, "sic" or literal string.  Tokens are restricted to Unicode code points in a [small, explicitly specified set](http://neelsmith.github.io/greeklang/specs/greek/tokens/Tokens.html) appropriate for Greek manuscript editions.  

Further validation and verification differs for different classes of token.  "Sic" classifies tokens that the editors' markup has explicitly identified as unintelligible.  Literal strings occur not infrequently when a scholiast refer to a phenomena of language such as τὸ ττ "the spelling with double-tau" and are likewise recognized from explicit XML markup.  Neither "sic" nor literal string classes are further analysed.

For named entities, MOM checks that the syntax of identifying URNs is valid, and that they refer to entities defined in HMT project authority lists.  To verify that identifying URNs have been correctly applied, MOM generates an index listing passages and strings of text identified by each URN.   In verifying the opening lines of the *Iliad* for example, the URN `urn:cite:hmt:pers.pers22` would include an entry  for Ἀτρείδης in *Iliad* 1.7 as well as for  Ἀγαμέμνονι in *Iliad* 1.24.  Reviewing a list of strings used on a page for a given identifier is an easy and reliable way to verify that the URN has been used consistently.

For numeric strings, tokens are parsed and validated for compliance with the syntax of Greek numeric notation ("Milesian notation").  These tokens are restricted to a [very narrow set](http://neelsmith.github.io/greeklang/specs/greek/tokens/milesian/Milesian.html) of Unicode code points.

Lexical tokens require the most complex analysis.   Each token is submitted to the open-source morphological parser `morpheus`  (included in the virtual machine).  Sometimes, however, Byzantine orthographic practice differs from the standard orthography expected by the parser (especially in free omission of breathing or accents, and equally free use of diaeresis on vowels where modern orthography would not allow that), with the result that a form fails to parse.   If editors verify that the form rejected by the parser is in fact an accurate transcription of the manuscript, and further that it follows acceptable rules of Byzantine orthography, they submit an issue to a repository with HMT project authority lists.  A small group of trusted editors with write permission to this repository reviews the issue, and if they find that the team is correct, add it to a mapping of recognized Byzantine to modern forms.  MOM automatically consults this authority list, so when the editorial team next attempts to validate their page, MOM will find the corresponding modern form, and parse that instead.  The resulting validation allows us to match each token in our digital editions wtih a parseable string, while at the same time recording exactly where those parseable strings represent an editorial regularization for the literal tokens appearing in our digital texts.



[see13r]:   http://www.homermultitext.org/hmt-digital/indices?urn=urn%3Acite%3Ahmt%3Avaimg.VA013RN-0014

## Conclusions ##

In manuscripts dense with scholia, a single book of the *Iliad* can easily surpass 10,000 tokens ("words") of text.  The HMT project's validation system (MOM) ensures that every word can be tracked to a region of interest on an image, and that both text and image are connected to a specific page of the manuscript.  MOM validates that every citation of text, artifact or image is a syntactically valid URN that refers to an object that really exists in the HMT archive. We further verify every token of every text against rigorous criteria that are specific to the type of the token.  

This does not guarantee that our editions are free of errors, any more than a spell checker guarantees that every word of a paper is used correctly, but HMT MOM's interlocking tests connecting physical, visual, and linguistic evidence provide us with a very solid foundation as our increasingly rapid editorial progress implies that comparative work drawing on multiple manuscripts will soon assume a larger role in the HMT project.  None of this would be possible without the dedicated work of a list of contributors now surpassing 100 names, and a system that makes it possible to demonstrate the quality of their editorial work.

## Links ##


- [HMT technical documentation](http://homermultitext.github.io/hmt-docs/) (including instructions for editors, and how to use the editors' VM)
- From the HMT project guide for editors:  [how to validate and verify your work](http://homermultitext.github.io/hmt-docs/totaled/validation/)
- [HMT project validation system](http://homermultitext.github.io/hmt-mom/) (HMT MOM): technical information
- From the `greeklang` library: specifications for [how to represent Greek in digital form](http://neelsmith.github.io/greeklang/specs/greek/tokens/Tokens.html)