import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Effects
import "Components"

Item {
    id: root
    width: Screen.width
    height: Screen.height

    property bool showLoginScreen: false

    // Fondo
    Image {
        id: backgroundImage
        anchors.fill: parent
        source: config.BackgroundImage
        fillMode: Image.PreserveAspectCrop
    }

    // Pantalla inicial
    Item {
        id: initialScreen
        anchors.fill: parent

        // Esconder la pantalla inicial cuando se muestre la pantalla de login
        opacity: root.showLoginScreen ? 0 : 1
        visible: opacity > 0

        // Animación transición (fade in / fade out)
        Behavior on opacity { NumberAnimation { duration: 300 } }

        // Detecar de clics y teclas para mostrar la pantalla de login
        MouseArea {
            anchors.fill: parent
            onClicked: root.showLoginScreen = true
        }
        
        Keys.onPressed: (event) => {
            root.showLoginScreen = true
            event.accepted = true
        }

        // Reloj
                Clock {
            anchors.centerIn: parent
        }
    }

    // Pantalla de login
    Item {
        id: loginScreen
        anchors.fill: parent
        
        // Esconder la pantalla de login cuando se muestre la pantalla inicial
        opacity: root.showLoginScreen ? 1 : 0
        visible: opacity > 0

        // Animación transición (fade in / fade out)
        Behavior on opacity { NumberAnimation { duration: 300 } }
    }
}
