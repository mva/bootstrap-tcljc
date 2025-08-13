JDK_BIN=$(HOME)/local/jdk-classfile/bin/
JAR=$(JDK_BIN)jar

module_name=$(subst -,.,$(1))
%.unpack_dummy: %.jar
	mkdir $(call module_name,$*)
	cd $(call module_name,$*) && $(JAR) xf ../$<
	rm -f $<

unpack: $(patsubst %.jar,%.unpack_dummy,$(wildcard *.jar))


jar_name=$(subst .,-,$(1)).jar
%.jar: %/module-info.class
	$(JAR) --create --file=$(call jar_name,$*) --manifest=$(dir $<)/META-INF/MANIFEST.MF -C $(dir $<) .
	rm -rf $(dir $<)

pack: $(patsubst %/module-info.class,%.jar,$(wildcard */module-info.class))


deprscan:
	$(JDK_BIN)jdeprscan tcljc.rt tcljc.core tcljc.compiler

jdeps:
	$(JDK_BIN)jdeps --module-path . tinyclj.*
