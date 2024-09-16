#include <QtTest>
#include <QSslSocket>

class tst_OpenSsl : public QObject
{
    Q_OBJECT
private slots:
    void supportsSsl();
};

void tst_OpenSsl::supportsSsl() {
    QVERIFY(QSslSocket::supportsSsl());
}

QTEST_MAIN(tst_OpenSsl)

#include "tst_openssl.moc"
