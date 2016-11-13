DEMOS := pure/Main.html \
	pure/Recursive.html \
	pure/Simple.html \
	effectful/Main.html \
	effectful/Recursive.html \
	form/Main.html \
	pages/Main.html \
	xor_pages/Main.html

all: $(DEMOS)

clean:
	rm $(DEMOS) || true

%.html: %.elm
	cd $(@D) && elm make $(*F).elm --debug --output=$(*F).html

.PHONY: all clean
