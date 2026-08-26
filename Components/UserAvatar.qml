import QtQuick
import QtQuick.Controls
import Qt5Compat.GraphicalEffects

Item {
    id: avatarComponent

    // Iniciamos con lastUser
    property string selectedUser: userModel.lastUser || ""
    property string selectedIcon: ""
    property int selectedIndex: 0
    // Cargar el usuario seleccionado
    function syncFromIndex(idx) {
        if (idx < 0 || idx >= userModel.count) return

        var name = userModel.data(userModel.index(idx, 0), 257) || ""
        var icon = userModel.data(userModel.index(idx, 0), 260) || ""

        avatarComponent.selectedIndex = idx
        avatarComponent.selectedUser = name
        avatarComponent.selectedIcon = icon
        avatarComponent.userChanged(name, icon)
    }

    property bool expanded: false

    // Signal para notificar cambios de usuario
    signal userChanged(string username, string icon)

    width: parent.width
    height: 160 + usernameText.implicitHeight + 8

    // Vista de los avatares de usuario en forma de lista horizontal (carrusel)
    ListView {
        id: carouselContainer
        width: parent.width
        height: 160
        anchors.top: parent.top
        anchors.horizontalCenter: parent.horizontalCenter

        orientation: ListView.Horizontal
        spacing: 24
        interactive: false
        clip: false
        model: userModel
        currentIndex: avatarComponent.selectedIndex

        // Centrar el item activo
        preferredHighlightBegin: (width - 160) / 2
        preferredHighlightEnd: preferredHighlightBegin
        highlightRangeMode: ListView.StrictlyEnforceRange
        highlightMoveDuration: 220
        highlightMoveVelocity: -1

        // Márgenes para que el item central quede bien centrado
        leftMargin: preferredHighlightBegin
        rightMargin: preferredHighlightBegin

        onCurrentIndexChanged: avatarComponent.syncFromIndex(currentIndex)

        delegate: Item {
            id: delegateavatarComponent
            width: ListView.isCurrentItem ? 160 : 120
            height: ListView.isCurrentItem ? 160 : 120

            // Solo mostrar el seleccionado cuando está cerrado
            opacity: avatarComponent.expanded || ListView.isCurrentItem ? 1.0 : 0.0
            visible: opacity > 0
            scale: ListView.isCurrentItem ? 1.0 : 0.85

            Behavior on width { 
                NumberAnimation { 
                    duration: 220
                    easing.type: Easing.OutQuad 
                } 
            }
            Behavior on height { 
                NumberAnimation { 
                    duration: 220
                    easing.type: Easing.OutQuad 
                } 
            }
            Behavior on x { 
                NumberAnimation { 
                    duration: 220
                    easing.type: Easing.OutQuad 
                } 
            }
            Behavior on opacity { 
                NumberAnimation { 
                    duration: 180 
                    easing.type: Easing.OutQuad 
                } 
            }
            Behavior on scale { 
                NumberAnimation { 
                    duration: 220; 
                    easing.type: Easing.OutQuad 
                } 
            }

            // Avatar circular
            Rectangle {
                id: mask
                anchors.fill: parent
                radius: width / 2
                visible: false
            }

            Image {
                id: avatarImage
                anchors.fill: parent
                source: model.icon || "../Assets/avatars/default_avatar.jpeg"
                fillMode: Image.PreserveAspectCrop
                visible: false
                asynchronous: true
            }

            OpacityMask {
                anchors.fill: parent
                source: avatarImage
                maskSource: mask
            }

            // Borde sutil cuando está seleccionado
            Rectangle {
                anchors.fill: parent
                radius: width / 2
                color: "transparent"
                border.color: ListView.isCurrentItem ? "#FFFFFF" : "transparent"
                border.width: 3
                opacity: 0.7
            }

            MouseArea {
                anchors.fill: parent
                // Desactiva el cursor de mano si solo hay 1 usuario en el sistema
                cursorShape: userModel.count > 1 ? Qt.PointingHandCursor : Qt.ArrowCursor
                onClicked: {
                    if (ListView.isCurrentItem) {
                        if (userModel.count > 1)
                            avatarComponent.expanded = !avatarComponent.expanded
                    } else {
                        carouselContainer.currentIndex = index
                        avatarComponent.expanded = true
                    }
                }
            }
        }
    }

    // Nombre del usuario seleccionado
    Text {
        id: usernameText
        anchors.top: carouselContainer.bottom
        anchors.topMargin: 12
        anchors.horizontalCenter: parent.horizontalCenter
        text: avatarComponent.selectedUser
        color: "white"
        font.pixelSize: 24
        font.weight: Font.Medium
    }

    // Manejo de teclas para navegación y selección
    //focus: true
    Keys.onPressed: function(event) {
        // Desactivar la navegación si hay menos o solo un usuario
        if (userModel.count <= 1) return

        if (event.key === Qt.Key_Left) {
            carouselContainer.decrementCurrentIndex()
            avatarComponent.expanded = true
            event.accepted = true
        }
        else if (event.key === Qt.Key_Right) {
            carouselContainer.incrementCurrentIndex()
            avatarComponent.expanded = true
            event.accepted = true
        }
        else if (event.key === Qt.Key_Return || event.key === Qt.Key_Enter || event.key === Qt.Key_Space) {
            avatarComponent.expanded = !avatarComponent.expanded
            event.accepted = true
        }
        else if (event.key === Qt.Key_Escape) {
            avatarComponent.expanded = false
            event.accepted = true
        }
    }

    // Inicialización
    Component.onCompleted: {
        if (userModel.count > 0) {
            var index = userModel.lastIndex

            if (typeof index !== "number" ||
                index < 0 ||
                index >= userModel.count) {
                index = 0
            }

            carouselContainer.currentIndex = index
            avatarComponent.syncFromIndex(index) 
        }
        forceActiveFocus()
    }
}
