import QtQuick
import QtQuick.Controls

FocusScope {
    id: passwordComponent
    
    // Adaptar el tamaño del contenedor al tamaño de sus hijos (caja de texto y botón)
    width: childrenRect.width
    height: 48

    // Mandar una señal para saber que el usuario quiere iniciar sesión
    signal loginRequested(string password)

    Row {
        spacing: 2

        // Campo de entrada de contraseña
        Rectangle {
            id: inputBackground
            width: 320
            height: passwordComponent.height
            color: "#E0E0E0"
            radius: 16

            // Indicador visual de enfoque
            border.width: passwordInput.activeFocus ? 2 : 0
            border.color: "#3d7eff"

            Row {
                anchors.fill: parent
                anchors.leftMargin: 15
                anchors.rightMargin: 15
                spacing: 10
                
                // Ícono del candado
                Image {
                    id: lockIcon
                    source: "../Assets/icons/lock.svg"
                    width: 20
                    height: 20
                    anchors.verticalCenter: parent.verticalCenter
                    fillMode: Image.PreserveAspectFit
                }

                // Campo de entrada de texto
                TextInput {
                    id: passwordInput
                    anchors.verticalCenter: parent.verticalCenter
                    // El ancho es todo el espacio sobrante menos el ícono y los márgenes
                    width: parent.width - lockIcon.width - parent.spacing
                    
                    font.pixelSize: 16
                    color: "#333333"
                    
                    // Ocultar el texto ingresado
                    echoMode: TextInput.Password 
                    clip: true // Evitar que el texto se salga del área visible
                    
                    // Habilitar el enfoque del campo de entrada
                    focus: true 

                    // Texto "Placeholder"
                    Text {
                        text: "Contraseña"
                        color: "#888888"
                        font.pixelSize: 16
                        anchors.verticalCenter: parent.verticalCenter
                        // Mostar el placeholder solo cuando el campo está vacío
                        visible: passwordInput.text === "" 
                    }

                    // Eventos de teclado: Cuando presionas Enter
                    Keys.onReturnPressed: passwordComponent.loginRequested(passwordInput.text)
                    Keys.onEnterPressed: passwordComponent.loginRequested(passwordInput.text)
                }
            }
        }

        // Botón de envío
        Rectangle {
            id: submitButton
            width: 48
            height: passwordComponent.height
            color: "#E0E0E0"
            radius: 16

            Image {
                anchors.centerIn: parent
                source: "../Assets/icons/login-02_door.svg"
                width: 24
                height: 24
                fillMode: Image.PreserveAspectFit
            }

            MouseArea {
                anchors.fill: parent
                // Cambiar el cursor a una mano al pasar sobre el botón
                cursorShape: Qt.PointingHandCursor
                
                // Al hacer clic, enviamos la misma señal que al presionar Enter
                onClicked: passwordComponent.loginRequested(passwordInput.text)
                
                // Animación de opacidad al presionar y soltar el botón
                onPressed: submitButton.opacity = 0.7
                onReleased: submitButton.opacity = 1.0
            }
        }
    }
    
    // Limpiar el campo de contraseña después de un intento de inicio de sesión fallido
    function clearPassword() {
        passwordInput.text = ""
    }
}
