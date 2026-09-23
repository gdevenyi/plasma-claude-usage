import QtQuick
import QtQuick.Layouts
import org.kde.plasma.components as PlasmaComponents
import org.kde.kirigami as Kirigami

// Local token usage by model (pie), same window as the weekly limit.
// Reads root.modelTokens / root.pieColors / root.weeklyResetTime from main.qml.
ColumnLayout {
    visible: root.modelTokens.length > 0
    spacing: Kirigami.Units.smallSpacing

    PlasmaComponents.Label {
        text: i18n.tr("Tokens by Model") + (root.weeklyResetTime
            ? " · " + Qt.formatDate(new Date(root.weeklyResetTime.getTime() - 7 * 86400000), "MMM d") + " →"
            : "")
        font.bold: true
        font.pixelSize: Kirigami.Theme.smallFont.pixelSize
    }

    RowLayout {
        Layout.fillWidth: true
        spacing: Kirigami.Units.largeSpacing

        Canvas {
            Layout.preferredWidth: Kirigami.Units.gridUnit * 5
            Layout.preferredHeight: Kirigami.Units.gridUnit * 5

            property var _data: root.modelTokens
            on_DataChanged: requestPaint()

            onPaint: {
                var ctx = getContext("2d")
                ctx.reset()
                var cx = width / 2, cy = height / 2
                var r = Math.min(width, height) / 2 - 2
                var start = -Math.PI / 2
                for (var i = 0; i < root.modelTokens.length; i++) {
                    var ang = root.modelTokens[i].share / 100 * 2 * Math.PI
                    ctx.beginPath()
                    ctx.moveTo(cx, cy)
                    ctx.arc(cx, cy, r, start, start + ang)
                    ctx.closePath()
                    ctx.fillStyle = root.pieColors[i % root.pieColors.length]
                    ctx.fill()
                    start += ang
                }
            }
        }

        ColumnLayout {
            Layout.fillWidth: true
            spacing: Kirigami.Units.smallSpacing / 2

            Repeater {
                model: root.modelTokens

                RowLayout {
                    required property var modelData
                    required property int index
                    Layout.fillWidth: true
                    spacing: Kirigami.Units.smallSpacing

                    Rectangle {
                        Layout.preferredWidth: 10
                        Layout.preferredHeight: 10
                        radius: 2
                        color: root.pieColors[index % root.pieColors.length]
                    }
                    PlasmaComponents.Label {
                        text: modelData.name
                        font.pixelSize: Kirigami.Theme.smallFont.pixelSize
                        elide: Text.ElideRight
                        Layout.fillWidth: true
                    }
                    PlasmaComponents.Label {
                        text: Math.round(modelData.share) + "% · " + root.formatTokens(modelData.tokens)
                        font.pixelSize: Kirigami.Theme.smallFont.pixelSize
                        color: Kirigami.Theme.disabledTextColor
                    }
                }
            }
        }
    }
}
