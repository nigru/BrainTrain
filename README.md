# BrainTrain

Zum Ausführen der App muss mit Xcode `BrainTrain.xcworkspace` geöffnet werden, da das Projekt CocoaPods verwendet.
Die einzelnen Pods sind bereits im Projekt enthalten und sollten eigentlich nicht nachgeladen werden müssen. Sollten
dennoch Abhängigkeiten fehlen muss `pod install` im Verzeichnis des Projektes ausgeführt werden.
Außerdem müssen ggf. die Einstellungen für das Signing angepasst werden.

Folgende CocoaPods werden im Projekt verwendet:
- [SwiftChart](https://github.com/gpbl/SwiftChart) (MIT): Für die Anzeige der Chart unter der Spielbeschreibung
- [SwiftRandom](https://github.com/thellimist/SwiftRandom) (MIT): Für unterschiedliche Zufallszahlen in den Spielen
- [UICountingLabel](https://github.com/dataxpress/UICountingLabel) (MIT): Für die animierte Anzeige der Punkte



Die App ist primär für das iPhone 7 optimiert, ist aber auch auf dem iPad lauffähig. Deployment target ist iOS 10.3.
