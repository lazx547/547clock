#include "gfile.h"
#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <gfile.h>

int main(int argc, char *argv[])
{
    QGuiApplication::setAttribute(Qt::AA_Use96Dpi);
    GFile file;
    file.setSource("./scale.txt");
    QString s=file.read();
    qputenv("QT_SCALE_FACTOR",s.toLatin1());


    QGuiApplication app(argc, argv);

    qmlRegisterType<GFile>("GFile",1,2,"GFile");
    QQmlApplicationEngine engine;
    const QUrl url(QStringLiteral("qrc:/main.qml"));
    QObject::connect(&engine, &QQmlApplicationEngine::objectCreated,
                     &app, [url](QObject *obj, const QUrl &objUrl) {
        if (!obj && url == objUrl)
            QCoreApplication::exit(-1);
    }, Qt::QueuedConnection);
    engine.load(url);

    return app.exec();
}
