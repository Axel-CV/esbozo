import QtQuick
import QtQuick.Controls

Popup {
    id: idiomSelector
    width: 240
    padding: 6
    closePolicy: Popup.CloseOnEscape | Popup.CloseOnPressOutsideParent

    // Animación al abrir y cerrar
    enter: Transition { 
        NumberAnimation { 
            property: "opacity"
            from: 0.0
            to: 1.0
            duration: 150 
        }     
    }
    exit: Transition { 
        NumberAnimation { 
            property: "opacity"
            from: 1.0
            to: 0.0
            duration: 100 
        } 
    }

    background: Rectangle {
        color: "#D91E1E1E"
        radius: 16
        border.color: "#33ffffff"
        border.width: 1
    }

    // Lista de teclados
    contentItem: ListView {
        implicitHeight: Math.min(contentHeight, 260)
        clip: true
        spacing: 4
        model: keyboard.layouts

        delegate: Rectangle {
            width: parent.width
            height: 52
            radius: 8

            // Cambiar el color de fondo si el elemento está seleccionado o si el mouse está sobre él
            property bool isSelected: index === keyboard.currentLayout
            property bool isHovered: mouseArea.containsMouse

            Behavior on color { ColorAnimation { duration: 150 } }
            color: {
                if (isSelected && isHovered) return "#4Dffffff" // 30% blanco (Seleccionado + Hover)
                if (isSelected) return "#33ffffff"              // 20% blanco (Solo seleccionado)
                if (isHovered) return "#1Affffff"               // 10% blanco (Solo hover)
                return "transparent"                              // Estado normal
            }

            // Mostrar el nombre del idioma y el nombre largo del teclado
            Column {
                anchors.left: parent.left
                anchors.leftMargin: 12
                anchors.verticalCenter: parent.verticalCenter
                Text { 
                    text: longName
                    color: isSelected ? "#ffffff" : "#dddddd" 
                    font.pixelSize: 15 
                    font.weight: isSelected ? Font.DemiBold : Font.Normal
                }
                Text { 
                    text: qsTr("Teclado ") + longName
                    color: isSelected ? "#bbbbbb" : "#888888" 
                    font.pixelSize: 11 
                }
            }

            MouseArea {
                id: mouseArea
                anchors.fill: parent
                hoverEnabled: true
                cursorShape: Qt.PointingHandCursor
                onClicked: {
                    keyboard.currentLayout = index
                    idiomSelector.close()
                }
            }
        }
    }
}
