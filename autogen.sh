#! /bin/sh
AC_VERSION=

AUTOMAKE=${AUTOMAKE:-automake}
AM_INSTALLED_VERSION=$($AUTOMAKE --version | sed -e '2,$ d' -e 's/.* \([0-9]*\.[0-9]*\).*/\1/')

if [ "$AM_INSTALLED_VERSION" != "1.11" \
    -a "$AM_INSTALLED_VERSION" != "1.12" ];then
	echo
	echo "You must have automake >= 1.11 installed to compile menu-cache."
	echo "Install the appropriate package for your distribution,"
	echo "or get the source tarball at http://ftp.gnu.org/gnu/automake/"
	exit 1
fi

if [ "x${ACLOCAL_DIR}" != "x" ]; then
  ACLOCAL_ARG=-I ${ACLOCAL_DIR}
fi

if gtkdocize --copy; then
    echo "Files needed by gtk-doc are generated."
else
    echo "You need gtk-doc to build this package."
    echo "http://www.gtk.org/gtk-doc/"
    exit 1
fi

set -x

${ACLOCAL:-aclocal$AM_VERSION} ${ACLOCAL_ARG}
${AUTOHEADER:-autoheader$AC_VERSION} --force
AUTOMAKE=$AUTOMAKE libtoolize -c --automake --force
$AUTOMAKE --add-missing --copy --include-deps
${AUTOCONF:-autoconf$AC_VERSION}

rm -rf autom4te.cache
