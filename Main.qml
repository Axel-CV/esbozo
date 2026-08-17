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
            id: mainClock
            // Centar el reloj horizontalmente
            anchors.horizontalCenter: parent.horizontalCenter
            // Anclar el reloj en la parte superior de la pantalla
            anchors.top: parent.top
            // Ajustar la posición vertical del reloj para que quede más abajo
            anchors.topMargin: 80
        }

        LoginPrompt {
            id: loginPrompt
            // Centrar el texto horizontalmente
            anchors.horizontalCenter: parent.horizontalCenter
            // Anclar al borde inferior de la pantalla
            anchors.bottom: parent.bottom
            // Ajustar la posición vertical del texto para que quede más arriba
            anchors.bottomMargin: 80
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
