AC_PREREQ(2.59)
AC_INIT([shell-oaiharvester], m4_esyscmd([grep -o 'VERSION=' oaiharvester | cut -d '"' -f 2 | tr -d '\n']) , [wimmuskee@gmail.com])
AM_INIT_AUTOMAKE([-Wall -Werror foreign])
AC_CHECK_PROGS([HELP2MAN], [help2man])
AC_CONFIG_FILES([Makefile])
AC_OUTPUT
