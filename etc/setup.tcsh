
set path=($LEHTIDIR/bin $path)
setenv GAUCHE_LOAD_PATH "${LEHTIDIR}/lib:`gosh $LEHTIDIR/setup.scm load-path`"
setenv GAUCHE_DYNLOAD_PATH `gosh $LEHTIDIR/setup.scm dynload-path`
