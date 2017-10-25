#/usr/bin/env sh

echo "[INFO] Checking for ctags."
command -v ctags > /dev/null 2>&1 || { echo >&2 "[ERR] ctags not found. Please install ctags.\nhttp://ctags.sourceforge.net/"; exit 1; }

echo "[INFO] Checking for ANDROID_SDK env variable."
echo ${ANDROID_SDK:?"[ERR] ANDROID_SDK not set."} 

echo "[BUILDING] Creating tags file for android."
if ! ctags --recurse --langmap=Java:.java --languages=Java --verbose -f ~/.vim/tags $ANDROID_SDK/sources 
then
	echo "[ERR] ctags failed. Trying again with ctags-exuberant"
    if ! ctags-exuberant --recurse --langmap=Java:.java --languages=Java --verbose -f ~/.vim/tags $ANDROID_SDK/sources 
    then
        echo "[ERR] ctags-exuberant failed. Now exiting..."
        exit 1
    fi
fi

echo "[VIM] Adding things to ~/.vimrc"
echo "\"Added by android-vim:" >> ~/.vimrc
echo "set tags+=`echo ~`/.vim/tags" >> ~/.vimrc
echo "autocmd Filetype java setlocal omnifunc=javacomplete#Complete" >> ~/.vimrc
echo "let g:SuperTabDefaultCompletionType = 'context'" >> ~/.vimrc

echo "[INFO] Cloning Supertab"
git clone git://github.com/ervandew/supertab.git supertab
echo "[INFO] Cloning snipMate"
git clone git://github.com/garbas/vim-snipmate.git snipmate
echo "[INFO] Cloning javacomplete2"
git clone git://github.com/artur-shaik/vim-javacomplete2.git javacomplete2

echo "[BUILDING] Creating vimballs"
make

echo "[INSTALLING] Installing Supertab, snipMate, javacomplete2, and findAndroidManifest"
vim findAndroidManifest/findmanifest.vmb -c 'so %' -c 'q!'
vim supertab/supertab.vmb -c 'so %' -c 'q!'
vim javacomplete2/javacomplete.vmb -c 'so %' -c 'q!'
vim snipmate/snipmate.vmb -c 'so %' -c 'q!'
vim adbLogCat/adbLogCat.vmb -c 'so %' -c 'q!'
