import QtQuick

Item {
    id: languageButton

    property string iconSource: "../Assets/icons/button_change_language.svg"
    property bool active: false
    property string label: "—"

    signal clicked()

    // Ajustar el tamaño del botón
    width: contentRow.width + 20
    height: 54

    // Fondo de hover que cubre texto + icono
    Rectangle {
        id: hoverBackground
        anchors.fill: parent
        radius: config.RadiusSmall
        color: config.FocusBorder
        opacity: (mouseArea.containsMouse || languageButton.active || languageButton.activeFocus) ? 0.35 : 0.0
        scale: (mouseArea.containsMouse || languageButton.active || languageButton.activeFocus) ? 1.0 : 0.92

        Behavior on opacity { NumberAnimation { duration: 160 } }
        Behavior on scale   { NumberAnimation { duration: 160 } }
    }

    Row {
        id: contentRow
        anchors.centerIn: parent
        spacing: 8

        Text {
            text: languageButton.label
            color: config.TextPrimary
            font.family: config.FontFamily
            font.pixelSize: config.FontSizeButton
            font.weight: Font.Medium
            anchors.verticalCenter: parent.verticalCenter
            opacity: mouseArea.pressed ? 0.5 : (mouseArea.containsMouse || languageButton.activeFocus ? 1.0 : 0.7)

            Behavior on opacity { NumberAnimation { duration: 150 } }
        }

        Image {
            source: languageButton.iconSource
            width: 28
            height: 28
            anchors.verticalCenter: parent.verticalCenter
            fillMode: Image.PreserveAspectFit
            opacity: mouseArea.pressed ? 0.5 : (mouseArea.containsMouse || languageButton.activeFocus ? 1.0 : 0.7)

            Behavior on opacity { NumberAnimation { duration: 150 } }
        }
    }

    MouseArea {
        id: mouseArea
        anchors.fill: parent
        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor
        onClicked: {
            languageButton.forceActiveFocus()
            languageButton.clicked()
        }
    }

    Keys.onReturnPressed: languageButton.clicked()
    Keys.onEnterPressed:  languageButton.clicked()
    Keys.onSpacePressed:  languageButton.clicked()
}
