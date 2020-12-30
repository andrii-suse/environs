.PHONY: FORCE
FORCE:

ifeq ($(_bindir),)
_bindir := /usr/bin
endif

ifeq ($(_sysconfigdir),)
_sysconfigdir = /etc
endif

install:
	install -m 755 environ.sh "$(DESTDIR)""$(_bindir)"/environ ;\
	sed -i "s,=\.product,=$(DESTDIR)$(_sysconfigdir)/environs.d," "$(DESTDIR)""$(_bindir)"/environ ;\
	install -d -m 755 "$(DESTDIR)""$(_sysconfigdir)"/environs.d ;\
	install -d -m 755 "$(DESTDIR)""$(_sysconfigdir)"/environs.d/.common ;\
	install -d -m 755 "$(DESTDIR)""$(_sysconfigdir)"/environs.d/.common/branch ;\
	for i in .product/.common/branch/.?*; do \
		[ -f $$i ] || continue ;\
		install -m 644 $$i "$(DESTDIR)""$(_sysconfigdir)"/environs.d/.common/branch ;\
	done ;\
	install -d -m 755 "$(DESTDIR)""$(_sysconfigdir)"/environs.d/.common/system2 ;\
	for i in .product/.common/system2/*; do \
		[ -f $$i ] || continue ;\
		install -m 644 $$i "$(DESTDIR)""$(_sysconfigdir)"/environs.d/.common/system2 ;\
	done


uninstall:
	@echo execute manually: ;\
	@echo "rm -r $(DESTDIR)$(_sysconfigdir)/environs.d && rm $(DESTDIR)$(_bindir)/environ"

install-ap:
	install -d -m 755 "$(DESTDIR)""$(_sysconfigdir)"/environs.d ;\
	install -d -m 755 "$(DESTDIR)""$(_sysconfigdir)"/environs.d/ap ;\
	for i in .product/ap/system2/*; do \
		[ -f $$i ] || continue ;\
		install -m 644 $$i "$(DESTDIR)""$(_sysconfigdir)"/environs.d/ap/ ;\
	done

ev%: FORCE
	./environ.sh $@

ap%: FORCE
	./environ.sh $@

