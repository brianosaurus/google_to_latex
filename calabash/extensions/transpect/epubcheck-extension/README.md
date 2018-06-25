# epubcheck-extension
IDPF epubcheck extension for XML Calabash

## Prerequisites

1. You need at least Java 1.7
2. Add the `EpubCheckExtension.class` and the jar files in the `lib` directory to your Java classpath.
3. Add an entry in your XProc config file for XML Calabash:

```xml
<xproc-config xmlns="http://xmlcalabash.com/ns/configuration"
  xmlns:tr="http://transpect.io">

  <implementation type="tr:epubcheck" class-name="io.transpect.calabash.extensions.EpubCheckExtension"/>

</xproc-config>
```

## Include in your pipeline

This step runs epubcheck as XProc step. This example shows how to import and run `tr:epubcheck` in your pipeline.

```xml
<?xml version="1.0" encoding="UTF-8"?>
<p:declare-step xmlns:p="http://www.w3.org/ns/xproc"
  xmlns:c="http://www.w3.org/ns/xproc-step"
  xmlns:tr="http://transpect.io"
  version="1.0">

  <p:output port="result"/>

  <p:option name="href" select="'test/EmptyDir20.epub'"/>

  <p:import href="epubcheck-declaration.xpl"/>

  <tr:epubcheck>
    <p:with-option name="href" select="$href"/>
  </tr:epubcheck>

</p:declare-step>
```

### Report output

The primary output is an XML report in the JHOVE format. Here is an example:

```xml
<jhove xmlns="http://hul.harvard.edu/ois/xml/ns/jhove" 
   date="2012-10-31" name="epubcheck" release="4.0.2">
   <date>2017-02-22T17:10:13+01:00</date>
   <repInfo uri="EmptyDir20.epub">
      <format>application/octet-stream</format>
      <status>Not well-formed</status>
      <messages>
         <message severity="error" subMessage="PKG-018">PKG-018, FATAL, 
         [The EPUB file could not be found.], EmptyDir20.epub</message>
      </messages>
      <properties>
         <property>
            <name>Info</name>
            <values arity="List" type="Property"/>
         </property>
      </properties>
   </repInfo>
</jhove>
```

