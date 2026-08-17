import QtQuick
import QtQuick.Controls

Item {
    id: sessionSelector
    
    width: 400
    height: 48  

    // Variable para almacenar el índice de la sesión seleccionada
    property alias currentIndex: comboBox.currentIndex

    ComboBox {
        id: comboBox
        anchors.fill: parent
        
        // Conectamos el ComboBox directamente al modelo de sesiones de SDDM
        model: sessionModel
        
        // SDDM guarda el nombre de la sesión en la propiedad "name" del modelo
        textRole: "name" 
        
        // Al iniciar, selecciona la última sesión que usó el usuario
        Component.onCompleted: currentIndex = sessionModel.lastIndex

        // Estilo del ComboBox
        background: Rectangle {
            color: "#E0E0E0"
            radius: 16
        }

        // Diseño del botón principal del ComboBox (el que muestra la sesión seleccionada)
        contentItem: Item {
            anchors.fill: parent
            
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
                    text: comboBox.currentText
                    color: "#333333"
                    font.pixelSize: 16
                    anchors.verticalCenter: parent.verticalCenter
                    width: parent.width - 32 
                    elide: Text.ElideRight
                }
            }
        }

        // Diseño del selecionable que aparece al hacer clic en el ComboBox
        popup: Popup {
            y: comboBox.height + 8
            width: comboBox.width
            padding: 5

            contentItem: ListView {
                clip: true
                implicitHeight: contentHeight
                model: comboBox.popup.visible ? comboBox.delegateModel : null
                currentIndex: comboBox.highlightedIndex
            }

            background: Rectangle {
                color: "#E0E0E0"
                radius: 16
            }
        }

        // Diseño de cada elemento del ComboBox (cada sesión disponible)
        delegate: ItemDelegate {
            width: comboBox.width - 10
            height: 48
            
            contentItem: Text {
                // Lee el nombre de la sesión desde el modelo de SDDM
                text: model.name 
                color: "#333333"
                font.pixelSize: 16
                verticalAlignment: Text.AlignVCenter

                leftPadding: 10
            }
            
            background: Rectangle {
                // Si pasas el ratón por encima, se oscurece para que sepas qué vas a elegir
                color: parent.hovered ? "#C0C0C0" : "#E0E0E0"
                radius: 8
            }
        }
    }
}
