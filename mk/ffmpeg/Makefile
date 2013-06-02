
all: install

PACKAGE := ffmpeg
SRCDIR := $(TOPDIR)/$(PACKAGE)
BUILDDIR := $(BUILDTREE)/$(PACKAGE)
PATCHDIR := $(TOPDIR)/patches/$(PACKAGE)
# Some people think executing code in /tmp is OK
TMPDIR := $(BUILDDIR)
export TMPDIR

CONFIGURE := $(SRCDIR)/configure \
	--cross-prefix="$(ARCH)-" \
	--enable-cross-compile \
	--arch=i686 \
	--target-os=mingw32 \
	--cc="$(CC)" \
	--cxx="$(CXX)" \
	--extra-ldflags="-L$(STAGEDIR)/$(PREFIX)/lib" \
	--extra-cflags="-I$(STAGEDIR)/$(PREFIX)/include" \
	--prefix="$(PREFIX)" \
	--enable-shared \
	--disable-static \
	--enable-libx264 \
	--enable-postproc \
	--enable-w32threads \
	--enable-runtime-cpudetect \
	--enable-memalign-hack \
	--disable-pthreads \
	--disable-doc

PATCH_STAMP := $(BUILDTREE)/patch.$(PACKAGE).stamp
CONFIG_STAMP := $(BUILDTREE)/config.$(PACKAGE).stamp
BUILD_STAMP := $(BUILDTREE)/build.$(PACKAGE).stamp
INSTALL_STAMP := $(BUILDTREE)/install.$(PACKAGE).stamp

install: $(INSTALL_STAMP)

$(PATCH_STAMP):
	set -e; \
	if [ -d "$(PATCHDIR)" ]; then \
		mkdir -p $(BUILDDIR); \
		cd $(SRCDIR); \
		ln -s ../patches/$(PACKAGE) patches ; \
		quilt push -a ; \
	fi

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

