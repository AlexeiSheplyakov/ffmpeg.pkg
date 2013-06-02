#!/usr/bin/make -f

PACKAGES := x264 ffmpeg
include conf/mingw$(ARCH64).conf

TOPDIR := $(shell pwd)
BUILDTREE := $(TOPDIR)/build-tree/$(ARCH)
STAGEDIR := $(TOPDIR)/inst/$(ARCH)
export STAGEDIR TOPDIR BUILDTREE

ZIPFILE := ffmpeg-$(ARCH).zip
MD5SUMS := $(ZIPFILE:%=%.md5)

# FIXME: makeinfo fails due to wrong grep call in all locales except C
LC_ALL := C
export LC_ALL

PACKAGES_STAMP := $(BUILDTREE)/packages.stamp

all: $(ZIPFILE)

build: $(PACKAGES_STAMP)


$(ZIPFILE): $(PACKAGES_STAMP)
	set -e; olddir=`pwd`; cd $(STAGEDIR)$(PREFIX); zip -r $$olddir/$(ZIPFILE) .

$(ZIPFILE).md5: $(ZIPFILE)
	md5sum $< > $@.tmp
	mv $@.tmp $@

$(PACKAGES_STAMP):
	$(MAKE) -I `pwd`/conf -C mk/x264
	$(MAKE) -I `pwd`/conf -C mk/ffmpeg
	touch $@

define do_git_clean
git reset --hard HEAD ; \
git clean -d -f ; \
git clean -d -f -X
endef

clean:
	-@echo CLEAN BUILDTREE; rm -rf $(BUILDTREE)
	-@echo CLEAN inst; rm -rf $(STAGEDIR)
	-@echo CLEAN x264; cd x264; $(do_git_clean)
	-@echo CLEAN ffmpeg; cd ffmpeg; $(do_git_clean)

.PHONY: packages.stamp clean all

.NOTPARALLEL:

