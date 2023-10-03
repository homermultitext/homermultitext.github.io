# homermultitext.github.io


## How to use this repository

Content on `homermultitext.github.io` is served from the `docs` directory of the `master` branch.  When changes are pushed to `master`, the github pages site is automatically updated. If you are developing content in a branch of this repository, you can test your changes by running a web server using `docs` as the root directory. (E.g., from the repository root, to use Julia's `LiveServer` package, you could run `julia -e 'using LiveServer; serve(dir="docs")`.)


Content in `docs` can be synced up to the web site at `www.homermultitext.org` using `rsync`.  (E.g., from the repository root, you could run `rsync -avz ./docs/ USERNAME@amphoreus.hpcc.uh.edu:/var/www/html/hmt`.)



## Building downloadable editions

From the repository root, use `scripts/downloadable_texts.jl` to generate downloadable text editions 
of the Venetus A *Iliad* and *scholia*, with *shcolia* grouped by zone and grouped by *Iliad* line they comment on, in both plain-text and markdown formats (four output files total).