
setenv LEHTIDIR "${HOME}/.lehti"
setenv LEHTI_PATH `gosh $LEHTIDIR/setup.scm path`
set path=($LEHTIDIR/bin $LEHTI_PATH $path)
setenv LEHTI_LOAD_PATH "${LEHTIDIR}/lib:`gosh ${LEHTIDIR}/setup.scm load-path`"
setenv GAUCHE_LOAD_PATH "${LEHTI_LOAD_PATH}:$GAUCHE_LOAD_PATH"
setenv GAUCHE_DYNLOAD_PATH `gosh $LEHTIDIR/setup.scm dynload-path`
