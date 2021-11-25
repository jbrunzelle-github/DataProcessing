#!/bin/tcsh

# Get the max resolution and R-merge for data sets and mosaicity of crystals
# 10/04/17  Added commands to retrieve mosaicity of crystals

# 11/19/17  Added command to extract space group from aimless log file

setsummarylist: 
#
if ( ! -e summary.list ) then
/bin/echo 'Please create a "summary.list" of the crystals for which summary results are desired. '
#
goto setsummarylist
endif

setproc:
/bin/echo 'Enter path to the process directories (eg. /data/process ): '
set proc = $<
/bin/echo ''
#
#/bin/echo $proc

setprog
/bin/echo 'Enter program type (eg. xia2, aP, or fdp)'
set prog = $<
/bin/echo $prog


#
#
sed -i -e 's/\///g' summary.list
endif
#
#
set list = `cat summary.list`
#
set const	= `pwd | sed -e 's/\// /g' | awk '{print $6}'`
#
#echo 'ID, Protein, SG, Res, Rmerge, Mosaicity, Overall, OuterShell, I/sigI, OuterShell' >> ${const}_processing_results.csv
echo 'Prog, ID, Protein, SG, Cell, Res, Rmerge, OuterShell, Overall, OuterShell, I/sigI, OuterShell, Multiplicity, OuterShell' >> ${const}_processing_results.csv
#
foreach xtl ($list)
#
set sg = `cat "$prog"_"$xtl" | awk '/Space group: /' | cut -d '"' -f2 | sed -e 's/ //g' | cut -c12-22`
set cell = `cat "$prog"_"$xtl" | awk '/Cell: /' | cut -d '"' -f2 | cut -c10-60`

set highres = `cat "$prog"_"$xtl" | awk '/High resolution limit /' | cut -c45-50`
#
set rmerge = `cat "$prog"_"$xtl" | awk '/Overall:  /' | sed -ne '5p' | cut -c19-24`
set rmouter = `cat "$prog"_"$xtl" | awk '/^Rmerge  \(all.*\-\)/' | cut -c64-68`
#
#set mosaicity = `cat ../process/${xtl}/${xtl}/CORRECT.LP | awk '/CRYSTAL MOSAICITY/' | sed -e 's/CRYSTAL MOSAICITY (DEGREES)//' | tr -d '[:blank:]'`
#
set completeness_overall = `cat "$prog"_"$xtl" | awk '/Completeness   /' | cut -c44-48`
#
set completeness_outer = `cat "$prog"_"$xtl" | awk '/Completeness   /' | cut -c63-68`
#
set isig_overall = `cat "$prog"_"$xtl" | awk '/Mean\(.*\))/\' | cut -c45-48`
set isig_outer = `cat "$prog"_"$xtl" | awk '/Mean\(.*\))/\' | cut -c64-68`
#
set multi = `cat "$prog"_"$xtl" | awk '/^Multiplicity/' | sed -ne '2p'| cut -c45-48`
set multi_outer = `cat "$prog"_"$xtl" | awk '/^Multiplicity/' | sed -ne '2p' | cut -c64-68`

#echo $xtl, $sg, $highres, $rmerge, $mosaicity, $completeness_overall, $completeness_outer
echo $prog, $xtl, $sg, $highres, $rmerge, $rmouter, $completeness_overall, $completeness_outer, $isig_overall, $isig_outer, $multi, $multi_outer
#
#echo ''
#
#echo $xtl, $const, , $sg, $highres, $rmerge, $mosaicity, $completeness_overall, $completeness_outer >> ${const}_processing_results.csv
echo $prog, $xtl, $const, $sg, $cell, $highres, $rmerge, $rmouter, $completeness_overall, $completeness_outer, $isig_overall, $isig_outer ,$multi, $multi_outer>> ${const}_processing_results.csv
#
end
