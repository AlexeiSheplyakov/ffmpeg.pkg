
all: install

PACKAGE := ffmpeg
SRCDIR := $(TOPDIR)/$(PACKAGE)
BUILDDIR := $(BUILDTREE)/$(PACKAGE)
# Some people think executing code in /tmp is OK
TMPDIR := $(BUILDDIR)
export TMPDIR

CONFIGURE := $(SRCDIR)/configure \
	--cc="$(CC)" \
	--cxx="$(CXX)" \
	--extra-ldflags="-L$(STAGEDIR)/$(PREFIX)/lib" \
	--extra-cflags="-I$(STAGEDIR)/$(PREFIX)/include" \
	--prefix="$(PREFIX)" \
	--enable-shared \
	--disable-static \
	--enable-libx264 \
	--enable-postproc \
	--enable-runtime-cpudetect \
	--enable-pthreads \
	--disable-bzlib \
	--disable-x11grab \
	--disable-ffserver \
	--disable-doc

PATCH_STAMP := $(BUILDTREE)/patch.$(PACKAGE).stamp
CONFIG_STAMP := $(BUILDTREE)/config.$(PACKAGE).stamp
BUILD_STAMP := $(BUILDTREE)/build.$(PACKAGE).stamp
INSTALL_STAMP := $(BUILDTREE)/install.$(PACKAGE).stamp

install: $(INSTALL_STAMP)

$(PATCH_STAMP):
	mkdir -p $(BUILDDIR)
	set -e; cd $(SRCDIR); \
	for i in $(TOPDIR)/patches/$(PACKAGE)/*.diff; do patch -p1 < $$i; done; \
	touch $@

$(CONFIG_STAMP): $(PATCH_STAMP)
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

CLEANFILES := $(INSTALL_STAMP) $(BUILD_STAMP) $(CONFIG_STAMP) $(PATCH_STAMP)
CLEANDIRS := $(BUILDDIR)

clean:
	-@echo [CLEAN] $(PACKAGE)
	-@rm -f $(CLEANFILES)
	-@rm -rf $(CLEANDIRS)

.PHONY: install clean
# disable parallel execution of rules in this file, but pass on -j ( and
# other flags) so package's own makefile can use parallel make 
.NOTPARALLEL:

