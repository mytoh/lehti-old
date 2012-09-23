
# setup 
export LEHTI_DIR="${HOME}/.lehti"
export LEHTI_LIB_DIR="${LEHTI_DIR}/lib"
export GAUCHE_LOAD_PATH="${LEHTI_LIB_DIR}:${GAUCHE_LOAD_PATH}"

# path
export LEHTI_PATH="$(lehti setup path)"
export PATH="${LEHTI_DIR}/bin:${LEHTI_PATH}${PATH}"

# load path
export LEHTI_LOAD_PATH="$(lehti setup load-path)"
export GAUCHE_LOAD_PATH="${LEHTI_LOAD_PATH}:${GAUCHE_LOAD_PATH}"

# dyn load path
export GAUCHE_DYNLOAD_PATH=$(lehti setup dynload-path)

