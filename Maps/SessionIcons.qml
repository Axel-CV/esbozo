pragma Singleton
import QtQuick

QtObject {
    id: root

    // clave = texto a buscar en el nombre de la sesión
    // valor = ruta del icono
    readonly property var map: {
        "kde":        "../Assets/icons/kde-plasma.svg",
        "plasma":     "../Assets/icons/kde-plasma.svg",
        "hyprland":   "../Assets/icons/hyprland.svg",
        "wayland":    "../Assets/icons/wayland.svg",
    }

    function getSessionIcon(sessionName) {
        if (!sessionName)
            return "../Assets/icons/kde-plasma.svg"

        var name = sessionName.toLowerCase()

        for (var key in map) {
            if (name.includes(key))
                return map[key]
        }

        return "../Assets/icons/kde-plasma.svg"
    }
}
