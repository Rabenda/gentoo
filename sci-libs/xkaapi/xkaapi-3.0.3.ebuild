# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=5

FORTRAN_NEEDED=fortran
AUTOTOOLS_AUTORECONF=true

inherit autotools-utils fortran-2

UPSTREAM_NO=34360

DESCRIPTION="Kernel for Adaptative, Asynchronous Parallel and Interactive programming"
HOMEPAGE="http://kaapi.gforge.inria.fr"
SRC_URI="https://gforge.inria.fr/frs/download.php/${UPSTREAM_NO}/${P}.tar.gz"

SLOT="0"
LICENSE="CeCILL-2"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE="cxx fortran openmp static-libs"

RDEPEND="
	sys-apps/hwloc
	dev-libs/libffi
"
DEPEND="${RDEPEND}
"

PATCHES=(
	"${FILESDIR}"/${P}-flags.patch
	)

src_prepare() {
	sed \
		-e 's:-Werror::g' \
		-i tests/testsuite* tests/*/*.am || die
	autotools-utils_src_prepare
}

src_configure() {
	local myeconfargs=(
		--enable-mode=gentoo
		--enable-api-quark
		--with-ccache=no
		$(use_enable fortran api-kaapif)
		$(use_enable cxx api-kaapixx)
		$(use_enable openmp libkomp)
#		$(use_with plasma "${EPREFIX}"/usr)
	)
	autotools-utils_src_configure
}
