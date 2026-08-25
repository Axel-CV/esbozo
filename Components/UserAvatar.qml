import QtQuick
import Qt5Compat.GraphicalEffects

Item {
    id: avatarComponent

    // Iniciamos con lastUser
    property string selectedUser: userModel.lastUser || ""
    property string selectedIcon: ""
    property bool expanded: false

    property int selectedIndex: 0
    
    // Posición base para el cálculo de los índices en el carrusel
    property int baseIndex: 0

    // Cuando el menú se abre, actualizamos el baseIndex para reiniciar la fila
    onExpandedChanged: {
        if (expanded) {
            baseIndex = selectedIndex;
        }
    }

    width: parent.width
    height: 160 + usernameText.implicitHeight + 8

    Item {
        id: carouselContainer
        width: parent.width
        height: 160
        anchors.top: parent.top

        Repeater {
            model: userModel

            delegate: Item {
                id: delegateItem
                
                // Variable para saber que usuario está seleccionado
                readonly property bool isSelected: name === avatarComponent.selectedUser
                
                // Rotar las posiciones de los usuarios en el carrusel para que el seleccionado siempre esté en el centro
                readonly property int circularIndex: {
                    if (userModel.count === 0) return 0;
                    return (index - avatarComponent.baseIndex + userModel.count) % userModel.count;
                }
                
                // Calcular el índice del usuario actualmente seleccionado en el carrusel
                readonly property int targetCircularIndex: {
                    if (userModel.count === 0) return 0;
                    return (avatarComponent.selectedIndex - avatarComponent.baseIndex + userModel.count) % userModel.count;
                }

                // Calcular el desplazamiento del usuario actual respecto al seleccionado
                readonly property int offsetIndex: circularIndex - targetCircularIndex

                // Tamaño y opacidad del avatar según si está seleccionado o no
                width: isSelected ? 160 : 120
                height: isSelected ? 160 : 120
                opacity: isSelected ? 1.0 : (avatarComponent.expanded ? 0.16 : 0.0)
                z: isSelected ? 10 : 0 

                Component.onCompleted: {
                    if (avatarComponent.selectedUser === "" && index === 0) {
                        avatarComponent.selectedUser = name;
                        avatarComponent.selectedIcon = icon;
                        avatarComponent.selectedIndex = index;
                        avatarComponent.baseIndex = index;
                    } else if (name === avatarComponent.selectedUser) {
                        avatarComponent.selectedIndex = index;
                        avatarComponent.selectedIcon = icon;
                        avatarComponent.baseIndex = index;
                    }
                }

                Connections {
                    target: avatarComponent
                    function onSelectedUserChanged() {
                        if (name === avatarComponent.selectedUser) {
                            avatarComponent.selectedIndex = index;
                            avatarComponent.selectedIcon = icon;
                        }
                    }
                }

                // Calcular la posición X del avatar en el carrusel
                function getCenterX() {
                    let centerOfScreen = carouselContainer.width / 2;

                    // Si está cerrado, todos se ocultan en el centro (detrás del seleccionado)
                    if (!avatarComponent.expanded && !isSelected) {
                        return centerOfScreen;
                    }

                    // El usuario seleccionado va al centro
                    if (offsetIndex === 0) return centerOfScreen;

                    // Los demás usuarios se colocan a la izquierda o derecha del seleccionado
                    if (offsetIndex > 0) {
                        // Usuarios a la derecha
                        return centerOfScreen + 164 + (offsetIndex - 1) * 144;
                    } else {
                        // Usuarios a la izquierda
                        return centerOfScreen - 164 + (offsetIndex + 1) * 144;
                    }
                }

                // Colocar el avatar en la posición calculada
                x: getCenterX() - (width / 2)
                y: (carouselContainer.height - height) / 2

                // TODO: Agregar animación para la selección de usuario y el cambio de posición en el carrusel

                Rectangle { 
                    id: mainMask
                    anchors.fill: parent
                    radius: width / 2
                    color: "#D9D9D9" 
                }
                Image {
                    id: mainImg
                    anchors.fill: parent
                    source: avatarComponent.selectedIcon || "../Assets/avatars/default_avatar.jpeg"
                    fillMode: Image.PreserveAspectCrop
                    visible: false
                }
                OpacityMask { 
                    anchors.fill: parent
                    source: mainImg
                    maskSource: mainMask 
                }

                MouseArea {
                    anchors.fill: parent
                    // Desactiva el cursor de mano si solo hay 1 usuario en el sistema
                    cursorShape: userModel.count > 1 ? Qt.PointingHandCursor : Qt.ArrowCursor
                    onClicked: {
                        if (isSelected) {
                            if (userModel.count > 1) {
                                avatarComponent.expanded = !avatarComponent.expanded;
                            }
                        } else {
                            avatarComponent.selectedUser = name;
                            avatarComponent.selectedIcon = icon;
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
        anchors.topMargin: 8
        anchors.horizontalCenter: parent.horizontalCenter
        text: avatarComponent.selectedUser
        color: "white"
        font.pixelSize: 24
        font.weight: Font.Regular
    }
}
