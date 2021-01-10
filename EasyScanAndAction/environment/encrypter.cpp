#include "encrypter.h"
#include "jw78utils.h"

Encrypter::Encrypter():
    publicKeyMap(jw78::Utils::getWriteablePath() + "/publicKeys.json", "number", "publicKey")
{
    publicKeyMap.setFiledata("0", ":/keys/publicKey2020-07-26.txt");
    publicKeyMap.setFiledata("120415", ":/keys/publicKey120415.txt");
    publicKeyMap.setFiledata("274412", ":/keys/publicKey274412.txt");
    publicKeyMap.setFiledata("406176", ":/keys/publicKey406176.txt");
    publicKeyMap.setFiledata("465958", ":/keys/publicKey465958.txt");
    publicKeyMap.setFiledata("620974", ":/keys/publicKey620974.txt");
    publicKeyMap.setFiledata("647954", ":/keys/publicKey647954.txt");
    publicKeyMap.setFiledata("698005", ":/keys/publicKey698005.txt");
    publicKeyMap.setFiledata("774513", ":/keys/publicKey774513.txt");
    publicKeyMap.setFiledata("823902", ":/keys/publicKey823902.txt");
    publicKeyMap.setFiledata("873700", ":/keys/publicKey873700.txt");
    setPublicKey(0);

}

#include <fstream>

std::string Encrypter::publicKeyEncrypt(const std::string &plainText)
{
    Botan::AutoSeeded_RNG rng;

    Botan::secure_vector<uint8_t> data(plainText.data(), plainText.data() + plainText.length());

    const std::string OAEP_HASH = "SHA-256";
    const std::string aead_algo = "AES-256/GCM";

    std::unique_ptr<Botan::AEAD_Mode> aead =
            Botan::AEAD_Mode::create(aead_algo, Botan::ENCRYPTION);

    const Botan::OID aead_oid = Botan::OID::from_string(aead_algo);


    const Botan::AlgorithmIdentifier hash_id(OAEP_HASH, Botan::AlgorithmIdentifier::USE_EMPTY_PARAM);
    const Botan::AlgorithmIdentifier pk_alg_id("RSA/OAEP", hash_id.BER_encode());

    Botan::PK_Encryptor_EME enc(*publicKey, rng, "OAEP(" + OAEP_HASH + ")");

    const Botan::secure_vector<uint8_t> file_key = rng.random_vec(aead->key_spec().maximum_keylength());

    const std::vector<uint8_t> encrypted_key = enc.encrypt(file_key, rng);

    const Botan::secure_vector<uint8_t> nonce = rng.random_vec(aead->default_nonce_length());
    aead->set_key(file_key);
    aead->set_associated_data_vec(encrypted_key);
    aead->start(nonce);

    aead->finish(data);

    std::vector<uint8_t> buf;
    Botan::DER_Encoder der(buf);

    der.start_cons(Botan::SEQUENCE)
            .encode(pk_alg_id)
            .encode(encrypted_key, Botan::OCTET_STRING)
            .encode(aead_oid)
            .encode(nonce, Botan::OCTET_STRING)
            .encode(data, Botan::OCTET_STRING)
            .end_cons();
    std::string message(Botan::PEM_Code::encode(buf, "PUBKEY ENCRYPTED MESSAGE"));
    return message;
}

void Encrypter::setPublicKey(int qrCodeNumber)
{
    if (qrCodeNumber == 0 || qrCodeNumber == 9999)
    {
        /*        QFile publicKeyFile(":/keys/publicKey2020-07-26.txt");
        publicKeyFile.open(QIODevice::ReadOnly);
        QByteArray publicKeyData(publicKeyFile.readAll());
        Botan::DataSource_Memory datasource(publicKeyData.toStdString());
        publicKey = Botan::X509::load_key(datasource);*/
        qrCodeNumber = 0;
    }
    if (!publicKeyMap.contains(QString::number(qrCodeNumber)))
    {
        qrCodeNumber = 0;
    }
    Botan::DataSource_Memory datasource(publicKeyMap.get(QString::number(qrCodeNumber)).toStdString());
    publicKey = Botan::X509::load_key(datasource);
}

bool Encrypter::keyNumberOK(int number)
{
    if (number == 9999)
    {
        return true;
    }
    return publicKeyMap.contains(QString::number(number));
}
