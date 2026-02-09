#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQuickWindow>
#include <QQmlContext>
#include "pomodoro_timer.h"

int main(int argc, char *argv[])
{
    QGuiApplication app(argc, argv);

    app.setWindowIcon(QIcon(":/images/icon.png"));
    // @uri TimerModule
    qmlRegisterType<PomodoroTimer>("Pomodoro", 1, 0, "Pomodoro");

    QQmlApplicationEngine engine;
    const QUrl url("qrc:/qt/qml/Modular/MainWindow.qml");

    QObject::connect(
        &engine,
        &QQmlApplicationEngine::objectCreationFailed,
        &app,
        []() { QCoreApplication::exit(-1); },
        Qt::QueuedConnection);
    engine.loadFromModule("Modular", "MainWindow");

    return app.exec();
}
