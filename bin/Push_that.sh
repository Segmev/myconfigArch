
ARG="push"

if [ "${1}" != "" ]
then
    ARG="${1}"
fi

make clean
make fclean
rm -f *~
rm -f vgcore.*
git add --all
git commit -am " ${ARG} "
git push origin master
