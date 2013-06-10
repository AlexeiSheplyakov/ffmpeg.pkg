#!/usr/bin/make -f

PACKAGES := x264 ffmpeg
ARCH := x86_64-darwin

TOPDIR := $(shell pwd)/..
BUILDTREE := $(TOPDIR)/$(ARCH)/build-tree
STAGEDIR := $(TOPDIR)/$(ARCH)/inst
PREFIX := /opt/xmpie/ffmpeg
CCACHE := $(shell if which -s ccache; then echo ccache; fi)
CC := $(CCACHE) gcc
CXX := $(CCACHE) g++
export CC CXX STAGEDIR TOPDIR BUILDTREE PREFIX

ZIPFILE := ffmpeg-$(ARCH).zip
MD5SUMS := $(ZIPFILE:%=%.md5)

# FIXME: makeinfo fails due to wrong grep call in all locales except C
LC_ALL := C
export LC_ALL

PACKAGES_STAMP := $(BUILDTREE)/packages.stamp

all: $(ZIPFILE)

build: $(PACKAGES_STAMP)


$(ZIPFILE): $(PACKAGES_STAMP)
	set -e; olddir=`pwd`; cd $(STAGEDIR); zip -r $$olddir/$(ZIPFILE) .

$(ZIPFILE).md5: $(ZIPFILE)
	md5 -r $< > $@.tmp
	mv $@.tmp $@

$(PACKAGES_STAMP):
	$(MAKE) -I `pwd`/conf -C mk/x264
	$(MAKE) -I `pwd`/conf -C mk/ffmpeg
	touch $@

define git_clean
git reset --hard HEAD ;\
git clean -d -f ;\
git clean -d -f -X
endef

clean:
	-@echo CLEAN BUILDTREE; rm -rf $(BUILDTREE)
	-@echo CLEAN inst; rm -rf $(STAGEDIR)
	-@echo CLEAN x264; cd $(TOPDIR)/x264; $(git_clean)
	-@echo CLEAN ffmpeg; cd $(TOPDIR)/ffmpeg; $(git_clean)

.PHONY: packages.stamp clean all

.NOTPARALLEL:

