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
        if (!sessionName)
            return "../Assets/icons/wayland.svg"

        var name = sessionName.toLowerCase()

        var icons = {
            "kde":        "../Assets/icons/kde-plasma.svg",
            "plasma":     "../Assets/icons/kde-plasma.svg",
            "hyprland":   "../Assets/icons/hyprland.svg",
            "wayland":    "../Assets/icons/wayland.svg",
        }

        for (var key in icons) {
            if (name.includes(key))
                return icons[key]
        }

        // Fallback
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
    Component.onCompleted: {
        updateSessionList()
    }

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
        color: "#E0E0E0"
        radius: 16

        // Indicador visual de enfoque
        border.width: sessionSelector.activeFocus ? 2 : 0
        border.color: "#3d7eff"

        Row {
            anchors.fill: parent
            anchors.leftMargin: 15
            anchors.rightMargin: 15
            spacing: 12
            
            Image {
                source: getSessionIcon(buttonText.text)
                width: 32
                height: 32
                anchors.verticalCenter: parent.verticalCenter
                fillMode: Image.PreserveAspectFit
            }
            
            Text {
                id: buttonText
                text: "Cargando..."
                color: "#333333"
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
                sessionPopup.open()
            }
        }
    }

    // Popup para mostrar la lista de sesiones disponibles
    Popup {
        id: sessionPopup
        y: sessionSelector.height + 8
        width: sessionSelector.width
        padding: 5
        
        implicitHeight: Math.min((sessionModel ? sessionModel.count * 48 : 0) + 10, 240)

        background: Rectangle {
            color: "#E0E0E0"
            radius: 16
        }

        contentItem: ListView {
            id: listView
            clip: true
            model: sessionModel
            
            delegate: ItemDelegate {
                width: sessionPopup.width - 10
                height: 48
                
                contentItem: Row {
                    anchors.verticalCenter: parent.verticalCenter
                    spacing: 12
                    leftPadding: 10

                    Image {
                        source: getSessionIcon(model.name)
                        width: 28
                        height: 28
                        anchors.verticalCenter: parent.verticalCenter
                        fillMode: Image.PreserveAspectFit
                    }

                    Text {
                        text: model.name || ""
                        color: "#333333"
                        font.pixelSize: 16
                        anchors.verticalCenter: parent.verticalCenter
                    }
                }
                
                background: Rectangle {
                    color: parent.hovered || parent.highlighted ? "#C0C0C0" : "transparent"
                    radius: 8
                }

                onClicked: sessionSelector.selectSession(index)
            }
        }
    }
    // Manejo de teclas para navegación y selección
    Keys.onPressed: function(event) {
        if (sessionPopup.visible) {
            if (event.key === Qt.Key_Down) {
                listView.currentIndex = Math.min(listView.currentIndex + 1, sessionModel.count - 1)
                event.accepted = true
            } else if (event.key === Qt.Key_Up) {
                listView.currentIndex = Math.max(listView.currentIndex - 1, 0)
                event.accepted = true
            } else if (event.key === Qt.Key_Return || event.key === Qt.Key_Enter) {
                selectSession(listView.currentIndex)
                event.accepted = true
            } else if (event.key === Qt.Key_Escape) {
                sessionPopup.close()
                event.accepted = true
            }
        } else if (event.key === Qt.Key_Return || event.key === Qt.Key_Enter || event.key === Qt.Key_Space) {
            listView.currentIndex = currentIndex
            sessionPopup.open()
            event.accepted = true
        }
    }
}
