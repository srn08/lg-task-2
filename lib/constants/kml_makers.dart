class KMLStrings {
  static String orbitLookAtLinear(double latitude, double longitude,
          double zoom, double tilt, double bearing) =>
      '<gx:duration>2</gx:duration><gx:flyToMode>smooth</gx:flyToMode><LookAt><longitude>$longitude</longitude><latitude>$latitude</latitude><range>$zoom</range><tilt>$tilt</tilt><heading>$bearing</heading><gx:altitudeMode>relativeToGround</gx:altitudeMode></LookAt>';

  static screenOverlayImage(String imageUrl, double factor) =>
      '''<?xml version="1.0" encoding="UTF-8"?>
<kml xmlns="http://www.opengis.net/kml/2.2" xmlns:gx="http://www.google.com/kml/ext/2.2" xmlns:kml="http://www.opengis.net/kml/2.2" xmlns:atom="http://www.w3.org/2005/Atom">
    <Document id ="bubble">
         <name>Pre Selection Task 2 - Shaunak Nagrecha</name>
             <Folder>
                  <name>Button 4</name>
                  <ScreenOverlay>
                      <name>Logo</name>
                      <Icon><href>$imageUrl</href> </Icon>
                      <overlayXY x="0" y="1" xunits="fraction" yunits="fraction"/>
                      <screenXY x="0.025" y="0.95" xunits="fraction" yunits="fraction"/>
                      <rotationXY x="0" y="0" xunits="fraction" yunits="fraction"/>
                      <size x="300" y="${300 * factor}" xunits="pixels" yunits="pixels"/>
                  </ScreenOverlay>
             </Folder>
    </Document>
</kml>''';
}
