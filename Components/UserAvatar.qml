import QtQuick
import Qt5Compat.GraphicalEffects

Item {
    id: avatarComponent
    
    width: childrenRect.width
    height: childrenRect.height

    // Propiedades para el nombre de usuario y la ruta del avatar
    property string username: "Usuario" 
    property string avatarPath: ""

    Column {
        anchors.centerIn: parent
        spacing: 8

        // Contenedor de la imagen del usuario
        Item {
            id: imageContainer
            width: 160
            height: 160
            anchors.horizontalCenter: parent.horizontalCenter

            // Circulo para la imagen del usuario
            Rectangle {
                id: maskRect
                anchors.fill: parent
                radius: width / 2
                color: "#D9D9D9"
            }

            // Imagen del usuario
            Image {
                id: userImage
                anchors.fill: parent
                source: avatarComponent.avatarPath || "../Assets/avatars/default_avatar.jpeg"
                fillMode: Image.PreserveAspectCrop
                visible: false 
            }

            // Cortar la imagen del usuario con la máscara circular
            OpacityMask {
                anchors.fill: imageContainer
                source: userImage
                maskSource: maskRect
            }
        }

        // 2. NOMBRE DE USUARIO
        Text {
            id: usernameText
            text: avatarComponent.username
            color: "white"
            font.pixelSize: 24
            font.weight: Font.Medium
            anchors.horizontalCenter: parent.horizontalCenter
        }
    }
}
