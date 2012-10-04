
# setup 
if [ -z "$LEHTI_DIR" ]
then
  export LEHTI_DIR="${HOME}/.lehti"
fi
export LEHTI_LIB_DIR="${LEHTI_DIR}/src"
export GAUCHE_LOAD_PATH="${LEHTI_LIB_DIR}:${GAUCHE_LOAD_PATH}"
export PATH="${LEHTI_DIR}/bin:${PATH}"

if [ -d $LEHTI_DIR/dist ]
then
  # path
  export LEHTI_PATH="$(lehti setup path)"
  export PATH="${LEHTI_PATH}:${PATH}"

  # load path
  export LEHTI_LOAD_PATH="$(lehti setup load-path)"
  export GAUCHE_LOAD_PATH="${LEHTI_LOAD_PATH}:${GAUCHE_LOAD_PATH}"

  # dyn load path
  export GAUCHE_DYNLOAD_PATH=$(lehti setup dynload-path)
fi

