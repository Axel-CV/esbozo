import QtQuick
import QtQuick.Controls

Item {
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

    // Selector para abrir el popup de selección de sesión
    Rectangle {
        id: mainButton
        anchors.fill: parent
        color: "#E0E0E0"
        radius: 16

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
            onClicked: sessionPopup.open()
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
                    color: parent.hovered ? "#C0C0C0" : "transparent"
                    radius: 8
                }

                onClicked: {
                    currentIndex = index
                    buttonText.text = model.name
                    
                    // Notificar a SDDM el cambio de sesión
                    if (typeof sddm !== "undefined" && sddm && ("sessionIndex" in sddm)) {
                        sddm.sessionIndex = index
                    }
                    
                    sessionPopup.close()
                }
            }
        }
    }
}
