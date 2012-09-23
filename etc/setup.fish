
# setup 
set -x LEHTI_DIR ${HOME}/.lehti
set -x LEHTI_LIB_DIR ${LEHTI_DIR}/lib
set -x GAUCHE_LOAD_PATH ${LEHTI_LIB_DIR} ${GAUCHE_LOAD_PATH}

# path
set -x LEHTI_PATH (lehti setup path)
set -x PATH ${LEHTI_DIR}/bin ${LEHTI_PATH}${PATH}

# load path
set -x LEHTI_LOAD_PATH (lehti setup load-path)
set -x GAUCHE_LOAD_PATH ${LEHTI_LOAD_PATH} ${GAUCHE_LOAD_PATH}

# dyn load path
set -x GAUCHE_DYNLOAD_PATH (lehti setup dynload-path)
