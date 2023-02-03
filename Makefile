JDK_BIN=$(HOME)/local/jdk-classfile/bin/
JAR=$(JDK_BIN)jar

# Note: "jar --create" seems to order constant pool entries in a
# non-deterministic way, across JDK versions (going from 15 to 14) and
# also when sticking to a single JDK version (e.g. 15).  This means
# that a "make pack" followed by a "make unpack" produces
# module-info.class files that are no longer byte identical.  Ignoring
# constant pool numbering the files seem to be semantically
# equivalent, though.

module_name=$(subst -,.,$(dir $(1)))
%/module-info.class: %.jar
	mkdir $(call module_name,$@)
	cd $(call module_name,$@) && $(JAR) xf ../$<
	rm -f $<

unpack: $(patsubst %.jar,%/module-info.class,$(wildcard *.jar))


jar_name=$(subst .,-,$(1)).jar
%.jar: %/module-info.class
	$(JAR) --create --file=$(call jar_name,$*) --manifest=$(dir $<)/META-INF/MANIFEST.MF -C $(dir $<) .
	rm -rf $(dir $<)

pack: $(patsubst %/module-info.class,%.jar,$(wildcard */module-info.class))


deprscan:
	$(JDK_BIN)jdeprscan tinyclj.rt tinyclj.core tinyclj.compiler
