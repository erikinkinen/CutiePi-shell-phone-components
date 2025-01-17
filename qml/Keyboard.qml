import QtQuick 2.14
import QtQuick.VirtualKeyboard 2.2
import QtQuick.VirtualKeyboard.Settings 2.2
import QtWayland.Compositor 1.14

InputPanel {
    id: inputPanel
    y: parent.height
    anchors.left: parent.left
    anchors.right: parent.right

    onStateChanged: {
        for (var i = 0; i < shellSurfaces.count; i++) {
            if (state == "visible") {
                shellSurfaces.get(i).shellSurface.toplevel.sendFullscreen(Qt.size(view.width, view.height - 20 * shellScaleFactor - height));
            } else {
                shellSurfaces.get(i).shellSurface.toplevel.sendFullscreen(Qt.size(view.width, view.height - 20 * shellScaleFactor));
            }
        }
        if (state == "visible") {
            content.keyboardHeight = height
        } else {
            content.keyboardHeight = 0
        }
    }

    states: State {
        name: "visible"
        when: inputPanel.active && root.state != "locked"
        PropertyChanges {
            target: inputPanel
            y: parent.height - inputPanel.height
        }
    }
    transitions: Transition {
        id: inputPanelTransition
        from: ""
        to: "visible"
        reversible: true
        ParallelAnimation {
            NumberAnimation {
                properties: "y"
                duration: 250
                easing.type: Easing.InOutQuad
            }
        }
    }
    Binding {
        target: InputContext
        property: "animating"
        value: inputPanelTransition.running
    }
}