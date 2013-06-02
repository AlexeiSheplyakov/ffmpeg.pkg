
PACKAGE := x264
SRCDIR := $(TOPDIR)/$(PACKAGE)
BUILDDIR := $(BUILDTREE)/$(PACKAGE)

CONFIGURE := $(SRCDIR)/configure \
	--cross-prefix="$(ARCH)-" \
	--host="$(ARCH)" \
	--prefix="$(PREFIX)" \
	--enable-win32thread \
	--enable-shared \
	--disable-gpl \
	--disable-cli

CONFIG_STAMP := $(BUILDTREE)/config.$(PACKAGE).stamp
BUILD_STAMP := $(BUILDTREE)/build.$(PACKAGE).stamp
INSTALL_STAMP := $(BUILDTREE)/install.$(PACKAGE).stamp

all: install

config: $(CONFIG_STAMP)
build: $(BUILD_STAMP)
install: $(INSTALL_STAMP)

$(CONFIG_STAMP):
	mkdir -p $(BUILDDIR); cd $(BUILDDIR); \
	$(CONFIGURE)
	if [ ! -d "$(dir $@)" ]; then mkdir -p "$(dir $@)"; fi
	touch $@

$(BUILD_STAMP): $(CONFIG_STAMP)
	$(MAKE) -C $(BUILDDIR)
	if [ ! -d "$(dir $@)" ]; then mkdir -p "$(dir $@)"; fi
	touch $@

$(INSTALL_STAMP): $(BUILD_STAMP)
	$(MAKE) -C $(BUILDDIR) DESTDIR=$(STAGEDIR) install
	if [ ! -d "$(dir $@)" ]; then mkdir -p "$(dir $@)"; fi
	touch $@

CLEANFILES := $(INSTALL_STAMP) $(BUILD_STAMP) $(CONFIG_STAMP)
CLEANDIRS := $(BUILDDIR)

clean:
	-@echo [CLEAN] $(PACKAGE)
	-@rm -f $(CLEANFILES)
	-@rm -rf $(CLEANDIRS)

.PHONY: install clean
# disable parallel execution of rules in this file, but pass on -j ( and
# other flags) so package's own makefile can use parallel make 
.NOTPARALLEL:

