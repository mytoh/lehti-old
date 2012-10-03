
# setup 
if ( ! $?LEHTI_DIR ) then
setenv LEHTI_DIR "${HOME}/.lehti"
endif
setenv LEHTI_LIB_DIR "${LEHTI_DIR}/lib"
setenv GAUCHE_LOAD_PATH "${LEHTI_LIB_DIR}:${GAUCHE_LOAD_PATH}"
setenv PATH "${LEHTI_DIR}/bin:${PATH}"

# path
setenv LEHTI_PATH "`lehti setup path`"
setenv PATH ":${LEHTI_PATH}:${PATH}"

# load path
setenv LEHTI_LOAD_PATH "`lehti setup load-path`"
setenv GAUCHE_LOAD_PATH "${LEHTI_LOAD_PATH}:${GAUCHE_LOAD_PATH}"

# dyn load path
setenv GAUCHE_DYNLOAD_PATH `lehti setup dynload-path`

