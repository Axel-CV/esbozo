import QtQuick

Item {
    id: statusToast

    property bool isError: false
    property int duration: 3500

    width: Math.min(parent ? parent.width * 0.8 : 400, messageText.implicitWidth + 40)
    height: messageText.implicitHeight + 16
    opacity: messageText.text.length > 0 ? 1 : 0
    visible: opacity > 0

    Behavior on opacity { NumberAnimation { duration: 180 } }

    function show(msg, error) {
        messageText.text = msg || ""
        statusToast.isError = !!error
        hideTimer.restart()
    }

    function clear() {
        messageText.text = ""
        hideTimer.stop()
    }

    Rectangle {
        anchors.fill: parent
        radius: 12
        color: statusToast.isError ? "#66B00000" : "#66000000"
        border.width: 1
        border.color: statusToast.isError ? "#88FF6B6B" : "#33FFFFFF"
    }

    Text {
        id: messageText
        anchors.centerIn: parent
        width: parent.width - 24
        horizontalAlignment: Text.AlignHCenter
        wrapMode: Text.WordWrap
        color: statusToast.isError ? "#FF8A8A" : "#E8E8E8"
        font.pixelSize: 14
        font.weight: Font.Medium
        text: ""
    }

    Timer {
        id: hideTimer
        interval: statusToast.duration
        onTriggered: statusToast.clear()
    }
}
