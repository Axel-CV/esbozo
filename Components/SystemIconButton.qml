import QtQuick

Item {
    id: iconButton
    
    // Variables para el ícono y su tamaño
    property string iconSource: ""
    property int iconSize: 54
    property bool active: false

    // El tamaño del área clickeable será igual al tamaño del ícono
    width: iconSize
    height: iconSize

    // Señal para notificar cuando se hace clic en el botón
    signal clicked()

    Rectangle {
        id: hoverBackground
        anchors.centerIn: parent
        width: parent.width + 16
        height: parent.height + 16
        color: "#E0E0E0"
        radius: width / 2
        opacity: (mouseArea.containsMouse || iconButton.active || iconButton.activeFocus) ? 0.35 : 0.0
        scale: (mouseArea.containsMouse || iconButton.active || iconButton.activeFocus) ? 1.0 : 0.85

        Behavior on opacity { NumberAnimation { duration: 180 } }
        Behavior on scale { NumberAnimation { duration: 180 } }
    }

    Image {
        id: buttonIcon
        anchors.fill: parent
        source: iconButton.iconSource
        fillMode: Image.PreserveAspectFit
        
        // Lógica de opacidad para dar retroalimentación visual (efecto hover):
        // Si está presionado: 50% transparente.
        // Si el mouse está encima: 100% opaco.
        // Estado normal: 70% opaco (así no distraen tanto hasta que los vas a usar).
        opacity: mouseArea.pressed ? 0.5 : (mouseArea.containsMouse || iconButton.activeFocus ? 1.0 : 0.7)
        
        // Animación suave para los cambios de opacidad
        Behavior on opacity { NumberAnimation { duration: 150 } }
    }

    // Área clickeable que cubre todo el botón
    MouseArea {
        id: mouseArea
        anchors.fill: parent
        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor
        
        onClicked: {
            iconButton.forceActiveFocus()
            iconButton.clicked()
        }
    }

    Keys.onReturnPressed: iconButton.clicked()
    Keys.onEnterPressed: iconButton.clicked()
    Keys.onSpacePressed: iconButton.clicked()
}
