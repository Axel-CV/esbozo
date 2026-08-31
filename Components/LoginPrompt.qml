import QtQuick

Item {
    id: promptContainer
    
    // Adaptar el tamaño del contenedor al tamaño de sus hijos (ícono y texto)
    width: childrenRect.width
    height: childrenRect.height

    // Animación de parpadeo para indicar que se puede interactuar
    SequentialAnimation on opacity {
        loops: Animation.Infinite
        NumberAnimation { to: 0.5; duration: 1000 }
        NumberAnimation { to: 1.0; duration: 1000 }
    }

    Column {
        spacing: 8

        // EL ÍCONO
        Image {
            id: promptIcon
            source: "../Assets/icons/login_door.svg"
            width: 32
            height: 32
            fillMode: Image.PreserveAspectFit
            anchors.horizontalCenter: parent.horizontalCenter
        }

        // EL TEXTO
        Text {
            text: "Presiona cualquier tecla"
            color: config.TextPrimary
            font.family: config.FontFamily
            font.pixelSize: config.FontSizeButton
            font.weight: Font.Normal
            anchors.horizontalCenter: parent.horizontalCenter
        }
    }
}