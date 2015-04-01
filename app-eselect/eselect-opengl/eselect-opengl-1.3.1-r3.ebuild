# Distributed under the terms of the GNU General Public License v2


EAPI=5

inherit eutils multilib

DESCRIPTION="Utility to change the OpenGL interface being used"
HOMEPAGE="http://www.gentoo.org/"

# Source:
# http://www.opengl.org/registry/api/glext.h
# http://www.opengl.org/registry/api/glxext.h
GLEXT="85"
GLXEXT="34"

MIRROR="http://dev.gentoo.org/~mattst88/distfiles"
SRC_URI="http://dev.gentoo.org/~mgorny/dist/opengl.eselect-${PV}.xz"
#	${MIRROR}/${P}.tar.xz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="*"
IUSE=""

DEPEND="app-arch/xz-utils"
RDEPEND=">=app-admin/eselect-1.2.4
	!<x11-drivers/ati-drivers-14.9-r2
	!=x11-drivers/ati-drivers-14.12"

# required by runtime but cause circular depends
PDEPEND=">=media-libs/mesa-10.3.7-r2
	>=x11-proto/glproto-1.4.17-r1
	>=x11-base/xorg-server-1.16.4-r1
	>=app-emulation/emul-linux-x86-opengl-20140508-r1"

S=${WORKDIR}

pkg_preinst() {
	# we may be moving the config file, so get it early
	OLD_IMPL=$(eselect opengl show)
}

pkg_postinst() {
	if path_exists "${EROOT}"/usr/lib*/opengl; then
		# delete broken symlinks
		find "${EROOT}"/usr/lib*/opengl -xtype l -delete
		# delete empty leftover directories (they confuse eselect)
		find "${EROOT}"/usr/lib*/opengl -depth -type d -empty -exec rmdir -v {} +
	fi

	if [[ -n "${OLD_IMPL}" && "${OLD_IMPL}" != '(none)' ]] ; then
		eselect opengl set "${OLD_IMPL}"
	fi
	if [[ -f ${EROOT}/etc/env.d/03opengl ]]; then
		# remove the old file, moved now
		rm -vf "${EROOT}"/etc/env.d/03opengl
	fi
}

src_prepare() {
	# don't die on Darwin users
	if [[ ${CHOST} == *-darwin* ]] ; then
		sed -i -e 's/libGL\.so/libGL.dylib/' opengl.eselect || die
	fi
}

src_install() {
	insinto "/usr/share/eselect/modules"
	newins opengl.eselect-${PV} opengl.eselect
#	doman opengl.eselect.5
}
