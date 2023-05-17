#include <FelgoApplication>
#include <QApplication>
#include <QQmlApplicationEngine>


int main(int argc, char *argv[])
{

  QApplication app(argc, argv);

  FelgoApplication felgo;

  QQmlApplicationEngine engine;
  felgo.initialize(&engine);

  felgo.setMainQmlFileName(QStringLiteral("qml/HurryHungryMain.qml"));

  engine.load(QUrl(felgo.mainQmlFileName()));

  return app.exec();
}
