import QtQuick
import QtQuick.Controls

Item {
    id: sessionSelector
    
    width: 400
    height: 48  

    // Índice de la sesión seleccionada
    property int currentIndex: sessionModel ? sessionModel.lastIndex : 0
    property var sessionNames: []

    // Repeater para actualizar la lista de nombres de sesión cuando el modelo cambie
    Repeater {
        model: sessionModel
        onCountChanged: updateSessionList()
        onModelChanged: updateSessionList()
        
        delegate: Item {
            Component.onCompleted: {
                sessionSelector.sessionNames[index] = model.name;
                sessionSelector.updateButtonText();
            }
        }
    }

    // Actualizar la lista de nombres de sesión y el texto del botón al cargar el componente
    Component.onCompleted: {
        updateSessionList();
    }

    // Función para actualizar la lista de nombres de sesión y el texto del botón
    function updateSessionList() {
        if (sessionModel && sessionModel.count > 0) {
            if (currentIndex < 0 || currentIndex >= sessionModel.count) {
                currentIndex = sessionModel.lastIndex >= 0 ? sessionModel.lastIndex : 0;
            }
            updateButtonText();
        }
    }

    // Función para actualizar el texto del botón según la sesión seleccionada
    function updateButtonText() {
        if (sessionNames[currentIndex]) {
            buttonText.text = sessionNames[currentIndex];
        } else if (sessionModel && sessionModel.count > 0) {
            buttonText.text = "Seleccionar sesión";
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
                source: "../Assets/icons/wayland.svg"
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
                
                contentItem: Text {
                    text: model.name || ""
                    color: "#333333"
                    font.pixelSize: 16
                    verticalAlignment: Text.AlignVCenter
                    leftPadding: 10
                }
                
                background: Rectangle {
                    color: parent.hovered ? "#C0C0C0" : "transparent"
                    radius: 8
                }

                onClicked: {
                    currentIndex = index;
                    buttonText.text = model.name;
                    
                    // Notificar a SDDM el cambio de sesión
                    if (typeof sddm !== "undefined" && sddm && ("sessionIndex" in sddm)) {
                        sddm.sessionIndex = index;
                    }
                    
                    sessionPopup.close();
                }
            }
        }
    }
}
