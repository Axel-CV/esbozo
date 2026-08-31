import QtQuick

Item {
    id: clockContainer
    
    // Adaptar el tamaño del contenedor al tamaño de sus hijos (hora y fecha)
    width: childrenRect.width
    height: childrenRect.height

    // Almacena la fecha y hora actual
    property var currentDate: new Date()

    // Actualiza la hora y la fecha cada segundo
    Timer {
        id: timeUpdater
        interval: 1000
        running: true
        repeat: true
        onTriggered: clockContainer.currentDate = new Date()
    }

    // Columna para apilar la hora arriba y la fecha abajo
    Column {
        spacing: 8

        // Texto de la hora
        Text {
            id: timeText
            // Formatea la hora actual a "00:00" (formato de 24 horas)
            text: Qt.formatTime(clockContainer.currentDate, "hh:mm")
            color: config.TextPrimary
            font.family: config.FontFamily
            font.pixelSize: config.FontSizeClock
            font.weight: Font.Normal
            horizontalAlignment: Text.AlignHCenter
            anchors.horizontalCenter: parent.horizontalCenter
        }

        // Texto de la fecha
        Text {
            id: dateText
            // Formatea la fecha al estilo: "lunes, 1 de enero, 2000"
            text: Qt.formatDateTime(clockContainer.currentDate, "dddd, d 'de' MMMM, yyyy")
            color: config.TextSecondary
            font.family: config.FontFamily
            font.pixelSize: config.FontSizeDate
            font.weight: Font.Normal
            horizontalAlignment: Text.AlignHCenter
            anchors.horizontalCenter: parent.horizontalCenter
        }
    }
}
