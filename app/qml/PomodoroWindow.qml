import QtQuick 2.15
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Effects

import Pomodoro 1.0

ApplicationWindow {
    id: pomo_window
    visible: true
    title: "Pomodoro Timer"

    width: 250
    height: 250
    x: Screen.width  - width  - 100
    y: Screen.height - height - 50
    color: "transparent"

    flags: Qt.WindowStaysOnTopHint | Qt.FramelessWindowHint

    Pomodoro {
        id: pomodoro

        onFinished: {
            pomo_window.visible = true;
            pomo_window.raise();
            pomo_window.requestActivate();

            console.log("Time is up!")

            if (pomodoro.state === Pomodoro.BREAK) {
                root.showNotification("Time's up!", "25分経過しました。5分間の休憩に入ります。");
            }

            if (pomodoro.state === Pomodoro.WORK) {
                root.showNotification("Time's up!", "5分経過しました。作業を開始してください。");
            }
        }
    }

    DragHandler {
        target: null
        onActiveChanged: if (active) pomo_window.startSystemMove()
    }

    Rectangle {
        anchors.fill: parent
        anchors.margins: 10
        radius: 20

        opacity: 0.7
        color: "#222222"
        //color: pomodoro.state === Pomodoro.WORK ? "#df8585" : "#85cacf"
    }

    // Window Box
    Rectangle {
        id: pomo_panel
        anchors.fill: parent
        anchors.margins: 10
        radius: 20

        color: "transparent"

        border {
            width: 3
            color: "#cccccc"
        }

        // Time text.
        Text {
            id: time_text

            anchors.top: parent.top
            anchors.topMargin: 60
            anchors.horizontalCenter: parent.horizontalCenter

            text: {
                let m = Math.floor(pomodoro.currentTime / 60)
                let s = pomodoro.currentTime % 60
                return ("0" + m).slice(-2) + ":" + ("0" + s).slice(-2)
            }

            font {
                family: "Monospace"
                pixelSize: 48
                bold: true
            }

            color: "#eeeeee"
        }

        // State text.
        Text {
            id: state_text

            anchors.bottom: time_text.top
            anchors.horizontalCenter: parent.horizontalCenter

            text: pomodoro.state === Pomodoro.BREAK ? "休憩中" : "集中タイム"

            font {
                pixelSize: 16
                bold: true
            }

            color: "#ececec"
        }

        // UI::Buttons
        Column {
            anchors.bottom: parent.bottom
            anchors.bottomMargin: 25
            anchors.horizontalCenter: parent.horizontalCenter
            spacing: 10

            // Start
            Button {
                id: start_button

                width: 120; height: 30
                text: pomodoro.isRunning ? "STOP" : "START"

                palette.buttonText: pomodoro.isRunning ? "red" : "green"

                font {
                    family: "Monospace"
                    letterSpacing: 1
                }

                onClicked: pomodoro.isRunning ? pomodoro.stop() : pomodoro.start()
            }

            // Reset
            Button {
                id: reset_button

                width: 120; height: 30
                text: "RESET"

                font {
                    family: "Monospace"
                    letterSpacing: 1
                }

                onClicked: pomodoro.reset()
            }
        }

        Button {
            id: minimized_button

            width: 20; height: 20
            anchors.right: parent.right
            anchors.top: parent.top
            anchors.margins: 20
            text: "×"

            font {
                family: "Monospace"
                bold: true
            }

            onClicked: root.minimizedTimer()
        }

        SequentialAnimation {
            id: warning
            loops: Animation.Infinite
            running: pomodoro.isRunning && pomodoro.currentTime <= 10 && pomodoro.currentTime > 0

            PropertyAnimation {
                target: pomo_panel
                property: "border.color"
                from: "#cccccc"
                to: "#FF0000"
                duration: 500
            }
            PropertyAnimation {
                target: pomo_panel
                property: "border.color"
                from: "#FF0000"
                to: "#cccccc"
                duration: 500
            }
        }

        Connections {
            target: pomodoro
            function onTimeChanged() {
                if (pomodoro.currentTime === 0) {
                    warning.stop()
                }
            }
        }
    }

    MouseArea {
        anchors.fill: parent
        acceptedButtons: Qt.RightButton
        onClicked: rightclick_menu.open()
    }

    Menu {
        id: rightclick_menu

        MenuItem {
            text: qsTr("このモジュールを隠す")
            onTriggered: root.minimizedTimer()
        }
    }


}
