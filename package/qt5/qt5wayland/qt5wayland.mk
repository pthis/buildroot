################################################################################
#
# qt5wayland
#
################################################################################

QT5WAYLAND_VERSION = ce2caf493a1343fbd9f8e4c85baf6a61c057f242
QT5WAYLAND_SITE = $(QT5_SITE)/qtwayland/-/archive/$(QT5WAYLAND_VERSION)
QT5WAYLAND_SOURCE = qtwayland-$(QT5WAYLAND_VERSION).tar.bz2
QT5WAYLAND_DEPENDENCIES = wayland
QT5WAYLAND_INSTALL_STAGING = YES
QT5WAYLAND_SYNC_QT_HEADERS = YES

ifeq ($(BR2_PACKAGE_QT5DECLARATIVE_QUICK),y)
QT5WAYLAND_DEPENDENCIES += qt5declarative
endif

ifeq ($(BR2_PACKAGE_LIBXKBCOMMON),y)
QT5WAYLAND_DEPENDENCIES += libxkbcommon
endif

QT5WAYLAND_LICENSE = GPL-2.0+ or LGPL-3.0, GPL-3.0 with exception(tools), GFDL-1.3 (docs)
QT5WAYLAND_LICENSE_FILES = LICENSE.GPL2 LICENSE.GPL3 LICENSE.GPL3-EXCEPT LICENSE.LGPL3 LICENSE.FDL

ifeq ($(BR2_PACKAGE_QT5WAYLAND_COMPOSITOR),y)
QT5WAYLAND_CONF_OPTS += CONFIG+=wayland-compositor
else
QT5WAYLAND_CONFIG += --no-feature-wayland-server
endif

QT5WAYLAND_CONF_OPTS += -- $(QT5WAYLAND_CONFIG)

define QT5WAYLAND_FORCE_XDG_SHELL
	cd $(TARGET_DIR)/usr/lib/qt/plugins/wayland-shell-integration/ && \
		ls | grep -wv libxdg-shell.so | xargs rm -rf
endef
QT5WAYLAND_POST_INSTALL_TARGET_HOOKS += QT5WAYLAND_FORCE_XDG_SHELL

define QT5WAYLAND_INSTALL_TARGET_ENV
        $(INSTALL) -D -m 0644 $(QT5WAYLAND_PKGDIR)/qtwayland.sh \
                $(TARGET_DIR)/etc/profile.d/qtwayland.sh
endef
QT5WAYLAND_POST_INSTALL_TARGET_HOOKS += QT5WAYLAND_INSTALL_TARGET_ENV

$(eval $(qmake-package))
