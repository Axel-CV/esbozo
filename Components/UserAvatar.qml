import QtQuick
import QtQuick.Controls
import Qt5Compat.GraphicalEffects

FocusScope {
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

    // Cerrar el carrusel si se pierde el foco
    onActiveFocusChanged: {
        if (!activeFocus && expanded) {
            expanded = false
        }
    }

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

            Item {
                id: visualWrapper
                width: parent.width
                height: parent.height

                // Calculamos matemáticamente la distancia hacia el centro del avatar actual
                property real targetOffsetX: {
                    let list = delegateavatarComponent.ListView.view
                    if (list && list.currentItem) {
                        let centerOfCurrent = list.currentItem.x + (list.currentItem.width / 2)
                        let myCenter = delegateavatarComponent.x + (delegateavatarComponent.width / 2)
                        return centerOfCurrent - myCenter
                    }
                    return 0
                }

                // Si el avatar no está expandido y no es el item actual, aplicamos un desplazamiento hacia el centro del avatar actual
                x: (!avatarComponent.expanded && !delegateavatarComponent.ListView.isCurrentItem) ? targetOffsetX : 0

                // Tu lógica de opacidad y escala intactas
                opacity: avatarComponent.expanded || delegateavatarComponent.ListView.isCurrentItem ? 1.0 : 0.0
                visible: opacity > 0
                scale: delegateavatarComponent.ListView.isCurrentItem ? 1.0 : 0.85

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
                    border.color: "transparent"
                    border.width: 3
                    opacity: 0.7
                }

                MouseArea {
                    anchors.fill: parent
                    // Desactiva el cursor de mano si solo hay 1 usuario en el sistema
                    cursorShape: userModel.count > 1 ? Qt.PointingHandCursor : Qt.ArrowCursor
                    onClicked: {
                        // Forzar el foco en el componente de avatar
                        avatarComponent.forceActiveFocus()

                        if (delegateavatarComponent.ListView.isCurrentItem) {
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
    }

    // Nombre del usuario seleccionado
    Text {
        id: usernameText
        anchors.top: carouselContainer.bottom
        anchors.topMargin: 12
        anchors.horizontalCenter: parent.horizontalCenter
        text: avatarComponent.selectedUser
        color: config.TextPrimary
        font.family: config.FontFamily
        font.pixelSize: config.FontSizeUsername
        font.weight: Font.Medium
    }

    // Manejo de teclas para navegación y selección
    focus: true
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
            if (avatarComponent.expanded) {
                avatarComponent.expanded = false
                event.accepted = true
            } else {
                // Si ya está cerrado, dejamos que Escape suba (por si el padre quiere hacer algo)
                event.accepted = false
            }
        } else if (event.key === Qt.Key_Tab || event.key === Qt.Key_Backtab || event.key === Qt.Key_Up || event.key === Qt.Key_Down) {
            if (avatarComponent.expanded) {
                avatarComponent.expanded = false
                event.accepted = false
            }
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
