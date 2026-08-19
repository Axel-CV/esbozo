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

        // Mensaje para cambiar a la vista de login
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

        // Selector de sesión
        SessionSelector {
            id: sessionSelector
            anchors.top: parent.top
            anchors.left: parent.left
            
            // Ajustar la posición del selector de sesión
            anchors.topMargin: 40
            anchors.leftMargin: 40
        }

        // Componente de avatar y nombre de usuario
        Column {
            anchors.centerIn: parent
            spacing: 30

            UserAvatar {
                id: userSwitcher
                anchors.horizontalCenter: parent.horizontalCenter
            }

            PasswordField {
                id: passwordField
                anchors.horizontalCenter: parent.horizontalCenter
                onLoginRequested: (password) => {
                    sddm.login(userSwitcher.selectedUser, password, sessionSelector.sessionIndex)
                }
            }
        }

        // Botones del sistema (suspender, hibernar, reiniciar, apagar)
        Row {
            // Los anclamos al fondo y al centro horizontal
            anchors.bottom: parent.bottom
            anchors.bottomMargin: 200
            anchors.horizontalCenter: parent.horizontalCenter
            
            // Setear el espacio entre los botones
            spacing: 64

            SystemIconButton {
                iconSource: "../Assets/icons/button_sleep.svg"
                onClicked: sddm.suspend()
            }

            SystemIconButton {
                iconSource: "../Assets/icons/button_hibernate.svg"
                onClicked: sddm.hibernate()
            }

            SystemIconButton {
                iconSource: "../Assets/icons/button_reboot.svg"
                onClicked: sddm.reboot()
            }

            SystemIconButton {
                iconSource: "../Assets/icons/button_poweroff.svg"
                onClicked: sddm.powerOff()
            }

            SystemIconButton {
                id: languageButton
                iconSource: "../Assets/icons/button_change_language.svg"
                active: keyboardPopup.visible
                onClicked: keyboardPopup.visible ? keyboardPopup.close() : keyboardPopup.open()
            }

            KeyboardSelector {
                id: keyboardPopup
                parent: languageButton
                x: (languageButton.width - width) / 2
                y: -height - 12
            }
        }
    }
}
