pragma Singleton
import QtQuick

QtObject {
    id: root

    // clave = parte del longName en minúsculas
    // valor = código corto
    readonly property var map: {
        "latin american": "ES-LATAM",
        "latam":          "ES-LATAM",
        "spanish (mexico)": "ES-MX",
        "mexican":        "ES-MX",
        "spanish":        "ES",
        "english (us)":   "US",
        "english (uk)":   "UK",
        "british":        "UK",
        "american":       "US",
        "english":        "EN",
        "german":         "DE",
        "deutsch":        "DE",
        "french":         "FR",
        "français":       "FR",
        "portuguese (brazil)": "PT-BR",
        "brazilian":      "PT-BR",
        "portuguese":     "PT",
        "italian":        "IT",
        "russian":        "RU",
        "ukrainian":      "UA",
        "polish":         "PL",
        "dutch":          "NL",
        "swedish":        "SE",
        "norwegian":      "NO",
        "finnish":        "FI",
        "danish":         "DK",
        "czech":          "CZ",
        "slovak":         "SK",
        "hungarian":      "HU",
        "romanian":       "RO",
        "turkish":        "TR",
        "greek":          "GR",
        "arabic":         "AR",
        "hebrew":         "IL",
        "japanese":       "JP",
        "korean":         "KR",
        "chinese":        "CN"
    }

    // Función principal
    function getShortCode(layout) {
        if (!layout)
            return "—"

        // Si el layout tiene shortName, lo usamos directamente
        if (layout.shortName && layout.shortName.length > 0)
            return layout.shortName.toUpperCase()

        // Buscar en el diccionario si el longName contiene alguna de las claves
        var name = (layout.longName || "").toLowerCase()

        for (var key in map) {
            if (name.includes(key))
                return map[key]
        }

        // Fallback: si no encontramos un código corto, usamos las dos primeras letras del longName
        if (layout.longName && layout.longName.length >= 2)
            return layout.longName.substring(0, 2).toUpperCase()
        
        // Si no hay longName
        return "—"
    }
}