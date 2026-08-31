import QtQuick

Item {
    id: statusToast

    property bool isError: false
    property int duration: 3500

    width: Math.min(parent ? parent.width * 0.8 : 400, messageText.implicitWidth + 40)
    height: messageText.implicitHeight + 16

    opacity: 0
    visible: opacity > 0

    Behavior on opacity { NumberAnimation { duration: 180 } }

    function show(msg, error) {
        messageText.text = msg || ""
        statusToast.isError = !!error
        statusToast.opacity = 1
        hideTimer.restart()
    }

    function clear() {
        statusToast.opacity = 0
        hideTimer.stop()
    }

    onOpacityChanged: {
        if (opacity === 0) {
            messageText.text = ""
        }
    }

    Rectangle {
        anchors.fill: parent
        radius: config.RadiusMedium
        color: statusToast.isError ? config.ErrorBackground : config.InfoBackground
        border.width: 1
        border.color: statusToast.isError ? config.ErrorBorder : config.InfoBorder
    }

    Text {
        id: messageText
        anchors.centerIn: parent
        width: parent.width - 24
        horizontalAlignment: Text.AlignHCenter
        wrapMode: Text.WordWrap
        color: statusToast.isError ? config.ErrorText : config.SuccessText
        font.family: config.FontFamily
        font.pixelSize: config.FontSizeBody
        font.weight: Font.Medium
        text: ""
    }

    Timer {
        id: hideTimer
        interval: statusToast.duration
        onTriggered: statusToast.clear()
    }
}
