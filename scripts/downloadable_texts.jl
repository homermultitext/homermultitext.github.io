#=
Download current release of HMT archive, and generate downloadable text editions 
of the Venetus A Iliad and scholia, grouped by zone and grouped by Iliad line they
comment on, in both plain-text and markdown formats.
=#
using CitableBase
using HmtArchive.Analysis
using HmtGutenberg

cexdata = hmt_cex()
va = hmt_codices(cexdata)[6]
va.pages[26]
iliadpageurns = map(p -> urn(p), va.pages[26:655])


zones_md = formatpages(iliadpageurns)
open("venetus-a-by-zone.md", "w") do io
    write(io, zones_md)
end

zones_txt = formatpages(iliadpageurns, md = false)
open("venetus-a-by-zone.md", "w") do io
    write(io, zones_txt)
end

lines_md = formatpages(viliadpageurns, grouping = :byline)
open("venetus-a-by-line.md", "w") do io
    write(io, lines_md)
end

lines_txt = formatpages(viliadpageurns, grouping = :byline, md = false)
open("venetus-a-by-line.md", "w") do io
    write(io, lines_txt)
end
