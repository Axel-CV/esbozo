import QtQuick
import QtQuick.Controls

Popup {
    id: idiomSelector
    width: 240
    padding: 6
    closePolicy: Popup.CloseOnEscape | Popup.CloseOnPressOutsideParent
    
    property int highlightedIndex: keyboard.currentLayout

    onOpened: {
        highlightedIndex = keyboard.currentLayout
        listView.positionViewAtIndex(highlightedIndex, ListView.Contain)
        listView.forceActiveFocus()
    }

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
        color: config.PopupBackground
        radius: config.RadiusLarge
        border.color: config.PopupBorder
        border.width: 1
    }

    // Lista de teclados
    contentItem: ListView {
        id: listView
        implicitHeight: Math.min(contentHeight, 260)
        clip: true
        spacing: 4
        model: keyboard.layouts

        focus: true

        delegate: Rectangle {
            width: parent.width
            height: 52
            radius: config.RadiusSmall

            // Cambiar el color de fondo si el elemento está seleccionado o si el mouse está sobre él
            property bool isApplied: index === keyboard.currentLayout
            property bool isHighlighted: index === idiomSelector.highlightedIndex
            property bool isHovered: mouseArea.containsMouse

            Behavior on color { ColorAnimation { duration: 150 } }
            color: {
                if (isHighlighted && isHovered) return "#4Dffffff" // 30% blanco (Seleccionado + Hover)
                if (isHighlighted) return "#33ffffff"              // 20% blanco (Solo seleccionado)
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
                    color: isHighlighted ? config.TextPrimary : config.TextItem
                    font.family: config.FontFamily
                    font.pixelSize: config.FontSizeItem
                    font.weight: isHighlighted ? Font.DemiBold : Font.Normal
                }
                Text { 
                    text: qsTr("Teclado ") + longName + (isApplied ? qsTr(" - Activo") : "")
                    color: isHighlighted ? config.TextSubtle : config.TextMuted
                    font.family: config.FontFamily
                    font.pixelSize: config.FontSizeSmall
                }
            }

            MouseArea {
                id: mouseArea
                anchors.fill: parent
                hoverEnabled: true
                cursorShape: Qt.PointingHandCursor
                onEntered: idiomSelector.highlightedIndex = index
                onClicked: {
                    keyboard.currentLayout = index
                    idiomSelector.close()
                }
            }
        }
        Keys.onPressed: function(event) {
            var count = keyboard.layouts.count !== undefined ? keyboard.layouts.count : listView.count

            if (event.key === Qt.Key_Down) {
                highlightedIndex = Math.min(highlightedIndex + 1, count - 1)
                listView.positionViewAtIndex(highlightedIndex, ListView.Contain)
                event.accepted = true
            } else if (event.key === Qt.Key_Up) {
                highlightedIndex = Math.max(highlightedIndex - 1, 0)
                listView.positionViewAtIndex(highlightedIndex, ListView.Contain)
                event.accepted = true
            } else if (event.key === Qt.Key_Return || event.key === Qt.Key_Enter) {
                keyboard.currentLayout = highlightedIndex
                idiomSelector.close()
                event.accepted = true
            }
        }
    }
}
