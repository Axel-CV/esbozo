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

        // Poner el foco en la pantalla inicial al iniciar la aplicación
        Component.onCompleted: forceActiveFocus()

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

            KeyNavigation.tab: userSwitcher
            KeyNavigation.backtab: languageButton
            KeyNavigation.down: userSwitcher
        }

        // Componente de avatar y nombre de usuario
        Column {
            anchors.centerIn: parent
            spacing: 30

            UserAvatar {
                id: userSwitcher
                anchors.horizontalCenter: parent.horizontalCenter

                KeyNavigation.tab: passwordField
                KeyNavigation.backtab: sessionSelector
                KeyNavigation.up: sessionSelector
                KeyNavigation.down: passwordField
            }

            PasswordField {
                id: passwordField
                anchors.horizontalCenter: parent.horizontalCenter

                focus: true

                KeyNavigation.tab: sleepButton
                KeyNavigation.backtab: userSwitcher
                KeyNavigation.up: userSwitcher
                KeyNavigation.down: sleepButton

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
                id: sleepButton
                iconSource: "../Assets/icons/button_sleep.svg"
                onClicked: sddm.suspend()

                KeyNavigation.tab: hibernateButton
                KeyNavigation.backtab: passwordField
                KeyNavigation.up: passwordField
                KeyNavigation.left: languageButton
                KeyNavigation.right: hibernateButton
            }

            SystemIconButton {
                id: hibernateButton
                iconSource: "../Assets/icons/button_hibernate.svg"
                onClicked: sddm.hibernate()

                KeyNavigation.tab: rebootButton
                KeyNavigation.backtab: sleepButton
                KeyNavigation.up: sleepButton
                KeyNavigation.left: sleepButton
                KeyNavigation.right: rebootButton
            }

            SystemIconButton {
                id: rebootButton
                iconSource: "../Assets/icons/button_reboot.svg"
                onClicked: sddm.reboot()

                KeyNavigation.tab: poweroffButton
                KeyNavigation.backtab: hibernateButton
                KeyNavigation.up: passwordField
                KeyNavigation.left: hibernateButton
                KeyNavigation.right: poweroffButton
            }

            SystemIconButton {
                id: poweroffButton
                iconSource: "../Assets/icons/button_poweroff.svg"
                onClicked: sddm.powerOff()

                KeyNavigation.tab: languageButton
                KeyNavigation.backtab: rebootButton
                KeyNavigation.up: passwordField
                KeyNavigation.left: rebootButton
                KeyNavigation.right: languageButton
            }

            SystemIconButton {
                id: languageButton
                iconSource: "../Assets/icons/button_change_language.svg"
                active: keyboardPopup.visible
                onClicked: keyboardPopup.visible ? keyboardPopup.close() : keyboardPopup.open()

                KeyNavigation.tab: sessionSelector
                KeyNavigation.backtab: poweroffButton
                KeyNavigation.up: passwordField
                KeyNavigation.left: poweroffButton
                KeyNavigation.right: sleepButton
            }

            KeyboardSelector {
                id: keyboardPopup
                parent: languageButton
                x: (languageButton.width - width) / 2
                y: -height - 12
            }
        }
        // Comportamiento de la tecla Escape
        Keys.onPressed: function(event) {
            if (event.key === Qt.Key_Escape) {
                // Si hay un popup abierto, cerrarlo
                if (keyboardPopup.visible) {
                    keyboardPopup.close()
                } else {
                    // Si no hay popup abierto, volver a la pantalla inicial
                    root.showLoginScreen = false
                }
                event.accepted = true
            }
        }
    }

    onShowLoginScreenChanged: {
        if (showLoginScreen) {
            passwordField.forceActiveFocus()
        } else {
            initialScreen.forceActiveFocus()
        }
    }
}
