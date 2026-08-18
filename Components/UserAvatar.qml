import QtQuick
import Qt5Compat.GraphicalEffects

Item {
    id: avatarComponent

    // Iniciamos con lastUser. Si por algún motivo está vacío, el Repeater lo corregirá.
    property string selectedUser: userModel.lastUser || ""
    property string selectedIcon: ""
    property bool expanded: false

    width: row.implicitWidth
    height: 160 + usernameText.implicitHeight + 8

    // CONTROLADOR OCULTO: Resuelve el problema del "usuario fantasma" y asigna íconos
    Repeater {
        model: userModel
        delegate: Item {
            visible: false
            
            Component.onCompleted: {
                // 1. Si no hay un último usuario guardado, forzamos a que el PRIMER usuario real (index 0) sea el principal
                if (avatarComponent.selectedUser === "" && index === 0) {
                    avatarComponent.selectedUser = name
                    avatarComponent.selectedIcon = icon
                }
                
                // 2. Si este delegado coincide con el usuario seleccionado, extraemos su ícono
                if (name === avatarComponent.selectedUser) {
                    avatarComponent.selectedIcon = icon
                }
            }

            // 3. Mantiene el ícono sincronizado automáticamente si cambias de usuario
            Connections {
                target: avatarComponent
                function onSelectedUserChanged() {
                    if (name === avatarComponent.selectedUser) {
                        avatarComponent.selectedIcon = icon
                    }
                }
            }
        }
    }

    Row {
        id: row
        anchors.horizontalCenter: parent.horizontalCenter
        spacing: 24

        // Avatar principal (usuario seleccionado)
        Item {
            id: mainAvatarItem
            width: 160; height: 160
            anchors.verticalCenter: parent.verticalCenter

            Rectangle { id: mainMask; anchors.fill: parent; radius: width / 2; color: "#D9D9D9" }
            Image {
                id: mainImg
                anchors.fill: parent
                source: avatarComponent.selectedIcon || "../Assets/avatars/default_avatar.jpeg"
                fillMode: Image.PreserveAspectCrop
                visible: false
            }
            OpacityMask { anchors.fill: parent; source: mainImg; maskSource: mainMask }

            MouseArea {
                anchors.fill: parent
                // Desactiva el cursor de mano si solo hay 1 usuario en el sistema
                cursorShape: userModel.count > 1 ? Qt.PointingHandCursor : Qt.ArrowCursor
                onClicked: {
                    if (userModel.count > 1) {
                        avatarComponent.expanded = !avatarComponent.expanded
                    }
                }
            }
        }

        // Otros usuarios disponibles
        Repeater {
            model: (avatarComponent.expanded && userModel.count > 1) ? userModel : 0
            delegate: Item {
                visible: name !== avatarComponent.selectedUser
                width: 120; height: 120
                anchors.verticalCenter: mainAvatarItem.verticalCenter

                Rectangle { 
                    id: altMask
                    anchors.fill: parent
                    radius: width / 2
                    color: "#D9D9D9" 
                }
                Image {
                    id: altImg
                    anchors.fill: parent
                    source: icon || "../Assets/avatars/default_avatar.jpeg"
                    fillMode: Image.PreserveAspectCrop
                    visible: false
                }
                OpacityMask {
                    anchors.fill: parent
                    source: altImg
                    maskSource: altMask
                    opacity: 0.16
                }

                MouseArea {
                    anchors.fill: parent
                    cursorShape: Qt.PointingHandCursor
                    onClicked: {
                        avatarComponent.selectedUser = name
                        avatarComponent.selectedIcon = icon
                        avatarComponent.expanded = false
                    }
                }
            }
        }
    }

    Text {
        id: usernameText
        anchors.top: row.bottom
        anchors.topMargin: 8
        anchors.horizontalCenter: parent.horizontalCenter
        text: avatarComponent.selectedUser
        color: "white"
        font.pixelSize: 24
        font.weight: Font.Medium
    }
}
