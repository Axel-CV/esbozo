import QtQuick
import QtQuick.Controls

FocusScope {
    id: sessionSelector
    
    width: 400
    height: 48

    // Índice de la sesión seleccionada
    property int currentIndex: sessionModel ? sessionModel.lastIndex : 0
    property var sessionNames: []

    // Función para obtener el icono de la sesión según su nombre
    function getSessionIcon(sessionName) {
        if (!sessionName) return "../Assets/icons/wayland.svg"

        var name = sessionName.toLowerCase()
        
        var icons = {
            "kde":        "../Assets/icons/kde-plasma.svg",
            "plasma":     "../Assets/icons/kde-plasma.svg",
            "hyprland":   "../Assets/icons/hyprland.svg",
            "wayland":    "../Assets/icons/wayland.svg",
        }

        for (var key in icons) {
            if (name.includes(key)) return icons[key]
        }

        return "../Assets/icons/kde-plasma.svg"
    }

    // Repeater para actualizar la lista de nombres de sesión
    Repeater {
        model: sessionModel
        onCountChanged: updateSessionList()
        onModelChanged: updateSessionList()
        
        delegate: Item {
            Component.onCompleted: {
                sessionSelector.sessionNames[index] = model.name
                sessionSelector.updateButtonText()
            }
        }
    }

     // Actualizar la lista de nombres de sesión y el texto del botón al cargar el componente
    Component.onCompleted: updateSessionList()

    // Función para actualizar la lista de nombres de sesión y el texto del botón
    function updateSessionList() {
        if (sessionModel && sessionModel.count > 0) {
            if (currentIndex < 0 || currentIndex >= sessionModel.count) {
                currentIndex = sessionModel.lastIndex >= 0 ? sessionModel.lastIndex : 0
            }
            updateButtonText()
        }
    }

    // Función para actualizar el texto del botón según la sesión seleccionada
    function updateButtonText() {
        if (sessionNames[currentIndex]) {
            buttonText.text = sessionNames[currentIndex]
        } else if (sessionModel && sessionModel.count > 0) {
            buttonText.text = "Seleccionar sesión"
        }
    }

    function selectSession(index) {
        if (index < 0 || index >= sessionModel.count) return
        currentIndex = index
        buttonText.text = sessionNames[index]
        if (typeof sddm !== "undefined" && sddm && ("sessionIndex" in sddm)) {
            sddm.sessionIndex = index
        }
        sessionPopup.close()
    }

    // Selector para abrir el popup de selección de sesión
    Rectangle {
        id: mainButton
        anchors.fill: parent
        color: sessionSelector.activeFocus ? "#33ffffff" : "#1Affffff"
        radius: 8

        // Inficador visual de enfoque 
        border.width: sessionSelector.activeFocus ? 1 : 0
        border.color: "#33ffffff"
        
        Behavior on color { ColorAnimation { duration: 150 } }

        Row {
            anchors.fill: parent
            anchors.leftMargin: 16
            anchors.rightMargin: 16
            spacing: 16
            
            Image {
                source: getSessionIcon(buttonText.text)
                width: 24
                height: 24
                anchors.verticalCenter: parent.verticalCenter
                fillMode: Image.PreserveAspectFit
            }
            
            Text {
                id: buttonText
                text: "Cargando..."
                color: "#ffffff"
                font.pixelSize: 16
                anchors.verticalCenter: parent.verticalCenter
                width: parent.width - 32
                elide: Text.ElideRight
            }
        }

        MouseArea {
            anchors.fill: parent
            cursorShape: Qt.PointingHandCursor
            onClicked: {
                sessionSelector.forceActiveFocus()
                sessionPopup.visible ? sessionPopup.close() : sessionPopup.open()
            }
        }
    }

    // Si el FocusScope tiene el foco y se presiona Enter, abre el popup
    Keys.onPressed: function(event) {
        if (!sessionPopup.visible && (event.key === Qt.Key_Return || event.key === Qt.Key_Enter || event.key === Qt.Key_Space)) {
            sessionPopup.open()
            event.accepted = true
        }
    }

    // Popup para mostrar la lista de sesiones disponibles
    Popup {
        id: sessionPopup
        y: sessionSelector.height + 8
        width: sessionSelector.width
        padding: 8
        closePolicy: Popup.CloseOnEscape | Popup.CloseOnPressOutsideParent
        
        property int highlightedIndex: sessionSelector.currentIndex

        onOpened: {
            highlightedIndex = sessionSelector.currentIndex
            listView.positionViewAtIndex(highlightedIndex, ListView.Contain)
            listView.forceActiveFocus()
        }

        enter: Transition { NumberAnimation { property: "opacity"; from: 0.0; to: 1.0; duration: 150 } }
        exit: Transition { NumberAnimation { property: "opacity"; from: 1.0; to: 0.0; duration: 100 } }

        background: Rectangle {
            color: "#D91E1E1E"
            radius: 16
            border.color: "#33ffffff"
            border.width: 1
        }

        contentItem: ListView {
            id: listView
            implicitHeight: Math.min(contentHeight, 260)
            clip: true
            spacing: 4
            model: sessionModel
            focus: true

            delegate: Rectangle {
                width: parent.width
                height: 52
                radius: 8

                // Lógica de estados idéntica al teclado
                property bool isApplied: index === sessionSelector.currentIndex
                property bool isHighlighted: index === sessionPopup.highlightedIndex
                property bool isHovered: mouseArea.containsMouse

                Behavior on color { ColorAnimation { duration: 150 } }
                color: {
                    if (isHighlighted && isHovered) return "#4Dffffff" 
                    if (isHighlighted) return "#33ffffff"              
                    if (isHovered) return "#1Affffff"               
                    return "transparent"                              
                }

                Row {
                    anchors.fill: parent
                    anchors.leftMargin: 12
                    anchors.rightMargin: 12
                    spacing: 12

                    Image {
                        source: getSessionIcon(model.name)
                        width: 24
                        height: 24
                        anchors.verticalCenter: parent.verticalCenter
                        fillMode: Image.PreserveAspectFit
                    }

                    Column {
                        anchors.verticalCenter: parent.verticalCenter
                        Text { 
                            text: model.name || ""
                            color: isHighlighted ? "#ffffff" : "#dddddd" 
                            font.pixelSize: 15 
                            font.weight: isHighlighted ? Font.DemiBold : Font.Normal
                        }
                        Text { 
                            text: isApplied ? qsTr("Sesión activa") : qsTr("Entorno de escritorio")
                            color: isHighlighted ? "#bbbbbb" : "#888888" 
                            font.pixelSize: 11 
                        }
                    }
                }

                MouseArea {
                    id: mouseArea
                    anchors.fill: parent
                    hoverEnabled: true
                    cursorShape: Qt.PointingHandCursor
                    onEntered: sessionPopup.highlightedIndex = index
                    onClicked: sessionSelector.selectSession(index)
                }
            }

            // Manejo de teclas para navegación y selección
            Keys.onPressed: function(event) {
                var itemsCount = listView.count
                if (event.key === Qt.Key_Down) {
                    sessionPopup.highlightedIndex = Math.min(sessionPopup.highlightedIndex + 1, itemsCount - 1)
                    listView.positionViewAtIndex(sessionPopup.highlightedIndex, ListView.Contain)
                    event.accepted = true
                } else if (event.key === Qt.Key_Up) {
                    sessionPopup.highlightedIndex = Math.max(sessionPopup.highlightedIndex - 1, 0)
                    listView.positionViewAtIndex(sessionPopup.highlightedIndex, ListView.Contain)
                    event.accepted = true
                } else if (event.key === Qt.Key_Return || event.key === Qt.Key_Enter) {
                    sessionSelector.selectSession(sessionPopup.highlightedIndex)
                    event.accepted = true
                }
            }
        }
    }
}
