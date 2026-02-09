import QtQuick 2.15
import QtQuick.Window 2.15
import QtQuick.Controls 2.15
import Qt.labs.platform 1.1

import Pomodoro 1.0

// Window: Main(Transparent).
Item {
    id: root

    property Window timerWin: null

    function getModuleWindow(currentWin, qmlFile) {
        if (!currentWin) {
            var component = Qt.createComponent(qmlFile);
            if (component.status === Component.Ready) {
                return component.createObject();
            }
            console.error("Error loading " + qmlFile + ":", component.errorString());
            return null;
        }

        return currentWin;
    }

    function minimizedTimer() {
        timerWin = getModuleWindow(timerWin, "PomodoroWindow.qml");
        if (!timerWin) return;

        timerWin.visible = false;
        if (!timerWin.visible) {
            timerWin.hide();

            console.log("visible == false")
            return;
        }
    }

    function showTimer() {
        timerWin = getModuleWindow(timerWin, "PomodoroWindow.qml");
        if (!timerWin) return;

        if (!timerWin.visible) {
            timerWin.visible = true;
            timerWin.raise();
            timerWin.requestActivate();

            console.log("visible == true")
        }
    }

    function showNotification(title, message) {
        tray.showMessage(title, message, SystemTrayIcon.NoIcon, 5000);
    }

    SystemTrayIcon {
        id: tray
        visible: true
        icon.source: "qrc:/images/icon.png"

        menu: Menu {
            MenuItem {
                text: qsTr("Pomodoroを起動")
                onTriggered: root.showTimer()
            }

            MenuSeparator {
            }

            MenuItem {
                text: qsTr("すべてのモジュールを最小化");
                onTriggered: root.minimizedTimer()
            }

            MenuItem {
                text: qsTr("終了");
                onTriggered: Qt.quit()
            }
        }
    }

    // Application background.
    // Item {
    //     id: transparent_background

    //     z: 0
    //     anchors.fill: parent

    //     MouseArea {
    //         anchors.fill: parent

    //         acceptedButtons: Qt.NoButton
    //         hoverEnabled: false
    //         propagateComposedEvents: true
    //         onPressed: mouse.accepted = false; onReleased: mouse.accepted = false; onWheel: wheel.accepted = false
    //     }
    // }
}
