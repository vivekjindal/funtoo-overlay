# Distributed under the terms of the GNU General Public License v2

EAPI=2

WXWRAP_VER=1.3
WXESELECT_VER=1.4

DESCRIPTION="Eselect module and wrappers for wxWidgets"
HOMEPAGE="http://www.gentoo.org"
SRC_URI="mirror://gentoo/wxwidgets.eselect-${WXESELECT_VER}.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="*"
IUSE=""

DEPEND="!<=x11-libs/wxGTK-2.6.4.0-r2"
RDEPEND=">=app-admin/eselect-1.2.3"

S=${WORKDIR}

src_install() {
	insinto /usr/share/eselect/modules
	newins "${S}"/wxwidgets.eselect-${WXESELECT_VER} wxwidgets.eselect \
		|| die "Failed installing module"

	insinto /usr/share/aclocal
	newins "${FILESDIR}"/wxwin.m4-2.9 wxwin.m4 || die "Failed installing m4"

	newbin "${FILESDIR}"/wx-config-${WXWRAP_VER} wx-config \
		|| die "Failed installing wx-config"
	newbin "${FILESDIR}"/wxrc-${WXWRAP_VER} wxrc \
		|| die "Failed installing wxrc"

	keepdir /var/lib/wxwidgets
	keepdir /usr/share/bakefile/presets
}
