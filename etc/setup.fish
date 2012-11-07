
# setup 
set -x LEHTI_DIR $HOME/.lehti
set -x LEHTI_LIB_DIR $LEHTI_DIR/lib
set -x GAUCHE_LOAD_PATH $LEHTI_LIB_DIR $GAUCHE_LOAD_PATH
set -x PATH $LEHTI_DIR/bin $PATH


# load path
set -x LEHTI_LOAD_PATH $LEHTI_DIR/dist/maali/lib
set -x GAUCHE_LOAD_PATH $LEHTI_LOAD_PATH $GAUCHE_LOAD_PATH

# dyn load path
# set -x GAUCHE_DYNLOAD_PATH (leh setup dynload-path)
